import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/services/content_service.dart';
import '../../data/repositories/content_repository_impl.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/asset.dart';

// Providers for dependencies
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  return dio;
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

// ContentService provider
final contentServiceProvider = FutureProvider<ContentService>((ref) async {
  final dio = ref.watch(dioProvider);
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final connectivity = ref.watch(connectivityProvider);
  
  return ContentService(
    dio: dio,
    prefs: prefs,
    connectivity: connectivity,
  );
});

// ContentRepository provider
final contentRepositoryProvider = FutureProvider<ContentRepositoryImpl>((ref) async {
  final contentService = await ref.watch(contentServiceProvider.future);
  return ContentRepositoryImpl(contentService: contentService);
});

// Lessons provider
final lessonsProvider = FutureProvider<List<Lesson>>((ref) async {
  final repository = await ref.watch(contentRepositoryProvider.future);
  return await repository.getAllLessons();
});

// Lessons by category provider
final lessonsByCategoryProvider = FutureProvider.family<List<Lesson>, String>((ref, category) async {
  final repository = await ref.watch(contentRepositoryProvider.future);
  return await repository.getLessonsByCategory(category);
});

// Lessons by difficulty provider
final lessonsByDifficultyProvider = FutureProvider.family<List<Lesson>, String>((ref, difficulty) async {
  final repository = await ref.watch(contentRepositoryProvider.future);
  return await repository.getLessonsByDifficulty(difficulty);
});

// Single lesson provider
final lessonProvider = FutureProvider.family<Lesson?, String>((ref, lessonId) async {
  final repository = await ref.watch(contentRepositoryProvider.future);
  return await repository.getLessonById(lessonId);
});

// Downloaded assets provider
final downloadedAssetsProvider = FutureProvider<List<Asset>>((ref) async {
  final repository = await ref.watch(contentRepositoryProvider.future);
  return await repository.getDownloadedAssets();
});

// Cache size provider
final cacheSizeProvider = FutureProvider<int>((ref) async {
  final repository = await ref.watch(contentRepositoryProvider.future);
  return await repository.getCacheSize();
});

// Content refresh provider
final contentRefreshProvider = StateNotifierProvider<ContentRefreshNotifier, ContentRefreshState>((ref) {
  return ContentRefreshNotifier(ref);
});

// Content refresh state
class ContentRefreshState {
  final bool isRefreshing;
  final String? error;
  final DateTime? lastRefresh;

  const ContentRefreshState({
    this.isRefreshing = false,
    this.error,
    this.lastRefresh,
  });

  ContentRefreshState copyWith({
    bool? isRefreshing,
    String? error,
    DateTime? lastRefresh,
  }) {
    return ContentRefreshState(
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error,
      lastRefresh: lastRefresh ?? this.lastRefresh,
    );
  }
}

// Content refresh notifier
class ContentRefreshNotifier extends StateNotifier<ContentRefreshState> {
  final Ref ref;

  ContentRefreshNotifier(this.ref) : super(const ContentRefreshState());

  Future<void> refreshContent({bool forceRefresh = false}) async {
    state = state.copyWith(isRefreshing: true, error: null);

    try {
      final repository = await ref.read(contentRepositoryProvider.future);
      await repository.refreshContent(forceRefresh: forceRefresh);
      
      // Invalidate related providers to trigger refresh
      ref.invalidate(lessonsProvider);
      ref.invalidate(downloadedAssetsProvider);
      ref.invalidate(cacheSizeProvider);
      
      state = state.copyWith(
        isRefreshing: false,
        lastRefresh: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Asset download provider
final assetDownloadProvider = StateNotifierProvider.family<AssetDownloadNotifier, AssetDownloadState, String>((ref, assetId) {
  return AssetDownloadNotifier(ref, assetId);
});

// Asset download state
class AssetDownloadState {
  final bool isDownloading;
  final double progress;
  final String? error;
  final Asset? asset;

  const AssetDownloadState({
    this.isDownloading = false,
    this.progress = 0.0,
    this.error,
    this.asset,
  });

  AssetDownloadState copyWith({
    bool? isDownloading,
    double? progress,
    String? error,
    Asset? asset,
  }) {
    return AssetDownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      progress: progress ?? this.progress,
      error: error,
      asset: asset ?? this.asset,
    );
  }
}

// Asset download notifier
class AssetDownloadNotifier extends StateNotifier<AssetDownloadState> {
  final Ref ref;
  final String assetId;

  AssetDownloadNotifier(this.ref, this.assetId) : super(const AssetDownloadState());

  Future<void> downloadAsset() async {
    state = state.copyWith(isDownloading: true, error: null, progress: 0.0);

    try {
      final repository = await ref.read(contentRepositoryProvider.future);
      final asset = await repository.getAsset(assetId);
      
      state = state.copyWith(
        isDownloading: false,
        progress: 1.0,
        asset: asset,
      );
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

// Lesson assets download provider
final lessonAssetsDownloadProvider = StateNotifierProvider.family<LessonAssetsDownloadNotifier, LessonAssetsDownloadState, String>((ref, lessonId) {
  return LessonAssetsDownloadNotifier(ref, lessonId);
});

// Lesson assets download state
class LessonAssetsDownloadState {
  final bool isDownloading;
  final double progress;
  final String? error;
  final List<Asset> downloadedAssets;

  const LessonAssetsDownloadState({
    this.isDownloading = false,
    this.progress = 0.0,
    this.error,
    this.downloadedAssets = const [],
  });

  LessonAssetsDownloadState copyWith({
    bool? isDownloading,
    double? progress,
    String? error,
    List<Asset>? downloadedAssets,
  }) {
    return LessonAssetsDownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      progress: progress ?? this.progress,
      error: error,
      downloadedAssets: downloadedAssets ?? this.downloadedAssets,
    );
  }
}

// Lesson assets download notifier
class LessonAssetsDownloadNotifier extends StateNotifier<LessonAssetsDownloadState> {
  final Ref ref;
  final String lessonId;

  LessonAssetsDownloadNotifier(this.ref, this.lessonId) : super(const LessonAssetsDownloadState());

  Future<void> downloadLessonAssets() async {
    state = state.copyWith(isDownloading: true, error: null, progress: 0.0);

    try {
      final repository = await ref.read(contentRepositoryProvider.future);
      await repository.downloadLessonAssets(lessonId);
      
      // Get the downloaded assets
      final downloadedAssets = await repository.getDownloadedAssets();
      
      state = state.copyWith(
        isDownloading: false,
        progress: 1.0,
        downloadedAssets: downloadedAssets,
      );
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


