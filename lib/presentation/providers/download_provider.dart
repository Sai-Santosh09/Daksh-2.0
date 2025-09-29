import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/services/download_manager.dart';
import '../../domain/entities/asset.dart';
import 'content_provider.dart';

// Download manager provider
final downloadManagerProvider = StateNotifierProvider<DownloadManagerNotifier, Map<String, DownloadTask>>((ref) {
  final dio = ref.watch(dioProvider);
  final connectivity = ref.watch(connectivityProvider);
  final manager = DownloadManager(dio: dio, connectivity: connectivity);
  return DownloadManagerNotifier(manager);
});

// Individual download task provider
final downloadTaskProvider = FutureProvider.family<DownloadTask?, String>((ref, assetId) async {
  final downloads = ref.watch(downloadManagerProvider);
  return downloads[assetId];
});

// Download manager notifier
class DownloadManagerNotifier extends StateNotifier<Map<String, DownloadTask>> {
  final DownloadManager _manager;
  late StreamSubscription<DownloadTask> _downloadSubscription;

  DownloadManagerNotifier(this._manager) : super({}) {
    _initializeSubscription();
  }

  void _initializeSubscription() {
    _downloadSubscription = _manager.downloadStream.listen((task) {
      state = {...state, task.id: task};
    });
  }

  Future<void> downloadAsset(Asset asset) async {
    try {
      await _manager.downloadAsset(asset);
    } catch (e) {
      // Error is handled by the download manager and reflected in the task state
      rethrow;
    }
  }

  Future<void> pauseDownload(String assetId) async {
    await _manager.pauseDownload(assetId);
  }

  Future<void> resumeDownload(String assetId) async {
    await _manager.resumeDownload(assetId);
  }

  Future<void> cancelDownload(String assetId) async {
    await _manager.cancelDownload(assetId);
  }

  Future<void> retryDownload(String assetId) async {
    await _manager.retryDownload(assetId);
  }

  Future<void> clearCompletedDownloads() async {
    await _manager.clearCompletedDownloads();
    // Update state to remove completed downloads
    state = Map.fromEntries(
      state.entries.where((entry) => !entry.value.isCompleted),
    );
  }

  Future<void> clearAllDownloads() async {
    await _manager.clearAllDownloads();
    state = {};
  }

  DownloadTask? getDownloadTask(String assetId) {
    return _manager.getDownloadTask(assetId);
  }

  List<DownloadTask> get activeDownloads => _manager.activeDownloads;
  List<DownloadTask> get completedDownloads => _manager.completedDownloads;
  List<DownloadTask> get failedDownloads => _manager.failedDownloads;

  Future<int> getTotalDownloadedSize() async {
    return await _manager.getTotalDownloadedSize();
  }

  @override
  void dispose() {
    _downloadSubscription.cancel();
    _manager.dispose();
    super.dispose();
  }
}

// Download statistics provider
final downloadStatsProvider = FutureProvider<DownloadStats>((ref) async {
  final manager = ref.watch(downloadManagerProvider.notifier);
  final totalSize = await manager.getTotalDownloadedSize();
  final downloads = ref.watch(downloadManagerProvider);
  
  return DownloadStats(
    totalDownloads: downloads.length,
    activeDownloads: manager.activeDownloads.length,
    completedDownloads: manager.completedDownloads.length,
    failedDownloads: manager.failedDownloads.length,
    totalDownloadedSize: totalSize,
  );
});

// Download stats model
class DownloadStats {
  final int totalDownloads;
  final int activeDownloads;
  final int completedDownloads;
  final int failedDownloads;
  final int totalDownloadedSize;

  const DownloadStats({
    required this.totalDownloads,
    required this.activeDownloads,
    required this.completedDownloads,
    required this.failedDownloads,
    required this.totalDownloadedSize,
  });

  String get formattedTotalSize {
    if (totalDownloadedSize < 1024) return '$totalDownloadedSize B';
    if (totalDownloadedSize < 1024 * 1024) return '${(totalDownloadedSize / 1024).toStringAsFixed(1)} KB';
    if (totalDownloadedSize < 1024 * 1024 * 1024) return '${(totalDownloadedSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(totalDownloadedSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

// Storage management provider
final storageProvider = StateNotifierProvider<StorageNotifier, StorageState>((ref) {
  return StorageNotifier();
});

// Storage state
class StorageState {
  final int totalSpace;
  final int usedSpace;
  final int availableSpace;
  final bool isLoading;
  final String? error;

  const StorageState({
    this.totalSpace = 0,
    this.usedSpace = 0,
    this.availableSpace = 0,
    this.isLoading = false,
    this.error,
  });

  StorageState copyWith({
    int? totalSpace,
    int? usedSpace,
    int? availableSpace,
    bool? isLoading,
    String? error,
  }) {
    return StorageState(
      totalSpace: totalSpace ?? this.totalSpace,
      usedSpace: usedSpace ?? this.usedSpace,
      availableSpace: availableSpace ?? this.availableSpace,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  double get usagePercentage {
    if (totalSpace == 0) return 0.0;
    return usedSpace / totalSpace;
  }

  String get formattedTotalSpace => _formatBytes(totalSpace);
  String get formattedUsedSpace => _formatBytes(usedSpace);
  String get formattedAvailableSpace => _formatBytes(availableSpace);

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

// Storage notifier
class StorageNotifier extends StateNotifier<StorageState> {
  StorageNotifier() : super(const StorageState()) {
    _checkStorage();
  }

  Future<void> _checkStorage() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // This is a simplified storage check
      // In a real app, you'd want to use platform-specific APIs
      // to get accurate storage information
      
      // For now, we'll simulate storage data
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(
        isLoading: false,
        totalSpace: 32 * 1024 * 1024 * 1024, // 32 GB
        usedSpace: 8 * 1024 * 1024 * 1024,   // 8 GB
        availableSpace: 24 * 1024 * 1024 * 1024, // 24 GB
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await _checkStorage();
  }

  bool hasEnoughSpace(int requiredBytes) {
    return state.availableSpace >= requiredBytes;
  }

  double getSpaceUsagePercentage() {
    return state.usagePercentage;
  }
}

// Pre-download provider for lesson assets
final preDownloadProvider = StateNotifierProvider.family<PreDownloadNotifier, PreDownloadState, String>((ref, lessonId) {
  return PreDownloadNotifier(ref, lessonId);
});

// Pre-download state
class PreDownloadState {
  final bool isDownloading;
  final double progress;
  final int downloadedAssets;
  final int totalAssets;
  final String? error;
  final List<String> completedAssetIds;

  const PreDownloadState({
    this.isDownloading = false,
    this.progress = 0.0,
    this.downloadedAssets = 0,
    this.totalAssets = 0,
    this.error,
    this.completedAssetIds = const [],
  });

  PreDownloadState copyWith({
    bool? isDownloading,
    double? progress,
    int? downloadedAssets,
    int? totalAssets,
    String? error,
    List<String>? completedAssetIds,
  }) {
    return PreDownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      progress: progress ?? this.progress,
      downloadedAssets: downloadedAssets ?? this.downloadedAssets,
      totalAssets: totalAssets ?? this.totalAssets,
      error: error,
      completedAssetIds: completedAssetIds ?? this.completedAssetIds,
    );
  }

  String get progressText => '${downloadedAssets}/$totalAssets assets';
  String get progressPercentage => '${(progress * 100).toStringAsFixed(1)}%';
}

// Pre-download notifier
class PreDownloadNotifier extends StateNotifier<PreDownloadState> {
  final Ref ref;
  final String lessonId;

  PreDownloadNotifier(this.ref, this.lessonId) : super(const PreDownloadState());

  Future<void> downloadLessonAssets() async {
    try {
      state = state.copyWith(isDownloading: true, error: null);

      // Get lesson assets
      final lesson = await ref.read(lessonProvider(lessonId).future);
      if (lesson == null) {
        throw Exception('Lesson not found');
      }

      final assetIds = lesson.assetIds;
      state = state.copyWith(totalAssets: assetIds.length);

      // Download each asset
      for (int i = 0; i < assetIds.length; i++) {
        final assetId = assetIds[i];
        
        try {
          // Get asset from content service
          final contentService = await ref.read(contentServiceProvider.future);
          final asset = await contentService.getAsset(assetId);
          
          // Download asset
          await ref.read(downloadManagerProvider.notifier).downloadAsset(asset);
          
          // Update progress
          final completedIds = [...state.completedAssetIds, assetId];
          final progress = (i + 1) / assetIds.length;
          
          state = state.copyWith(
            downloadedAssets: i + 1,
            progress: progress,
            completedAssetIds: completedIds,
          );
          
        } catch (e) {
          // Continue with other assets even if one fails
          print('Failed to download asset $assetId: $e');
        }
      }

      state = state.copyWith(isDownloading: false);
    } catch (e) {
      state = state.copyWith(
        isDownloading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
