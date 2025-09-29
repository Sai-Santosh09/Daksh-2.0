import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/asset.dart';
import '../providers/download_provider.dart';
import '../../data/services/download_manager.dart';

class DownloadProgressWidget extends ConsumerWidget {
  final Asset asset;
  final bool showDetails;
  final VoidCallback? onTap;

  const DownloadProgressWidget({
    super.key,
    required this.asset,
    this.showDetails = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadTask = ref.watch(downloadTaskProvider(asset.id));

    return downloadTask.when(
      data: (task) {
        if (task == null) {
          return _buildDownloadButton(context, ref);
        }

        return _buildDownloadProgress(context, ref, task);
      },
      loading: () => _buildLoadingWidget(),
      error: (error, stack) => _buildErrorWidget(context, ref, error.toString()),
    );
  }

  Widget _buildDownloadButton(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            _getAssetIcon(asset.type),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(asset.name),
        subtitle: Text('${asset.formattedSize} • ${asset.mimeType}'),
        trailing: SizedBox(
          width: AppTheme.minTapTargetSize,
          height: AppTheme.minTapTargetSize,
          child: ElevatedButton(
            onPressed: () => _startDownload(context, ref),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.download),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDownloadProgress(BuildContext context, WidgetRef ref, DownloadTask task) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(task.status).withOpacity(0.1),
              child: Icon(
                _getStatusIcon(task.status),
                color: _getStatusColor(task.status),
              ),
            ),
            title: Text(asset.name),
            subtitle: Text(_getStatusText(task)),
            trailing: _buildActionButtons(context, ref, task),
          ),
          if (showDetails && task.isDownloading) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                children: [
                  // Progress bar
                  LinearProgressIndicator(
                    value: task.progress,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  // Progress details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        task.formattedProgress,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${task.formattedDownloadedSize} / ${task.formattedTotalSize}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  // Speed and time remaining
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Speed: ${task.formattedSpeed}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        _getTimeRemaining(task),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, DownloadTask task) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (task.canPause)
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () => _pauseDownload(context, ref),
            tooltip: 'Pause download',
          ),
        if (task.canResume)
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => _resumeDownload(context, ref),
            tooltip: 'Resume download',
          ),
        if (task.isFailed)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _retryDownload(context, ref),
            tooltip: 'Retry download',
          ),
        if (task.canCancel)
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => _cancelDownload(context, ref),
            tooltip: 'Cancel download',
          ),
        if (task.isCompleted)
          IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: () => _openFile(context),
            tooltip: 'Open file',
          ),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return const Card(
      child: ListTile(
        leading: CircularProgressIndicator(),
        title: Text('Loading...'),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, String error) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.error, color: Colors.white),
        ),
        title: const Text('Download Error'),
        subtitle: Text(error),
        trailing: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _startDownload(context, ref),
          tooltip: 'Retry download',
        ),
      ),
    );
  }

  // Helper methods
  IconData _getAssetIcon(AssetType type) {
    switch (type) {
      case AssetType.video:
        return Icons.videocam;
      case AssetType.audio:
        return Icons.audiotrack;
      case AssetType.document:
        return Icons.description;
      case AssetType.image:
        return Icons.image;
      case AssetType.animation:
        return Icons.animation;
      case AssetType.interactive:
        return Icons.touch_app;
    }
  }

  Color _getStatusColor(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.pending:
        return Colors.orange;
      case DownloadStatus.downloading:
        return Colors.blue;
      case DownloadStatus.paused:
        return Colors.yellow.shade700;
      case DownloadStatus.completed:
        return Colors.green;
      case DownloadStatus.failed:
        return Colors.red;
      case DownloadStatus.cancelled:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.pending:
        return Icons.schedule;
      case DownloadStatus.downloading:
        return Icons.download;
      case DownloadStatus.paused:
        return Icons.pause;
      case DownloadStatus.completed:
        return Icons.check_circle;
      case DownloadStatus.failed:
        return Icons.error;
      case DownloadStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusText(DownloadTask task) {
    switch (task.status) {
      case DownloadStatus.pending:
        return 'Queued for download';
      case DownloadStatus.downloading:
        return 'Downloading...';
      case DownloadStatus.paused:
        return 'Download paused';
      case DownloadStatus.completed:
        return 'Download completed';
      case DownloadStatus.failed:
        return 'Download failed: ${task.error ?? 'Unknown error'}';
      case DownloadStatus.cancelled:
        return 'Download cancelled';
    }
  }

  String _getTimeRemaining(DownloadTask task) {
    if (!task.isDownloading || task.downloadedBytes == 0) {
      return 'Calculating...';
    }

    final remainingBytes = task.totalBytes - task.downloadedBytes;
    final speed = task.downloadedBytes / 
        DateTime.now().difference(task.startedAt!).inSeconds;
    
    if (speed <= 0) return 'Calculating...';
    
    final remainingSeconds = remainingBytes / speed;
    final remainingMinutes = (remainingSeconds / 60).round();
    
    if (remainingMinutes < 1) return '< 1 min';
    if (remainingMinutes < 60) return '$remainingMinutes min';
    
    final hours = (remainingMinutes / 60).round();
    return '$hours h';
  }

  // Action methods
  void _startDownload(BuildContext context, WidgetRef ref) {
    ref.read(downloadManagerProvider.notifier).downloadAsset(asset);
  }

  void _pauseDownload(BuildContext context, WidgetRef ref) {
    ref.read(downloadManagerProvider.notifier).pauseDownload(asset.id);
  }

  void _resumeDownload(BuildContext context, WidgetRef ref) {
    ref.read(downloadManagerProvider.notifier).resumeDownload(asset.id);
  }

  void _retryDownload(BuildContext context, WidgetRef ref) {
    ref.read(downloadManagerProvider.notifier).retryDownload(asset.id);
  }

  void _cancelDownload(BuildContext context, WidgetRef ref) {
    ref.read(downloadManagerProvider.notifier).cancelDownload(asset.id);
  }

  void _openFile(BuildContext context) {
    // TODO: Implement file opening functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File opened')),
    );
  }
}

// Download list widget
class DownloadListWidget extends ConsumerWidget {
  const DownloadListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloads = ref.watch(downloadManagerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Downloads',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'clear_completed':
                      ref.read(downloadManagerProvider.notifier).clearCompletedDownloads();
                      break;
                    case 'clear_all':
                      ref.read(downloadManagerProvider.notifier).clearAllDownloads();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'clear_completed',
                    child: ListTile(
                      leading: Icon(Icons.clear_all),
                      title: Text('Clear Completed'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: ListTile(
                      leading: Icon(Icons.delete_forever),
                      title: Text('Clear All'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Downloads list
        Expanded(
          child: downloads.isEmpty
              ? const Center(
                  child: Text('No downloads'),
                )
              : ListView.builder(
                  itemCount: downloads.length,
                  itemBuilder: (context, index) {
                    final task = downloads.values.elementAt(index);
                    return DownloadProgressWidget(
                      asset: task.asset,
                      showDetails: true,
                    );
                  },
                ),
        ),
      ],
    );
  }
}


