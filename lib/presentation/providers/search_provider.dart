import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/search_service.dart';
import '../../data/services/demo_data_service.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/asset.dart';
import '../../domain/entities/chapter_entity.dart';
import 'content_provider.dart';
import 'chapter_provider.dart';

// Search service provider
final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService();
});

// Search state
class SearchState {
  final String query;
  final List<SearchResult> results;
  final List<String> suggestions;
  final List<String> recentSearches;
  final SearchFilters? filters;
  final bool isLoading;
  final bool isLoadingSuggestions;
  final String? error;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.suggestions = const [],
    this.recentSearches = const [],
    this.filters,
    this.isLoading = false,
    this.isLoadingSuggestions = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    List<SearchResult>? results,
    List<String>? suggestions,
    List<String>? recentSearches,
    SearchFilters? filters,
    bool? isLoading,
    bool? isLoadingSuggestions,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      recentSearches: recentSearches ?? this.recentSearches,
      filters: filters ?? this.filters,
      isLoading: isLoading ?? this.isLoading,
      isLoadingSuggestions: isLoadingSuggestions ?? this.isLoadingSuggestions,
      error: error,
    );
  }
}

// Search notifier
class SearchNotifier extends StateNotifier<SearchState> {
  final Ref ref;

  SearchNotifier(this.ref) : super(const SearchState()) {
    _loadRecentSearches();
  }

  // Perform search
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(
        query: '',
        results: [],
        error: null,
      );
      return;
    }

    state = state.copyWith(
      query: query,
      isLoading: true,
      error: null,
    );

    try {
      final searchService = ref.read(searchServiceProvider);
      
      // Get data from providers
      final lessons = await _getLessons();
      final assets = await _getAssets();
      final chapters = await _getChapters();

      final results = await searchService.search(
        query,
        filters: state.filters,
        lessons: lessons,
        assets: assets,
        chapters: chapters,
      );

      // Save search term
      await searchService.saveSearchTerm(query);
      await _loadRecentSearches();

      state = state.copyWith(
        results: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Search failed: ${e.toString()}',
      );
    }
  }

  // Get search suggestions
  Future<void> getSuggestions(String partialQuery) async {
    if (partialQuery.trim().isEmpty || partialQuery.length < 2) {
      state = state.copyWith(suggestions: []);
      return;
    }

    state = state.copyWith(isLoadingSuggestions: true);

    try {
      final searchService = ref.read(searchServiceProvider);
      
      // Get data from providers
      final lessons = await _getLessons();
      final assets = await _getAssets();
      final chapters = await _getChapters();

      final suggestions = await searchService.getSuggestions(
        partialQuery,
        lessons: lessons,
        assets: assets,
        chapters: chapters,
      );

      state = state.copyWith(
        suggestions: suggestions,
        isLoadingSuggestions: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingSuggestions: false,
        suggestions: [],
      );
    }
  }

  // Update search filters
  void updateFilters(SearchFilters filters) {
    state = state.copyWith(filters: filters);
    
    // Re-search if there's an active query
    if (state.query.isNotEmpty) {
      search(state.query);
    }
  }

  // Clear search
  void clearSearch() {
    state = state.copyWith(
      query: '',
      results: [],
      suggestions: [],
      error: null,
    );
  }

  // Clear filters
  void clearFilters() {
    state = state.copyWith(filters: null);
    
    // Re-search if there's an active query
    if (state.query.isNotEmpty) {
      search(state.query);
    }
  }

  // Get popular search terms
  List<String> getPopularSearchTerms() {
    final searchService = ref.read(searchServiceProvider);
    return searchService.getPopularSearchTerms();
  }

  // Clear search history
  Future<void> clearSearchHistory() async {
    final searchService = ref.read(searchServiceProvider);
    await searchService.clearSearchHistory();
    state = state.copyWith(recentSearches: []);
  }

  // Private methods
  Future<List<Lesson>> _getLessons() async {
    try {
      final lessonsAsync = ref.read(lessonsProvider);
      return await lessonsAsync.when(
        data: (lessons) => lessons.isNotEmpty ? lessons : DemoDataService.getDemoLessons(),
        loading: () => DemoDataService.getDemoLessons(),
        error: (_, __) => DemoDataService.getDemoLessons(),
      );
    } catch (e) {
      return DemoDataService.getDemoLessons();
    }
  }

  Future<List<Asset>> _getAssets() async {
    try {
      final assetsAsync = ref.read(downloadedAssetsProvider);
      return await assetsAsync.when(
        data: (assets) => assets.isNotEmpty ? assets : DemoDataService.getDemoAssets(),
        loading: () => DemoDataService.getDemoAssets(),
        error: (_, __) => DemoDataService.getDemoAssets(),
      );
    } catch (e) {
      return DemoDataService.getDemoAssets();
    }
  }

  Future<List<ChapterEntity>> _getChapters() async {
    try {
      final chaptersAsync = ref.read(allChaptersProvider);
      return chaptersAsync.isNotEmpty ? chaptersAsync : DemoDataService.getDemoChapters();
    } catch (e) {
      return DemoDataService.getDemoChapters();
    }
  }

  Future<void> _loadRecentSearches() async {
    try {
      final searchService = ref.read(searchServiceProvider);
      final recentSearches = await searchService.getRecentSearches();
      state = state.copyWith(recentSearches: recentSearches);
    } catch (e) {
      // Ignore errors when loading recent searches
    }
  }
}

// Search provider
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});

// Quick search provider for simple queries
final quickSearchProvider = FutureProvider.family<List<SearchResult>, String>((ref, query) async {
  if (query.trim().isEmpty) {
    return [];
  }

  final searchService = ref.read(searchServiceProvider);
  
  // Get minimal data for quick search - use demo data as fallback
  final lessons = await ref.read(lessonsProvider.future).catchError((_) => DemoDataService.getDemoLessons());
  
  return await searchService.search(
    query,
    lessons: lessons.isNotEmpty ? lessons : DemoDataService.getDemoLessons(),
  );
});

// Search suggestions provider
final searchSuggestionsProvider = FutureProvider.family<List<String>, String>((ref, partialQuery) async {
  if (partialQuery.trim().isEmpty || partialQuery.length < 2) {
    return [];
  }

  final searchService = ref.read(searchServiceProvider);
  final lessons = await ref.read(lessonsProvider.future).catchError((_) => DemoDataService.getDemoLessons());
  
  return await searchService.getSuggestions(
    partialQuery,
    lessons: lessons.isNotEmpty ? lessons : DemoDataService.getDemoLessons(),
  );
});

// Popular search terms provider
final popularSearchTermsProvider = Provider<List<String>>((ref) {
  final searchService = ref.read(searchServiceProvider);
  return searchService.getPopularSearchTerms();
});

// Search filters state provider
final searchFiltersProvider = StateProvider<SearchFilters?>((ref) => null);
