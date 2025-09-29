import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/asset.dart';
import '../providers/media_player_provider.dart';

class MediaPlayerWidget extends ConsumerStatefulWidget {
  final Asset asset;
  final bool showControls;
  final bool autoPlay;

  const MediaPlayerWidget({
    super.key,
    required this.asset,
    this.showControls = true,
    this.autoPlay = false,
  });

  @override
  ConsumerState<MediaPlayerWidget> createState() => _MediaPlayerWidgetState();
}

class _MediaPlayerWidgetState extends ConsumerState<MediaPlayerWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mediaPlayerProvider.notifier).playAsset(widget.asset, autoPlay: widget.autoPlay);
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(mediaPlayerProvider);
    final isVideo = widget.asset.type == AssetType.video;
    final isAudio = widget.asset.type == AssetType.audio;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Column(
        children: [
          if (isVideo) _buildVideoPlayer(playerState),
          if (isAudio) _buildAudioPlayer(playerState),
          if (widget.showControls) _buildControls(playerState),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(MediaPlayerState playerState) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: playerState.videoPlayerWidget ?? _buildLoadingWidget(),
      ),
    );
  }

  Widget _buildAudioPlayer(MediaPlayerState playerState) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Audio thumbnail/icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
            ),
            child: Icon(
              Icons.audiotrack,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Audio title
          Text(
            widget.asset.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppTheme.spacingS),
          // Audio description
          Text(
            widget.asset.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildControls(MediaPlayerState playerState) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          // Progress bar
          _buildProgressBar(playerState),
          const SizedBox(height: AppTheme.spacingM),
          // Control buttons
          _buildControlButtons(playerState),
          const SizedBox(height: AppTheme.spacingM),
          // Additional controls
          _buildAdditionalControls(playerState),
        ],
      ),
    );
  }

  Widget _buildProgressBar(MediaPlayerState playerState) {
    final position = playerState.currentPosition;
    final duration = playerState.duration;
    final progress = duration.inMilliseconds > 0 
        ? position.inMilliseconds / duration.inMilliseconds 
        : 0.0;

    return Column(
      children: [
        // Time labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(position),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
            Text(
              _formatDuration(duration),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingS),
        // Progress slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Colors.white24,
            thumbColor: Theme.of(context).colorScheme.primary,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 4,
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              final newPosition = Duration(
                milliseconds: (value * duration.inMilliseconds).round(),
              );
              ref.read(mediaPlayerProvider.notifier).seekTo(newPosition);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons(MediaPlayerState playerState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Rewind button
        _buildControlButton(
          icon: Icons.replay_10,
          onPressed: () => _rewind10(),
          tooltip: 'Rewind 10 seconds',
        ),
        // Previous button
        _buildControlButton(
          icon: Icons.skip_previous,
          onPressed: () => _previousTrack(),
          tooltip: 'Previous track',
        ),
        // Play/Pause button
        _buildControlButton(
          icon: playerState.isPlaying ? Icons.pause : Icons.play_arrow,
          onPressed: () => ref.read(mediaPlayerProvider.notifier).togglePlayPause(),
          tooltip: playerState.isPlaying ? 'Pause' : 'Play',
          isPrimary: true,
        ),
        // Next button
        _buildControlButton(
          icon: Icons.skip_next,
          onPressed: () => _nextTrack(),
          tooltip: 'Next track',
        ),
        // Forward button
        _buildControlButton(
          icon: Icons.forward_10,
          onPressed: () => _forward10(),
          tooltip: 'Forward 10 seconds',
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    bool isPrimary = false,
  }) {
    return Container(
      width: isPrimary ? AppTheme.minTapTargetSize + 8 : AppTheme.minTapTargetSize,
      height: isPrimary ? AppTheme.minTapTargetSize + 8 : AppTheme.minTapTargetSize,
      child: IconButton(
        icon: Icon(
          icon,
          size: isPrimary ? 32 : 24,
          color: Colors.white,
        ),
        onPressed: onPressed,
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: isPrimary 
              ? Theme.of(context).colorScheme.primary
              : Colors.white24,
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  Widget _buildAdditionalControls(MediaPlayerState playerState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Volume control
        _buildVolumeControl(playerState),
        // Speed control
        _buildSpeedControl(playerState),
        // Download status
        _buildDownloadStatus(),
      ],
    );
  }

  Widget _buildVolumeControl(MediaPlayerState playerState) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.volume_up,
          color: Colors.white70,
          size: 20,
        ),
        const SizedBox(width: AppTheme.spacingS),
        SizedBox(
          width: 100,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Colors.white24,
              thumbColor: Theme.of(context).colorScheme.primary,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              trackHeight: 3,
            ),
            child: Slider(
              value: playerState.volume,
              onChanged: (value) {
                ref.read(mediaPlayerProvider.notifier).setVolume(value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedControl(MediaPlayerState playerState) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.speed,
          color: Colors.white70,
          size: 20,
        ),
        const SizedBox(width: AppTheme.spacingS),
        DropdownButton<double>(
          value: playerState.playbackSpeed,
          dropdownColor: Colors.grey.shade800,
          style: const TextStyle(color: Colors.white),
          items: const [
            DropdownMenuItem(value: 0.5, child: Text('0.5x')),
            DropdownMenuItem(value: 0.75, child: Text('0.75x')),
            DropdownMenuItem(value: 1.0, child: Text('1.0x')),
            DropdownMenuItem(value: 1.25, child: Text('1.25x')),
            DropdownMenuItem(value: 1.5, child: Text('1.5x')),
            DropdownMenuItem(value: 2.0, child: Text('2.0x')),
          ],
          onChanged: (value) {
            if (value != null) {
              ref.read(mediaPlayerProvider.notifier).setPlaybackSpeed(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDownloadStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: widget.asset.isDownloaded ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.asset.isDownloaded ? Icons.download_done : Icons.download,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: AppTheme.spacingXS),
          Text(
            widget.asset.isDownloaded ? 'Downloaded' : 'Streaming',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  // Helper methods
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  void _rewind10() {
    final currentPosition = ref.read(mediaPlayerProvider).currentPosition;
    final newPosition = currentPosition - const Duration(seconds: 10);
    ref.read(mediaPlayerProvider.notifier).seekTo(newPosition);
  }

  void _forward10() {
    final currentPosition = ref.read(mediaPlayerProvider).currentPosition;
    final newPosition = currentPosition + const Duration(seconds: 10);
    ref.read(mediaPlayerProvider.notifier).seekTo(newPosition);
  }

  void _previousTrack() {
    // TODO: Implement previous track functionality
  }

  void _nextTrack() {
    // TODO: Implement next track functionality
  }
}


