import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson_model.dart';
import '../models/asset_model.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/asset.dart';

class ContentService {
  static const String _manifestCacheKey = 'content_manifest';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _baseUrl = 'https://api.daksh.com/v1';
  
  final Dio _dio;
  final SharedPreferences _prefs;
  final Connectivity _connectivity;
  
  ContentService({
    required Dio dio,
    required SharedPreferences prefs,
    required Connectivity connectivity,
  }) : _dio = dio,
       _prefs = prefs,
       _connectivity = connectivity;

  // Cache directory for downloaded assets
  Future<Directory> get _cacheDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory(path.join(appDir.path, 'content_cache'));
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  // Get manifest from cache or network
  Future<ContentManifest> getManifest({bool forceRefresh = false}) async {
    try {
      // Check if we have internet and should refresh
      final hasInternet = await _hasInternetConnection();
      final lastSync = _prefs.getInt(_lastSyncKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      final shouldRefresh = forceRefresh || 
          (hasInternet && (now - lastSync) > 24 * 60 * 60 * 1000); // 24 hours

      if (shouldRefresh && hasInternet) {
        return await _fetchManifestFromNetwork();
      } else {
        return await _getManifestFromCache();
      }
    } catch (e) {
      // Fallback to cache if network fails
      return await _getManifestFromCache();
    }
  }

  // Fetch manifest from network
  Future<ContentManifest> _fetchManifestFromNetwork() async {
    try {
      final response = await _dio.get('$_baseUrl/content/manifest');
      final manifest = ContentManifest.fromJson(response.data);
      
      // Cache the manifest
      await _cacheManifest(manifest);
      
      // Update last sync timestamp
      await _prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
      
      return manifest;
    } catch (e) {
      throw ContentServiceException('Failed to fetch manifest: $e');
    }
  }

  // Get manifest from cache
  Future<ContentManifest> _getManifestFromCache() async {
    final cachedData = _prefs.getString(_manifestCacheKey);
    if (cachedData == null) {
      throw ContentServiceException('No cached manifest available');
    }
    
    try {
      final json = jsonDecode(cachedData);
      return ContentManifest.fromJson(json);
    } catch (e) {
      throw ContentServiceException('Failed to parse cached manifest: $e');
    }
  }

  // Cache manifest locally
  Future<void> _cacheManifest(ContentManifest manifest) async {
    final json = jsonEncode(manifest.toJson());
    await _prefs.setString(_manifestCacheKey, json);
  }

  // Get lessons (offline-first)
  Future<List<Lesson>> getLessons({
    String? category,
    String? difficulty,
    bool includeAssets = false,
  }) async {
    try {
      final manifest = await getManifest();
      var lessons = manifest.lessons;

      // Filter by category if specified
      if (category != null) {
        lessons = lessons.where((l) => l.category == category).toList();
      }

      // Filter by difficulty if specified
      if (difficulty != null) {
        lessons = lessons.where((l) => l.difficulty == difficulty).toList();
      }

      // Load assets if requested
      if (includeAssets) {
        for (final lesson in lessons) {
          lesson.assetIds.forEach((assetId) async {
            try {
              await getAsset(assetId);
            } catch (e) {
              // Asset not available, continue
            }
          });
        }
      }

      return lessons;
    } catch (e) {
      throw ContentServiceException('Failed to get lessons: $e');
    }
  }

  // Get single lesson
  Future<Lesson?> getLesson(String lessonId) async {
    try {
      final manifest = await getManifest();
      return manifest.lessons.firstWhere(
        (lesson) => lesson.id == lessonId,
        orElse: () => throw StateError('Lesson not found'),
      );
    } catch (e) {
      return null;
    }
  }

  // Get asset (offline-first)
  Future<Asset> getAsset(String assetId) async {
    try {
      // First check if asset is already downloaded
      final localAsset = await _getLocalAsset(assetId);
      if (localAsset != null) {
        return localAsset;
      }

      // If not downloaded, try to download if internet is available
      final hasInternet = await _hasInternetConnection();
      if (hasInternet) {
        return await _downloadAsset(assetId);
      } else {
        throw ContentServiceException('Asset not available offline and no internet connection');
      }
    } catch (e) {
      throw ContentServiceException('Failed to get asset: $e');
    }
  }

  // Get local asset
  Future<Asset?> _getLocalAsset(String assetId) async {
    try {
      final cacheDir = await _cacheDirectory;
      final assetFile = File(path.join(cacheDir.path, '$assetId.json'));
      
      if (await assetFile.exists()) {
        final json = await assetFile.readAsString();
        final assetData = jsonDecode(json);
        return AssetModel.fromJson(assetData).toEntity();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Download asset from network
  Future<Asset> _downloadAsset(String assetId) async {
    try {
      // Get asset metadata from manifest
      final manifest = await getManifest();
      final assetInfo = manifest.assets.firstWhere(
        (asset) => asset.id == assetId,
        orElse: () => throw StateError('Asset not found in manifest'),
      );

      // Update status to downloading
      final downloadingAsset = assetInfo.copyWith(status: AssetStatus.downloading);
      await _saveLocalAsset(downloadingAsset);

      // Download the asset file
      final cacheDir = await _cacheDirectory;
      final assetFile = File(path.join(cacheDir.path, assetId));
      
      await _dio.download(assetInfo.url, assetFile.path);

      // Verify download if checksum is provided
      if (assetInfo.checksum != null) {
        final downloadedChecksum = await _calculateFileChecksum(assetFile);
        if (downloadedChecksum != assetInfo.checksum) {
          await assetFile.delete();
          throw ContentServiceException('Asset checksum verification failed');
        }
      }

      // Update asset with local path and downloaded status
      final downloadedAsset = assetInfo.copyWith(
        localPath: assetFile.path,
        status: AssetStatus.downloaded,
        downloadedAt: DateTime.now(),
      );

      await _saveLocalAsset(downloadedAsset);
      return downloadedAsset;

    } catch (e) {
      // Mark asset as failed
      try {
        final manifest = await getManifest();
        final assetInfo = manifest.assets.firstWhere((asset) => asset.id == assetId);
        final failedAsset = assetInfo.copyWith(status: AssetStatus.failed);
        await _saveLocalAsset(failedAsset);
      } catch (_) {
        // Ignore errors when marking as failed
      }
      
      throw ContentServiceException('Failed to download asset: $e');
    }
  }

  // Save asset locally
  Future<void> _saveLocalAsset(Asset asset) async {
    final cacheDir = await _cacheDirectory;
    final assetFile = File(path.join(cacheDir.path, '${asset.id}.json'));
    final assetModel = AssetModel.fromEntity(asset);
    await assetFile.writeAsString(jsonEncode(assetModel.toJson()));
  }

  // Calculate file checksum
  Future<String> _calculateFileChecksum(File file) async {
    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Check internet connection
  Future<bool> _hasInternetConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      
      // Additional check by trying to reach a known endpoint
      final response = await _dio.get('$_baseUrl/health', 
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Download lesson assets
  Future<void> downloadLessonAssets(String lessonId) async {
    try {
      final lesson = await getLesson(lessonId);
      if (lesson == null) {
        throw ContentServiceException('Lesson not found');
      }

      final hasInternet = await _hasInternetConnection();
      if (!hasInternet) {
        throw ContentServiceException('No internet connection available');
      }

      // Download all assets for the lesson
      for (final assetId in lesson.assetIds) {
        try {
          await getAsset(assetId);
        } catch (e) {
          // Log error but continue with other assets
          print('Failed to download asset $assetId: $e');
        }
      }
    } catch (e) {
      throw ContentServiceException('Failed to download lesson assets: $e');
    }
  }

  // Clear cache
  Future<void> clearCache() async {
    try {
      final cacheDir = await _cacheDirectory;
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
      await _prefs.remove(_manifestCacheKey);
      await _prefs.remove(_lastSyncKey);
    } catch (e) {
      throw ContentServiceException('Failed to clear cache: $e');
    }
  }

  // Get cache size
  Future<int> getCacheSize() async {
    try {
      final cacheDir = await _cacheDirectory;
      if (!await cacheDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  // Get downloaded assets
  Future<List<Asset>> getDownloadedAssets() async {
    try {
      final cacheDir = await _cacheDirectory;
      if (!await cacheDir.exists()) {
        return [];
      }

      final List<Asset> assets = [];
      await for (final entity in cacheDir.list()) {
        if (entity is File && entity.path.endsWith('.json')) {
          try {
            final json = await entity.readAsString();
            final assetData = jsonDecode(json);
            final asset = AssetModel.fromJson(assetData).toEntity();
            if (asset.isDownloaded) {
              assets.add(asset);
            }
          } catch (e) {
            // Skip corrupted files
            continue;
          }
        }
      }
      return assets;
    } catch (e) {
      return [];
    }
  }
}

// Content manifest class
class ContentManifest {
  final String version;
  final DateTime lastUpdated;
  final List<Lesson> lessons;
  final List<Asset> assets;

  ContentManifest({
    required this.version,
    required this.lastUpdated,
    required this.lessons,
    required this.assets,
  });

  factory ContentManifest.fromJson(Map<String, dynamic> json) {
    return ContentManifest(
      version: json['version'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      lessons: (json['lessons'] as List)
          .map((lessonJson) => LessonModel.fromJson(lessonJson).toEntity())
          .toList(),
      assets: (json['assets'] as List)
          .map((assetJson) => AssetModel.fromJson(assetJson).toEntity())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'lastUpdated': lastUpdated.toIso8601String(),
      'lessons': lessons.map((lesson) => LessonModel.fromEntity(lesson).toJson()).toList(),
      'assets': assets.map((asset) => AssetModel.fromEntity(asset).toJson()).toList(),
    };
  }
}

// Custom exception class
class ContentServiceException implements Exception {
  final String message;
  ContentServiceException(this.message);

  @override
  String toString() => 'ContentServiceException: $message';
}


