import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/asset.dart';
import '../widgets/media_player_widget.dart';
import '../widgets/download_progress_widget.dart';
import '../providers/content_provider.dart';
import '../providers/download_provider.dart';
import '../../data/services/download_manager.dart';
import 'media_player_page.dart';

class LessonDetailPage extends ConsumerWidget {
  final String lessonId;

  const LessonDetailPage({
    super.key,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsync = ref.watch(lessonProvider(lessonId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_for_offline),
            onPressed: () => _downloadAllAssets(context, ref),
            tooltip: 'Download all assets',
          ),
        ],
      ),
      body: lessonAsync.when(
        data: (lesson) {
          if (lesson == null) {
            return const Center(
              child: Text('Lesson not found'),
            );
          }
          return _buildLessonContent(context, ref, lesson);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: AppTheme.spacingM),
              Text('Error loading lesson: $error'),
              const SizedBox(height: AppTheme.spacingM),
              ElevatedButton(
                onPressed: () => ref.invalidate(lessonProvider(lessonId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonContent(BuildContext context, WidgetRef ref, Lesson lesson) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lesson header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    lesson.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Row(
                    children: [
                      _buildInfoChip(context, Icons.schedule, lesson.formattedDuration),
                      const SizedBox(width: AppTheme.spacingS),
                      _buildInfoChip(context, Icons.school, lesson.difficulty),
                      const SizedBox(width: AppTheme.spacingS),
                      _buildInfoChip(context, Icons.category, lesson.category),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingL),

          // Lesson assets
          Text(
            'Lesson Assets',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingM),

          if (lesson.assetIds.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.spacingL),
                child: Center(
                  child: Text('No assets available for this lesson'),
                ),
              ),
            )
          else
            _buildAssetsList(context, ref, lesson),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  Widget _buildAssetsList(BuildContext context, WidgetRef ref, Lesson lesson) {
    return Column(
      children: lesson.assetIds.map((assetId) {
        return FutureBuilder<Asset?>(
          future: _getAsset(ref, assetId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Card(
                child: ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text('Loading asset...'),
                ),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.error, color: Colors.red),
                  title: const Text('Error loading asset'),
                  subtitle: Text(snapshot.error?.toString() ?? 'Unknown error'),
                ),
              );
            }

            final asset = snapshot.data!;
            return Card(
              margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getAssetColor(asset.type).withOpacity(0.1),
                  child: Icon(
                    _getAssetIcon(asset.type),
                    color: _getAssetColor(asset.type),
                  ),
                ),
                title: Text(asset.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset.name),
                    const SizedBox(height: AppTheme.spacingXS),
                    Row(
                      children: [
                        Text(
                          _formatFileSize(asset.sizeBytes),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(asset.downloadStatus).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusS),
                          ),
                          child: Text(
                            _getStatusText(asset.downloadStatus),
                            style: TextStyle(
                              color: _getStatusColor(asset.downloadStatus),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (asset.type == AssetType.video || asset.type == AssetType.audio)
                      IconButton(
                        icon: const Icon(Icons.play_circle),
                        onPressed: () => _playAsset(context, asset),
                        tooltip: 'Play',
                      ),
                    IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () => _showAssetInfo(context, asset),
                      tooltip: 'Info',
                    ),
                  ],
                ),
                onTap: () => _playAsset(context, asset),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Future<Asset?> _getAsset(WidgetRef ref, String assetId) async {
    try {
      final contentService = await ref.read(contentServiceProvider.future);
      return await contentService.getAsset(assetId);
    } catch (e) {
      return null;
    }
  }

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

  Color _getAssetColor(AssetType type) {
    switch (type) {
      case AssetType.video:
        return Colors.red;
      case AssetType.audio:
        return Colors.blue;
      case AssetType.document:
        return Colors.orange;
      case AssetType.image:
        return Colors.green;
      case AssetType.animation:
        return Colors.purple;
      case AssetType.interactive:
        return Colors.teal;
    }
  }

  Color _getStatusColor(AssetDownloadStatus status) {
    switch (status) {
      case AssetDownloadStatus.notDownloaded:
        return Colors.grey;
      case AssetDownloadStatus.downloading:
        return Colors.blue;
      case AssetDownloadStatus.downloaded:
        return Colors.green;
      case AssetDownloadStatus.failed:
        return Colors.red;
      case AssetDownloadStatus.corrupted:
        return Colors.red;
      case AssetDownloadStatus.paused:
        return Colors.orange;
    }
  }

  String _getStatusText(AssetDownloadStatus status) {
    switch (status) {
      case AssetDownloadStatus.notDownloaded:
        return 'Not Downloaded';
      case AssetDownloadStatus.downloading:
        return 'Downloading';
      case AssetDownloadStatus.downloaded:
        return 'Downloaded';
      case AssetDownloadStatus.failed:
        return 'Failed';
      case AssetDownloadStatus.corrupted:
        return 'Corrupted';
      case AssetDownloadStatus.paused:
        return 'Paused';
    }
  }

  void _playAsset(BuildContext context, Asset asset) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPlayerPage(asset: asset),
      ),
    );
  }

  void _showAssetInfo(BuildContext context, Asset asset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(asset.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name', asset.name),
            _buildInfoRow('Type', _getAssetTypeName(asset.type)),
            _buildInfoRow('Size', _formatFileSize(asset.sizeBytes)),
            _buildInfoRow('Format', asset.mimeType),
            _buildInfoRow('Status', _getStatusText(asset.downloadStatus)),
            if (asset.localPath != null)
              _buildInfoRow('Downloaded', 'Yes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (asset.type == AssetType.video || asset.type == AssetType.audio)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _playAsset(context, asset);
              },
              child: const Text('Play'),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getAssetTypeName(AssetType type) {
    switch (type) {
      case AssetType.video:
        return 'Video';
      case AssetType.audio:
        return 'Audio';
      case AssetType.document:
        return 'Document';
      case AssetType.image:
        return 'Image';
      case AssetType.animation:
        return 'Animation';
      case AssetType.interactive:
        return 'Interactive';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  void _downloadAllAssets(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download All Assets'),
        content: const Text(
          'This will download all assets for this lesson. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement download all assets functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Downloading all assets...'),
                ),
              );
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }
}

