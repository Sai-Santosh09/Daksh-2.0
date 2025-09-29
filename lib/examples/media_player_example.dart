import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/pages/media_player_page.dart';
import '../presentation/widgets/media_player_widget.dart';
import '../presentation/widgets/download_progress_widget.dart';
import '../domain/entities/asset.dart';
import '../data/sample_manifest.dart';

/// Example demonstrating the media player functionality
class MediaPlayerExample extends ConsumerWidget {
  const MediaPlayerExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Player Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Video player example
          _buildSection(
            context,
            'Video Player',
            'Play video content with full controls',
            () => _showVideoPlayer(context),
          ),
          
          // Audio player example
          _buildSection(
            context,
            'Audio Player',
            'Play audio content with controls',
            () => _showAudioPlayer(context),
          ),
          
          // Download progress example
          _buildSection(
            context,
            'Download Progress',
            'Track download progress with pause/resume',
            () => _showDownloadProgress(context),
          ),
          
          // Media player widget example
          _buildSection(
            context,
            'Embedded Player',
            'Media player widget embedded in page',
            () => _showEmbeddedPlayer(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.play_circle),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _showVideoPlayer(BuildContext context) {
    // Create a sample video asset
    final videoAsset = Asset(
      id: 'sample_video_001',
      lessonId: 'lesson_001',
      name: 'Introduction to Grammar',
      description: 'Learn the basics of English grammar',
      type: AssetType.video,
      url: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      localPath: null, // This would be set if downloaded
      sizeBytes: 1048576, // 1MB
      mimeType: 'video/mp4',
      checksum: 'sample_checksum_123',
      status: AssetStatus.notDownloaded,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPlayerPage(asset: videoAsset),
      ),
    );
  }

  void _showAudioPlayer(BuildContext context) {
    // Create a sample audio asset
    final audioAsset = Asset(
      id: 'sample_audio_001',
      lessonId: 'lesson_001',
      name: 'Pronunciation Guide',
      description: 'Audio guide for proper pronunciation',
      type: AssetType.audio,
      url: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
      localPath: null,
      sizeBytes: 512000, // 512KB
      mimeType: 'audio/wav',
      checksum: 'sample_audio_checksum_456',
      status: AssetStatus.notDownloaded,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPlayerPage(asset: audioAsset),
      ),
    );
  }

  void _showDownloadProgress(BuildContext context) {
    // Create a sample asset for download
    final downloadAsset = Asset(
      id: 'sample_download_001',
      lessonId: 'lesson_001',
      name: 'Grammar Exercise PDF',
      description: 'Downloadable PDF with grammar exercises',
      type: AssetType.document,
      url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      localPath: null,
      sizeBytes: 2048000, // 2MB
      mimeType: 'application/pdf',
      checksum: 'sample_pdf_checksum_789',
      status: AssetStatus.notDownloaded,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Progress'),
        content: SizedBox(
          width: double.maxFinite,
          child: DownloadProgressWidget(
            asset: downloadAsset,
            showDetails: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEmbeddedPlayer(BuildContext context) {
    // Create a sample asset for embedded player
    final embeddedAsset = Asset(
      id: 'sample_embedded_001',
      lessonId: 'lesson_001',
      name: 'Interactive Lesson',
      description: 'Embedded video lesson',
      type: AssetType.video,
      url: 'https://sample-videos.com/zip/10/mp4/SampleVideo_640x360_1mb.mp4',
      localPath: null,
      sizeBytes: 1048576, // 1MB
      mimeType: 'video/mp4',
      checksum: 'sample_embedded_checksum_101',
      status: AssetStatus.notDownloaded,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Embedded Media Player'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: MediaPlayerWidget(
            asset: embeddedAsset,
            showControls: true,
            autoPlay: false,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Example of how to use the media player programmatically
class MediaPlayerUsageExample {
  static void demonstrateUsage() {
    /*
    // 1. Initialize the media player service
    final mediaPlayerService = MediaPlayerService();
    await mediaPlayerService.initialize();

    // 2. Play a video asset
    final videoAsset = Asset(
      id: 'video_001',
      lessonId: 'lesson_001',
      name: 'Sample Video',
      description: 'A sample video for demonstration',
      type: AssetType.video,
      url: 'https://example.com/video.mp4',
      sizeBytes: 1048576,
      mimeType: 'video/mp4',
    );

    await mediaPlayerService.playAsset(videoAsset, autoPlay: true);

    // 3. Control playback
    await mediaPlayerService.pause();
    await mediaPlayerService.play();
    await mediaPlayerService.seekTo(Duration(minutes: 5));
    await mediaPlayerService.setVolume(0.8);
    await mediaPlayerService.setPlaybackSpeed(1.5);

    // 4. Listen to playback events
    mediaPlayerService.playbackStateStream.listen((state) {
      print('Playback state: $state');
    });

    mediaPlayerService.positionStream.listen((position) {
      print('Current position: $position');
    });

    // 5. Download management
    final downloadManager = DownloadManager(
      dio: Dio(),
      connectivity: Connectivity(),
    );

    // Download an asset
    await downloadManager.downloadAsset(videoAsset);

    // Listen to download progress
    downloadManager.downloadStream.listen((task) {
      print('Download progress: ${task.progress}');
    });

    // Pause/resume downloads
    await downloadManager.pauseDownload(videoAsset.id);
    await downloadManager.resumeDownload(videoAsset.id);

    // 6. Storage management
    final totalSize = await downloadManager.getTotalDownloadedSize();
    print('Total downloaded size: $totalSize bytes');

    // Clean up
    await mediaPlayerService.stop();
    downloadManager.dispose();
    */
  }
}

/// Example widget showing media player integration
class MediaPlayerIntegrationExample extends ConsumerWidget {
  const MediaPlayerIntegrationExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Player Integration'),
      ),
      body: Column(
        children: [
          // Media player widget
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MediaPlayerWidget(
                  asset: _createSampleAsset(),
                  showControls: true,
                  autoPlay: false,
                ),
              ),
            ),
          ),
          
          // Download section
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: DownloadProgressWidget(
                asset: _createSampleAsset(),
                showDetails: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Asset _createSampleAsset() {
    return Asset(
      id: 'integration_sample_001',
      lessonId: 'lesson_001',
      name: 'Sample Media Content',
      description: 'This is a sample media asset for integration testing',
      type: AssetType.video,
      url: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      localPath: null,
      sizeBytes: 1048576,
      mimeType: 'video/mp4',
      checksum: 'integration_sample_checksum',
      status: AssetStatus.notDownloaded,
    );
  }
}


