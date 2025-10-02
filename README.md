# Daksh

A Flutter app for learning with clean architecture, built with accessibility in mind.

## Features

- **Clean Architecture**: Organized into data, domain, and presentation layers
- **State Management**: Uses Riverpod for reactive state management
- **Navigation**: Implemented with go_router for type-safe navigation
- **Accessibility**: High contrast colors, large tap targets, and semantic labels
- **Material Design 3**: Modern UI following Material Design guidelines
- **Offline-First Content**: Caches lessons and assets for offline access
- **Multi-Language Support**: English, Hindi, and Telugu localization
- **Asset Management**: Downloads and manages lesson assets with integrity checks
- **Smart Caching**: Automatic manifest caching with user-controlled refresh
- **Media Player**: Video/audio player with adaptive bitrate and resume functionality
- **Download Manager**: Pre-download with progress tracking, pause/resume, and storage checks

## Architecture

The app follows clean architecture principles with the following structure:

```
lib/
├── core/                 # Core functionality
│   ├── constants/       # App constants and routes
│   ├── navigation/      # Navigation configuration
│   ├── theme/          # App theme and colors
│   ├── utils/          # Utility functions
│   └── widgets/        # Reusable widgets
├── data/               # Data layer
│   ├── datasources/    # Data sources (API, local storage)
│   ├── models/         # Data models
│   └── repositories/   # Repository implementations
├── domain/             # Domain layer
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Business logic
└── presentation/       # Presentation layer
    ├── pages/          # Screen widgets
    ├── providers/      # Riverpod providers
    └── widgets/        # UI components
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- **flutter_riverpod**: State management
- **go_router**: Navigation
- **equatable**: Value equality
- **json_annotation**: JSON serialization
- **dio**: HTTP client for network requests
- **connectivity_plus**: Network connectivity detection
- **path_provider**: File system access
- **crypto**: File integrity verification
- **shared_preferences**: Local data persistence
- **intl**: Internationalization support
- **video_player**: Video playback functionality
- **audioplayers**: Audio playback functionality
- **chewie**: Enhanced video player UI
- **wakelock_plus**: Keep screen awake during playback
- **permission_handler**: Handle device permissions

## Accessibility Features

- High contrast color scheme (WCAG AA compliant)
- Minimum 44x44 logical pixel tap targets
- Semantic labels for screen readers
- Large, readable fonts
- Clear visual hierarchy

## Content Management

The app implements an offline-first content management system:

### ContentService Features

- **Offline-First**: Always tries to serve content from local cache
- **Smart Caching**: Automatically caches content manifests and assets
- **Integrity Verification**: Uses SHA-256 checksums to verify downloaded assets
- **Network Awareness**: Only syncs when internet is available and user initiates
- **Asset Management**: Downloads and manages various asset types (video, audio, documents, interactive content)
- **Storage Management**: Provides cache size information and cleanup functionality

### Usage Example

```dart
// Get lessons (offline-first)
final lessons = await contentService.getLessons();

// Get lessons by category
final grammarLessons = await contentService.getLessons(category: 'Parts of Speech');

// Download lesson assets
await contentService.downloadLessonAssets('lesson_001');

// Force refresh content
await contentService.getManifest(forceRefresh: true);
```

### Asset Types Supported

- **Video**: MP4 files for lesson content
- **Audio**: MP3 files for pronunciation and exercises
- **Documents**: PDF files for reading materials
- **Interactive**: JSON files for interactive exercises
- **Images**: JPG/PNG files for thumbnails and illustrations

## Media Player

The app includes a comprehensive media player system with the following features:

### MediaPlayerService Features

- **Adaptive Bitrate**: Automatically adjusts quality based on network conditions
- **Resume Playback**: Remembers playback position and resumes from where user left off
- **Multiple Formats**: Supports video (MP4) and audio (MP3, WAV) formats
- **Playback Controls**: Play, pause, seek, volume control, and speed adjustment
- **Background Playback**: Continues playing when app is backgrounded
- **Wake Lock**: Keeps screen awake during video playback

### Download Manager Features

- **Pre-Download**: Download assets before they're needed
- **Progress Tracking**: Real-time download progress with speed and time remaining
- **Pause/Resume**: Pause and resume downloads at any time
- **Storage Management**: Check available storage and manage downloaded content
- **Integrity Verification**: SHA-256 checksums ensure downloaded files are not corrupted
- **Concurrent Downloads**: Download multiple assets simultaneously
- **Retry Logic**: Automatic retry for failed downloads

### Usage Example

```dart
// Play a video asset
final videoAsset = Asset(
  id: 'video_001',
  lessonId: 'lesson_001',
  name: 'Sample Video',
  type: AssetType.video,
  url: 'https://example.com/video.mp4',
  sizeBytes: 1048576,
  mimeType: 'video/mp4',
);

// Play with auto-play
await mediaPlayerService.playAsset(videoAsset, autoPlay: true);

// Control playback
await mediaPlayerService.pause();
await mediaPlayerService.seekTo(Duration(minutes: 5));
await mediaPlayerService.setPlaybackSpeed(1.5);

// Download asset
await downloadManager.downloadAsset(videoAsset);

// Listen to download progress
downloadManager.downloadStream.listen((task) {
  print('Progress: ${task.progress}');
});
```

### Player Controls

- **Large Tap Targets**: All controls meet accessibility guidelines (44x44 logical pixels)
- **Visual Feedback**: Clear visual indicators for all player states
- **Gesture Support**: Swipe gestures for seeking and volume control
- **Keyboard Shortcuts**: Full keyboard support for desktop platforms
- **Screen Reader Support**: Complete semantic labels for accessibility

## Development

### Code Generation

Run code generation for Riverpod providers and JSON serialization:

```bash
flutter packages pub run build_runner build
```

### Linting

The project uses `flutter_lints` with additional custom rules for better code quality.

## License

This project is licensed under the MIT License.
