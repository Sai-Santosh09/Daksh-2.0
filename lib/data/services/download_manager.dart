import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/asset.dart';
import 'content_service.dart';

enum DownloadStatus {
  pending,
  downloading,
  paused,
  completed,
  failed,
  cancelled,
}

enum AssetDownloadStatus {
  notDownloaded,
  downloading,
  downloaded,
  failed,
  corrupted,
  paused,
}

class DownloadTask {
  final String id;
  final Asset asset;
  final String url;
  final String localPath;
  final int totalBytes;
  final int downloadedBytes;
  final DownloadStatus status;
  final double progress;
  final String? error;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final CancelToken? cancelToken;

  const DownloadTask({
    required this.id,
    required this.asset,
    required this.url,
    required this.localPath,
    required this.totalBytes,
    required this.downloadedBytes,
    required this.status,
    required this.progress,
    this.error,
    this.startedAt,
    this.completedAt,
    this.cancelToken,
  });

  DownloadTask copyWith({
    String? id,
    Asset? asset,
    String? url,
    String? localPath,
    int? totalBytes,
    int? downloadedBytes,
    DownloadStatus? status,
    double? progress,
    String? error,
    DateTime? startedAt,
    DateTime? completedAt,
    CancelToken? cancelToken,
  }) {
    return DownloadTask(
      id: id ?? this.id,
      asset: asset ?? this.asset,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      error: error,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelToken: cancelToken ?? this.cancelToken,
    );
  }

  bool get isDownloading => status == DownloadStatus.downloading;
  bool get isPaused => status == DownloadStatus.paused;
  bool get isCompleted => status == DownloadStatus.completed;
  bool get isFailed => status == DownloadStatus.failed;
  bool get isCancelled => status == DownloadStatus.cancelled;
  bool get canResume => isPaused || isFailed;
  bool get canPause => isDownloading;
  bool get canCancel => isDownloading || isPaused;

  String get formattedProgress => '${(progress * 100).toStringAsFixed(1)}%';
  String get formattedDownloadedSize => _formatBytes(downloadedBytes);
  String get formattedTotalSize => _formatBytes(totalBytes);
  String get formattedSpeed {
    if (startedAt == null) return '0 B/s';
    final elapsed = DateTime.now().difference(startedAt!).inSeconds;
    if (elapsed == 0) return '0 B/s';
    final speed = downloadedBytes / elapsed;
    return '${_formatBytes(speed.round())}/s';
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class DownloadManager {
  static const int _maxConcurrentDownloads = 3;
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 5);

  final Dio _dio;
  final Connectivity _connectivity;
  final Map<String, DownloadTask> _downloads = {};
  final StreamController<DownloadTask> _downloadController = StreamController.broadcast();
  final List<String> _activeDownloads = [];

  DownloadManager({
    required Dio dio,
    required Connectivity connectivity,
  }) : _dio = dio,
       _connectivity = connectivity;

  // Getters
  Map<String, DownloadTask> get downloads => Map.unmodifiable(_downloads);
  Stream<DownloadTask> get downloadStream => _downloadController.stream;
  List<DownloadTask> get activeDownloads => _downloads.values
      .where((task) => task.isDownloading)
      .toList();
  List<DownloadTask> get completedDownloads => _downloads.values
      .where((task) => task.isCompleted)
      .toList();
  List<DownloadTask> get failedDownloads => _downloads.values
      .where((task) => task.isFailed)
      .toList();

  // Download management
  Future<void> downloadAsset(Asset asset) async {
    if (_downloads.containsKey(asset.id)) {
      final existingTask = _downloads[asset.id]!;
      if (existingTask.isCompleted) {
        throw Exception('Asset already downloaded');
      }
      if (existingTask.isDownloading) {
        throw Exception('Asset is already being downloaded');
      }
    }

    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection available');
      }

      // Check storage space
      await _checkStorageSpace(asset.sizeBytes);

      // Create download task
      final task = await _createDownloadTask(asset);
      _downloads[asset.id] = task;
      _downloadController.add(task);

      // Start download
      await _startDownload(task);
    } catch (e) {
      final task = _downloads[asset.id];
      if (task != null) {
        final failedTask = task.copyWith(
          status: DownloadStatus.failed,
          error: e.toString(),
        );
        _downloads[asset.id] = failedTask;
        _downloadController.add(failedTask);
      }
      rethrow;
    }
  }

  Future<DownloadTask> _createDownloadTask(Asset asset) async {
    final cacheDir = await _getCacheDirectory();
    final fileName = '${asset.id}${_getFileExtension(asset.mimeType)}';
    final localPath = path.join(cacheDir.path, fileName);

    return DownloadTask(
      id: asset.id,
      asset: asset,
      url: asset.url,
      localPath: localPath,
      totalBytes: asset.sizeBytes,
      downloadedBytes: 0,
      status: DownloadStatus.pending,
      progress: 0.0,
      startedAt: DateTime.now(),
    );
  }

  Future<void> _startDownload(DownloadTask task) async {
    if (_activeDownloads.length >= _maxConcurrentDownloads) {
      // Queue the download
      final queuedTask = task.copyWith(status: DownloadStatus.pending);
      _downloads[task.id] = queuedTask;
      _downloadController.add(queuedTask);
      return;
    }

    _activeDownloads.add(task.id);
    final cancelToken = CancelToken();
    
    final downloadingTask = task.copyWith(
      status: DownloadStatus.downloading,
      cancelToken: cancelToken,
    );
    _downloads[task.id] = downloadingTask;
    _downloadController.add(downloadingTask);

    try {
      await _performDownload(downloadingTask);
    } catch (e) {
      final failedTask = downloadingTask.copyWith(
        status: DownloadStatus.failed,
        error: e.toString(),
      );
      _downloads[task.id] = failedTask;
      _downloadController.add(failedTask);
    } finally {
      _activeDownloads.remove(task.id);
      _processQueue();
    }
  }

  Future<void> _performDownload(DownloadTask task) async {
    final file = File(task.localPath);
    final parentDir = file.parent;
    if (!await parentDir.exists()) {
      await parentDir.create(recursive: true);
    }

    int retryCount = 0;
    while (retryCount < _maxRetries) {
      try {
        await _dio.download(
          task.url,
          task.localPath,
          cancelToken: task.cancelToken,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              final progress = received / total;
              final updatedTask = task.copyWith(
                downloadedBytes: received,
                totalBytes: total,
                progress: progress,
              );
              _downloads[task.id] = updatedTask;
              _downloadController.add(updatedTask);
            }
          },
        );

        // Verify download
        await _verifyDownload(task);
        
        // Mark as completed
        final completedTask = task.copyWith(
          status: DownloadStatus.completed,
          progress: 1.0,
          completedAt: DateTime.now(),
        );
        _downloads[task.id] = completedTask;
        _downloadController.add(completedTask);
        return;

      } catch (e) {
        retryCount++;
        if (retryCount >= _maxRetries) {
          rethrow;
        }
        await Future.delayed(_retryDelay);
      }
    }
  }

  Future<void> _verifyDownload(DownloadTask task) async {
    final file = File(task.localPath);
    if (!await file.exists()) {
      throw Exception('Downloaded file not found');
    }

    final fileSize = await file.length();
    if (fileSize != task.totalBytes) {
      throw Exception('Downloaded file size mismatch');
    }

    // Verify checksum if provided
    if (task.asset.checksum != null) {
      final fileBytes = await file.readAsBytes();
      final digest = sha256.convert(fileBytes);
      if (digest.toString() != task.asset.checksum) {
        await file.delete();
        throw Exception('File checksum verification failed');
      }
    }
  }

  Future<void> pauseDownload(String assetId) async {
    final task = _downloads[assetId];
    if (task == null || !task.canPause) return;

    task.cancelToken?.cancel();
    _activeDownloads.remove(assetId);

    final pausedTask = task.copyWith(status: DownloadStatus.paused);
    _downloads[assetId] = pausedTask;
    _downloadController.add(pausedTask);

    _processQueue();
  }

  Future<void> resumeDownload(String assetId) async {
    final task = _downloads[assetId];
    if (task == null || !task.canResume) return;

    await _startDownload(task);
  }

  Future<void> cancelDownload(String assetId) async {
    final task = _downloads[assetId];
    if (task == null || !task.canCancel) return;

    task.cancelToken?.cancel();
    _activeDownloads.remove(assetId);

    // Delete partial file
    final file = File(task.localPath);
    if (await file.exists()) {
      await file.delete();
    }

    final cancelledTask = task.copyWith(status: DownloadStatus.cancelled);
    _downloads[assetId] = cancelledTask;
    _downloadController.add(cancelledTask);

    _processQueue();
  }

  Future<void> retryDownload(String assetId) async {
    final task = _downloads[assetId];
    if (task == null || !task.isFailed) return;

    final retryTask = task.copyWith(
      status: DownloadStatus.pending,
      error: null,
      startedAt: DateTime.now(),
    );
    _downloads[assetId] = retryTask;
    _downloadController.add(retryTask);

    await _startDownload(retryTask);
  }

  void _processQueue() {
    final pendingTasks = _downloads.values
        .where((task) => task.status == DownloadStatus.pending)
        .toList();

    for (final task in pendingTasks) {
      if (_activeDownloads.length < _maxConcurrentDownloads) {
        _startDownload(task);
      }
    }
  }

  // Storage management
  Future<void> _checkStorageSpace(int requiredBytes) async {
    final cacheDir = await _getCacheDirectory();
    final stat = await cacheDir.stat();
    // Note: This is a simplified check. In a real app, you'd want to check
    // available disk space more accurately.
    if (stat.size + requiredBytes > 1024 * 1024 * 1024) { // 1GB limit
      throw Exception('Insufficient storage space');
    }
  }

  Future<Directory> _getCacheDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory(path.join(appDir.path, 'downloads'));
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  String _getFileExtension(String mimeType) {
    switch (mimeType) {
      case 'video/mp4':
        return '.mp4';
      case 'audio/mpeg':
        return '.mp3';
      case 'application/pdf':
        return '.pdf';
      case 'image/jpeg':
        return '.jpg';
      case 'image/png':
        return '.png';
      case 'application/json':
        return '.json';
      default:
        return '.bin';
    }
  }

  // Utility methods
  Future<int> getTotalDownloadedSize() async {
    int totalSize = 0;
    for (final task in completedDownloads) {
      final file = File(task.localPath);
      if (await file.exists()) {
        totalSize += await file.length();
      }
    }
    return totalSize;
  }

  Future<void> clearCompletedDownloads() async {
    for (final task in completedDownloads) {
      final file = File(task.localPath);
      if (await file.exists()) {
        await file.delete();
      }
      _downloads.remove(task.id);
    }
  }

  Future<void> clearAllDownloads() async {
    for (final task in _downloads.values) {
      if (task.cancelToken != null) {
        task.cancelToken!.cancel();
      }
      final file = File(task.localPath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    _downloads.clear();
    _activeDownloads.clear();
  }

  DownloadTask? getDownloadTask(String assetId) {
    return _downloads[assetId];
  }

  void dispose() {
    _downloadController.close();
    for (final task in _downloads.values) {
      task.cancelToken?.cancel();
    }
  }
}


