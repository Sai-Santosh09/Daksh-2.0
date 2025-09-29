import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/media_player_service.dart';
import '../../domain/entities/asset.dart';

// Media player service provider
final mediaPlayerServiceProvider = Provider<MediaPlayerService>((ref) {
  final service = MediaPlayerService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Media player state provider
final mediaPlayerProvider = StateNotifierProvider<MediaPlayerNotifier, MediaPlayerState>((ref) {
  final service = ref.watch(mediaPlayerServiceProvider);
  return MediaPlayerNotifier(service);
});

// Media player state
class MediaPlayerState {
  final PlaybackState playbackState;
  final Asset? currentAsset;
  final MediaType? currentMediaType;
  final Duration currentPosition;
  final Duration duration;
  final double volume;
  final double playbackSpeed;
  final bool isPlaying;
  final bool isPaused;
  final bool isBuffering;
  final String? error;
  final Widget? videoPlayerWidget;

  const MediaPlayerState({
    this.playbackState = PlaybackState.stopped,
    this.currentAsset,
    this.currentMediaType,
    this.currentPosition = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 1.0,
    this.playbackSpeed = 1.0,
    this.isPlaying = false,
    this.isPaused = false,
    this.isBuffering = false,
    this.error,
    this.videoPlayerWidget,
  });

  MediaPlayerState copyWith({
    PlaybackState? playbackState,
    Asset? currentAsset,
    MediaType? currentMediaType,
    Duration? currentPosition,
    Duration? duration,
    double? volume,
    double? playbackSpeed,
    bool? isPlaying,
    bool? isPaused,
    bool? isBuffering,
    String? error,
    Widget? videoPlayerWidget,
  }) {
    return MediaPlayerState(
      playbackState: playbackState ?? this.playbackState,
      currentAsset: currentAsset ?? this.currentAsset,
      currentMediaType: currentMediaType ?? this.currentMediaType,
      currentPosition: currentPosition ?? this.currentPosition,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      isBuffering: isBuffering ?? this.isBuffering,
      error: error,
      videoPlayerWidget: videoPlayerWidget ?? this.videoPlayerWidget,
    );
  }
}

// Media player notifier
class MediaPlayerNotifier extends StateNotifier<MediaPlayerState> {
  final MediaPlayerService _service;
  late StreamSubscription<PlaybackState> _playbackStateSubscription;
  late StreamSubscription<Duration> _positionSubscription;
  late StreamSubscription<Duration> _durationSubscription;
  late StreamSubscription<double> _volumeSubscription;
  late StreamSubscription<double> _speedSubscription;

  MediaPlayerNotifier(this._service) : super(const MediaPlayerState()) {
    _initializeSubscriptions();
  }

  void _initializeSubscriptions() {
    _playbackStateSubscription = _service.playbackStateStream.listen((playbackState) {
      state = state.copyWith(
        playbackState: playbackState,
        isPlaying: playbackState == PlaybackState.playing,
        isPaused: playbackState == PlaybackState.paused,
        isBuffering: playbackState == PlaybackState.buffering,
        error: playbackState == PlaybackState.error ? 'Playback error occurred' : null,
      );
    });

    _positionSubscription = _service.positionStream.listen((position) {
      state = state.copyWith(currentPosition: position);
    });

    _durationSubscription = _service.durationStream.listen((duration) {
      state = state.copyWith(duration: duration);
    });

    _volumeSubscription = _service.volumeStream.listen((volume) {
      state = state.copyWith(volume: volume);
    });

    _speedSubscription = _service.speedStream.listen((speed) {
      state = state.copyWith(playbackSpeed: speed);
    });
  }

  Future<void> playAsset(Asset asset, {bool autoPlay = true}) async {
    try {
      state = state.copyWith(error: null);
      await _service.playAsset(asset, autoPlay: autoPlay);
      
      state = state.copyWith(
        currentAsset: asset,
        currentMediaType: _service.currentMediaType,
        videoPlayerWidget: _service.videoPlayerWidget,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> play() async {
    try {
      state = state.copyWith(error: null);
      await _service.play();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> pause() async {
    try {
      state = state.copyWith(error: null);
      await _service.pause();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> stop() async {
    try {
      state = state.copyWith(error: null);
      await _service.stop();
      state = const MediaPlayerState();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> togglePlayPause() async {
    try {
      state = state.copyWith(error: null);
      await _service.togglePlayPause();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      state = state.copyWith(error: null);
      await _service.seekTo(position);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      state = state.copyWith(error: null);
      await _service.setVolume(volume);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> setPlaybackSpeed(double speed) async {
    try {
      state = state.copyWith(error: null);
      await _service.setPlaybackSpeed(speed);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _playbackStateSubscription.cancel();
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _volumeSubscription.cancel();
    _speedSubscription.cancel();
    super.dispose();
  }
}


