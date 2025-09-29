import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/asset.dart';
import 'content_service.dart';

enum MediaType {
  video,
  audio,
}

enum PlaybackState {
  stopped,
  playing,
  paused,
  buffering,
  error,
}

class MediaPlayerService {
  static const String _playbackPositionKey = 'playback_position_';
  static const String _playbackSpeedKey = 'playback_speed';
  
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;
  ChewieController? _chewieController;
  Asset? _currentAsset;
  MediaType? _currentMediaType;
  PlaybackState _playbackState = PlaybackState.stopped;
  
  final StreamController<PlaybackState> _playbackStateController = StreamController.broadcast();
  final StreamController<Duration> _positionController = StreamController.broadcast();
  final StreamController<Duration> _durationController = StreamController.broadcast();
  final StreamController<double> _volumeController = StreamController.broadcast();
  final StreamController<double> _speedController = StreamController.broadcast();
  
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  // Getters
  PlaybackState get playbackState => _playbackState;
  Asset? get currentAsset => _currentAsset;
  MediaType? get currentMediaType => _currentMediaType;
  Duration get currentPosition => _videoController?.value.position ?? Duration.zero;
  Duration get duration => _videoController?.value.duration ?? Duration.zero;
  double get volume => _videoController?.value.volume ?? _audioPlayer?.volume ?? 1.0;
  double get playbackSpeed => _videoController?.value.playbackSpeed ?? _audioPlayer?.playbackRate ?? 1.0;
  bool get isPlaying => _playbackState == PlaybackState.playing;
  bool get isPaused => _playbackState == PlaybackState.paused;
  bool get isBuffering => _playbackState == PlaybackState.buffering;

  // Streams
  Stream<PlaybackState> get playbackStateStream => _playbackStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<double> get volumeStream => _volumeController.stream;
  Stream<double> get speedStream => _speedController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  Future<void> playAsset(Asset asset, {bool autoPlay = true}) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Stop current playback
      await stop();
      
      _currentAsset = asset;
      _setPlaybackState(PlaybackState.buffering);
      
      // Determine media type
      if (asset.type == AssetType.video) {
        _currentMediaType = MediaType.video;
        await _playVideo(asset, autoPlay: autoPlay);
      } else if (asset.type == AssetType.audio) {
        _currentMediaType = MediaType.audio;
        await _playAudio(asset, autoPlay: autoPlay);
      } else {
        throw UnsupportedError('Unsupported asset type: ${asset.type}');
      }
    } catch (e) {
      _setPlaybackState(PlaybackState.error);
      rethrow;
    }
  }

  Future<void> _playVideo(Asset asset, {bool autoPlay = true}) async {
    try {
      // Create video controller
      _videoController = VideoPlayerController.file(
        File(asset.localPath ?? asset.url),
      );
      
      await _videoController!.initialize();
      
      // Set up position tracking
      _videoController!.addListener(_onVideoPositionChanged);
      
      // Create Chewie controller for better UI
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: autoPlay,
        autoInitialize: true,
        showOptions: true,
        showControls: true,
        showControlsOnInitialize: true,
        allowFullScreen: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        playbackSpeeds: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0],
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF1976D2),
          handleColor: const Color(0xFF1976D2),
          backgroundColor: Colors.grey.shade300,
          bufferedColor: Colors.grey.shade400,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading video',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
      
      // Restore playback position
      await _restorePlaybackPosition();
      
      // Set up state change listener
      _chewieController!.addListener(_onChewieStateChanged);
      
      if (autoPlay) {
        await play();
      }
      
      _setPlaybackState(PlaybackState.playing);
    } catch (e) {
      _setPlaybackState(PlaybackState.error);
      rethrow;
    }
  }

  Future<void> _playAudio(Asset asset, {bool autoPlay = true}) async {
    try {
      _audioPlayer = AudioPlayer();
      
      // Set up event listeners
      _audioPlayer!.onPlayerStateChanged.listen(_onAudioStateChanged);
      _audioPlayer!.onPositionChanged.listen(_onAudioPositionChanged);
      _audioPlayer!.onDurationChanged.listen(_onAudioDurationChanged);
      
      // Play audio file
      if (asset.localPath != null) {
        await _audioPlayer!.play(DeviceFileSource(asset.localPath!));
      } else {
        await _audioPlayer!.play(UrlSource(asset.url));
      }
      
      // Restore playback position
      await _restorePlaybackPosition();
      
      if (autoPlay) {
        await play();
      }
      
      _setPlaybackState(PlaybackState.playing);
    } catch (e) {
      _setPlaybackState(PlaybackState.error);
      rethrow;
    }
  }

  Future<void> play() async {
    if (_currentMediaType == MediaType.video && _chewieController != null) {
      await _chewieController!.play();
    } else if (_currentMediaType == MediaType.audio && _audioPlayer != null) {
      await _audioPlayer!.resume();
    }
    
    // Keep screen awake during playback
    await WakelockPlus.enable();
    _setPlaybackState(PlaybackState.playing);
  }

  Future<void> pause() async {
    if (_currentMediaType == MediaType.video && _chewieController != null) {
      await _chewieController!.pause();
    } else if (_currentMediaType == MediaType.audio && _audioPlayer != null) {
      await _audioPlayer!.pause();
    }
    
    _setPlaybackState(PlaybackState.paused);
  }

  Future<void> stop() async {
    // Save current position before stopping
    await _savePlaybackPosition();
    
    if (_videoController != null) {
      _videoController!.removeListener(_onVideoPositionChanged);
      await _videoController!.dispose();
      _videoController = null;
    }
    
    if (_chewieController != null) {
      _chewieController!.removeListener(_onChewieStateChanged);
      _chewieController!.dispose();
      _chewieController = null;
    }
    
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
      await _audioPlayer!.dispose();
      _audioPlayer = null;
    }
    
    // Release wake lock
    await WakelockPlus.disable();
    
    _currentAsset = null;
    _currentMediaType = null;
    _setPlaybackState(PlaybackState.stopped);
  }

  Future<void> seekTo(Duration position) async {
    if (_currentMediaType == MediaType.video && _videoController != null) {
      await _videoController!.seekTo(position);
    } else if (_currentMediaType == MediaType.audio && _audioPlayer != null) {
      await _audioPlayer!.seek(position);
    }
  }

  Future<void> setVolume(double volume) async {
    volume = volume.clamp(0.0, 1.0);
    
    if (_currentMediaType == MediaType.video && _videoController != null) {
      await _videoController!.setVolume(volume);
    } else if (_currentMediaType == MediaType.audio && _audioPlayer != null) {
      await _audioPlayer!.setVolume(volume);
    }
    
    _volumeController.add(volume);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    if (_currentMediaType == MediaType.video && _videoController != null) {
      await _videoController!.setPlaybackSpeed(speed);
    } else if (_currentMediaType == MediaType.audio && _audioPlayer != null) {
      await _audioPlayer!.setPlaybackRate(speed);
    }
    
    // Save speed preference
    await _prefs?.setDouble(_playbackSpeedKey, speed);
    _speedController.add(speed);
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else if (isPaused) {
      await play();
    }
  }

  // Event handlers
  void _onVideoPositionChanged() {
    if (_videoController != null) {
      _positionController.add(_videoController!.value.position);
    }
  }

  void _onChewieStateChanged() {
    if (_chewieController != null && _videoController != null) {
      final isPlaying = _chewieController!.isPlaying;
      final isBuffering = _videoController!.value.isBuffering;
      
      if (isBuffering) {
        _setPlaybackState(PlaybackState.buffering);
      } else if (isPlaying) {
        _setPlaybackState(PlaybackState.playing);
      } else {
        _setPlaybackState(PlaybackState.paused);
      }
    }
  }

  void _onAudioStateChanged(PlayerState state) {
    switch (state) {
      case PlayerState.playing:
        _setPlaybackState(PlaybackState.playing);
        break;
      case PlayerState.paused:
        _setPlaybackState(PlaybackState.paused);
        break;
      case PlayerState.stopped:
        _setPlaybackState(PlaybackState.stopped);
        break;
      case PlayerState.completed:
        _setPlaybackState(PlaybackState.stopped);
        break;
      case PlayerState.disposed:
        _setPlaybackState(PlaybackState.stopped);
        break;
    }
  }

  void _onAudioPositionChanged(Duration position) {
    _positionController.add(position);
  }

  void _onAudioDurationChanged(Duration duration) {
    _durationController.add(duration);
  }

  void _setPlaybackState(PlaybackState state) {
    _playbackState = state;
    _playbackStateController.add(state);
  }

  // Resume playback functionality
  Future<void> _restorePlaybackPosition() async {
    if (_currentAsset == null || _prefs == null) return;
    
    final positionKey = '$_playbackPositionKey${_currentAsset!.id}';
    final savedPosition = _prefs!.getInt(positionKey);
    
    if (savedPosition != null && savedPosition > 0) {
      final position = Duration(milliseconds: savedPosition);
      await Future.delayed(const Duration(milliseconds: 500)); // Wait for initialization
      await seekTo(position);
    }
    
    // Restore playback speed
    final savedSpeed = _prefs!.getDouble(_playbackSpeedKey) ?? 1.0;
    await setPlaybackSpeed(savedSpeed);
  }

  Future<void> _savePlaybackPosition() async {
    if (_currentAsset == null || _prefs == null) return;
    
    final positionKey = '$_playbackPositionKey${_currentAsset!.id}';
    final position = currentPosition;
    
    // Only save if position is significant (more than 5 seconds)
    if (position.inSeconds > 5) {
      await _prefs!.setInt(positionKey, position.inMilliseconds);
    }
  }

  // Cleanup
  void dispose() {
    stop();
    _playbackStateController.close();
    _positionController.close();
    _durationController.close();
    _volumeController.close();
    _speedController.close();
  }

  // Widget getters for UI
  Widget? get videoPlayerWidget {
    if (_chewieController != null) {
      return Chewie(controller: _chewieController!);
    }
    return null;
  }

  Widget? get audioPlayerWidget {
    if (_audioPlayer != null) {
      return const SizedBox.shrink(); // Audio player is controlled programmatically
    }
    return null;
  }
}
