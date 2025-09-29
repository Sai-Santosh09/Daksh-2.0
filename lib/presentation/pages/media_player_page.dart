import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/asset.dart';
import '../widgets/media_player_widget.dart';
import '../widgets/download_progress_widget.dart';
import '../providers/media_player_provider.dart';
import '../providers/download_provider.dart';

class MediaPlayerPage extends ConsumerStatefulWidget {
  final Asset asset;

  const MediaPlayerPage({
    super.key,
    required this.asset,
  });

  @override
  ConsumerState<MediaPlayerPage> createState() => _MediaPlayerPageState();
}

class _MediaPlayerPageState extends ConsumerState<MediaPlayerPage> {
  @override
  void initState() {
    super.initState();
    // Auto-play the asset when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mediaPlayerProvider.notifier).playAsset(widget.asset, autoPlay: true);
    });
  }

  @override
  void dispose() {
    // Stop playback when leaving the page
    ref.read(mediaPlayerProvider.notifier).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(mediaPlayerProvider);
    final isVideo = widget.asset.type == AssetType.video;
    final isAudio = widget.asset.type == AssetType.audio;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.asset.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _showDownloadOptions(context),
            tooltip: 'Download options',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareAsset(context),
            tooltip: 'Share',
          ),
        ],
      ),
      body: Column(
        children: [
          // Media player
          Expanded(
            flex: isVideo ? 3 : 2,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: MediaPlayerWidget(
                asset: widget.asset,
                showControls: true,
                autoPlay: true,
              ),
            ),
          ),
          
          // Asset information
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.asset.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  widget.asset.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppTheme.spacingM),
                _buildAssetInfo(context),
              ],
            ),
          ),
          
          // Download section
          if (!widget.asset.isDownloaded)
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: DownloadProgressWidget(
                asset: widget.asset,
                showDetails: true,
              ),
            ),
          
          // Error display
          if (playerState.error != null)
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: Text(
                      playerState.error!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(mediaPlayerProvider.notifier).clearError();
                    },
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssetInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          children: [
            _buildInfoRow(context, 'Type', _getAssetTypeName(widget.asset.type)),
            _buildInfoRow(context, 'Size', widget.asset.formattedSize),
            _buildInfoRow(context, 'Format', widget.asset.mimeType),
            if (widget.asset.checksum != null)
              _buildInfoRow(context, 'Checksum', widget.asset.checksum!.substring(0, 8) + '...'),
            _buildInfoRow(context, 'Status', _getAssetStatusText()),
            if (widget.asset.downloadedAt != null)
              _buildInfoRow(context, 'Downloaded', _formatDate(widget.asset.downloadedAt!)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
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

  String _getAssetStatusText() {
    if (widget.asset.isDownloaded) {
      return 'Downloaded';
    } else if (widget.asset.isDownloading) {
      return 'Downloading';
    } else if (widget.asset.hasFailed) {
      return 'Failed';
    } else {
      return 'Not Downloaded';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDownloadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Download Options',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            // Download this asset
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download This Asset'),
              subtitle: Text('Size: ${widget.asset.formattedSize}'),
              onTap: () {
                Navigator.pop(context);
                ref.read(downloadManagerProvider.notifier).downloadAsset(widget.asset);
              },
            ),
            
            // Download all lesson assets
            ListTile(
              leading: const Icon(Icons.download_for_offline),
              title: const Text('Download All Lesson Assets'),
              subtitle: const Text('Download all assets for this lesson'),
              onTap: () {
                Navigator.pop(context);
                _downloadAllLessonAssets(context);
              },
            ),
            
            // Storage info
            const Divider(),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Storage Information'),
              subtitle: const Text('View storage usage and manage downloads'),
              onTap: () {
                Navigator.pop(context);
                _showStorageInfo(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _downloadAllLessonAssets(BuildContext context) {
    // This would typically get the lesson ID from the asset
    // For now, we'll show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading all lesson assets...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showStorageInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Information'),
        content: Consumer(
          builder: (context, ref, child) {
            final storageState = ref.watch(storageProvider);
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (storageState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  _buildStorageInfoRow('Total Space', storageState.formattedTotalSpace),
                  _buildStorageInfoRow('Used Space', storageState.formattedUsedSpace),
                  _buildStorageInfoRow('Available Space', storageState.formattedAvailableSpace),
                  const SizedBox(height: AppTheme.spacingM),
                  LinearProgressIndicator(
                    value: storageState.usagePercentage,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Usage: ${(storageState.usagePercentage * 100).toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDownloadManager(context);
            },
            child: const Text('Manage Downloads'),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showDownloadManager(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DownloadManagerPage(),
      ),
    );
  }

  void _shareAsset(BuildContext context) {
    // TODO: Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality not implemented')),
    );
  }
}

// Download manager page
class DownloadManagerPage extends ConsumerWidget {
  const DownloadManagerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(downloadManagerProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: const DownloadListWidget(),
    );
  }
}


