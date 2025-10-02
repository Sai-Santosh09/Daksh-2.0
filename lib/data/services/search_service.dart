import 'dart:async';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/asset.dart';
import '../../domain/entities/chapter_entity.dart';

class SearchResult {
  final String id;
  final String title;
  final String description;
  final String type; // 'lesson', 'asset', 'chapter'
  final double relevanceScore;
  final Map<String, dynamic> metadata;
  final String? thumbnailUrl;
  final List<String> tags;

  const SearchResult({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.relevanceScore,
    this.metadata = const {},
    this.thumbnailUrl,
    this.tags = const [],
  });
}

class SearchFilters {
  final List<String>? categories;
  final List<String>? difficulties;
  final List<LessonType>? lessonTypes;
  final List<String>? tags;
  final int? minDuration;
  final int? maxDuration;
  final bool? completed;
  final String? sortBy; // 'relevance', 'title', 'duration', 'date'
  final bool ascending;

  const SearchFilters({
    this.categories,
    this.difficulties,
    this.lessonTypes,
    this.tags,
    this.minDuration,
    this.maxDuration,
    this.completed,
    this.sortBy = 'relevance',
    this.ascending = false,
  });

  SearchFilters copyWith({
    List<String>? categories,
    List<String>? difficulties,
    List<LessonType>? lessonTypes,
    List<String>? tags,
    int? minDuration,
    int? maxDuration,
    bool? completed,
    String? sortBy,
    bool? ascending,
  }) {
    return SearchFilters(
      categories: categories ?? this.categories,
      difficulties: difficulties ?? this.difficulties,
      lessonTypes: lessonTypes ?? this.lessonTypes,
      tags: tags ?? this.tags,
      minDuration: minDuration ?? this.minDuration,
      maxDuration: maxDuration ?? this.maxDuration,
      completed: completed ?? this.completed,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }
}

class SearchService {
  static const int maxResults = 50;
  static const double minRelevanceScore = 0.1;

  // Search across all content types
  Future<List<SearchResult>> search(
    String query, {
    SearchFilters? filters,
    List<Lesson>? lessons,
    List<Asset>? assets,
    List<ChapterEntity>? chapters,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final results = <SearchResult>[];
    final normalizedQuery = query.toLowerCase().trim();

    // Search lessons
    if (lessons != null) {
      final lessonResults = await _searchLessons(normalizedQuery, lessons, filters);
      results.addAll(lessonResults);
    }

    // Search assets
    if (assets != null) {
      final assetResults = await _searchAssets(normalizedQuery, assets, filters);
      results.addAll(assetResults);
    }

    // Search chapters
    if (chapters != null) {
      final chapterResults = await _searchChapters(normalizedQuery, chapters, filters);
      results.addAll(chapterResults);
    }

    // Filter by relevance score
    final filteredResults = results
        .where((result) => result.relevanceScore >= minRelevanceScore)
        .toList();

    // Sort results
    _sortResults(filteredResults, filters?.sortBy ?? 'relevance', filters?.ascending ?? false);

    // Limit results
    return filteredResults.take(maxResults).toList();
  }

  // Search suggestions based on partial input
  Future<List<String>> getSuggestions(
    String partialQuery, {
    List<Lesson>? lessons,
    List<Asset>? assets,
    List<ChapterEntity>? chapters,
  }) async {
    if (partialQuery.trim().isEmpty || partialQuery.length < 2) {
      return [];
    }

    final suggestions = <String>{};
    final normalizedQuery = partialQuery.toLowerCase().trim();

    // Get suggestions from lessons
    if (lessons != null) {
      for (final lesson in lessons) {
        _addSuggestions(suggestions, normalizedQuery, [
          lesson.title,
          lesson.description,
          lesson.category,
          ...lesson.tags,
        ]);
      }
    }

    // Get suggestions from assets
    if (assets != null) {
      for (final asset in assets) {
        _addSuggestions(suggestions, normalizedQuery, [
          asset.name,
          asset.description,
          asset.type.toString(),
        ]);
      }
    }

    // Get suggestions from chapters
    if (chapters != null) {
      for (final chapter in chapters) {
        _addSuggestions(suggestions, normalizedQuery, [
          chapter.title,
          chapter.description,
          chapter.subjectId,
        ]);
      }
    }

    return suggestions.take(10).toList();
  }

  // Get popular/trending search terms
  List<String> getPopularSearchTerms() {
    return [
      'grammar',
      'vocabulary',
      'pronunciation',
      'writing',
      'reading',
      'speaking',
      'listening',
      'beginner',
      'intermediate',
      'advanced',
      'exercises',
      'practice',
      'quiz',
      'video lessons',
    ];
  }

  // Get recent search history (this would typically be stored in SharedPreferences)
  Future<List<String>> getRecentSearches() async {
    // TODO: Implement persistent search history
    return [
      'English grammar',
      'Basic vocabulary',
      'Pronunciation guide',
    ];
  }

  // Save search term to history
  Future<void> saveSearchTerm(String term) async {
    // TODO: Implement search history persistence
  }

  // Clear search history
  Future<void> clearSearchHistory() async {
    // TODO: Implement search history clearing
  }

  // Private methods

  Future<List<SearchResult>> _searchLessons(
    String query,
    List<Lesson> lessons,
    SearchFilters? filters,
  ) async {
    final results = <SearchResult>[];

    for (final lesson in lessons) {
      // Apply filters first
      if (!_matchesLessonFilters(lesson, filters)) {
        continue;
      }

      final relevanceScore = _calculateLessonRelevance(query, lesson);
      if (relevanceScore >= minRelevanceScore) {
        results.add(SearchResult(
          id: lesson.id,
          title: lesson.title,
          description: lesson.description,
          type: 'lesson',
          relevanceScore: relevanceScore,
          thumbnailUrl: lesson.thumbnailUrl,
          tags: lesson.tags,
          metadata: {
            'category': lesson.category,
            'difficulty': lesson.difficulty,
            'duration': lesson.duration,
            'type': lesson.type.toString(),
            'progress': lesson.progress,
            'isCompleted': lesson.isCompleted,
          },
        ));
      }
    }

    return results;
  }

  Future<List<SearchResult>> _searchAssets(
    String query,
    List<Asset> assets,
    SearchFilters? filters,
  ) async {
    final results = <SearchResult>[];

    for (final asset in assets) {
      final relevanceScore = _calculateAssetRelevance(query, asset);
      if (relevanceScore >= minRelevanceScore) {
        results.add(SearchResult(
          id: asset.id,
          title: asset.name,
          description: asset.description,
          type: 'asset',
          relevanceScore: relevanceScore,
          metadata: {
            'type': asset.type.toString(),
            'mimeType': asset.mimeType,
            'size': asset.sizeBytes,
          },
        ));
      }
    }

    return results;
  }

  Future<List<SearchResult>> _searchChapters(
    String query,
    List<ChapterEntity> chapters,
    SearchFilters? filters,
  ) async {
    final results = <SearchResult>[];

    for (final chapter in chapters) {
      final relevanceScore = _calculateChapterRelevance(query, chapter);
      if (relevanceScore >= minRelevanceScore) {
        results.add(SearchResult(
          id: chapter.id,
          title: chapter.title,
          description: chapter.description,
          type: 'chapter',
          relevanceScore: relevanceScore,
          metadata: {
            'subjectId': chapter.subjectId,
            'orderIndex': chapter.orderIndex,
            'isCompleted': chapter.isCompleted,
            'difficulty': chapter.difficulty,
            'duration': chapter.estimatedDuration.inMinutes,
          },
        ));
      }
    }

    return results;
  }

  bool _matchesLessonFilters(Lesson lesson, SearchFilters? filters) {
    if (filters == null) return true;

    // Category filter
    if (filters.categories != null && 
        !filters.categories!.contains(lesson.category)) {
      return false;
    }

    // Difficulty filter
    if (filters.difficulties != null && 
        !filters.difficulties!.contains(lesson.difficulty)) {
      return false;
    }

    // Lesson type filter
    if (filters.lessonTypes != null && 
        !filters.lessonTypes!.contains(lesson.type)) {
      return false;
    }

    // Duration filter
    if (filters.minDuration != null && lesson.duration < filters.minDuration!) {
      return false;
    }
    if (filters.maxDuration != null && lesson.duration > filters.maxDuration!) {
      return false;
    }

    // Completion filter
    if (filters.completed != null && lesson.isCompleted != filters.completed!) {
      return false;
    }

    // Tags filter
    if (filters.tags != null && filters.tags!.isNotEmpty) {
      final hasMatchingTag = filters.tags!.any((tag) => 
          lesson.tags.any((lessonTag) => 
              lessonTag.toLowerCase().contains(tag.toLowerCase())));
      if (!hasMatchingTag) {
        return false;
      }
    }

    return true;
  }

  double _calculateLessonRelevance(String query, Lesson lesson) {
    double score = 0.0;
    final queryWords = query.split(' ').where((w) => w.isNotEmpty).toList();

    for (final word in queryWords) {
      // Title match (highest weight)
      if (lesson.title.toLowerCase().contains(word)) {
        score += 1.0;
        if (lesson.title.toLowerCase().startsWith(word)) {
          score += 0.5; // Bonus for starting with query
        }
      }

      // Description match
      if (lesson.description.toLowerCase().contains(word)) {
        score += 0.6;
      }

      // Category match
      if (lesson.category.toLowerCase().contains(word)) {
        score += 0.8;
      }

      // Tags match
      for (final tag in lesson.tags) {
        if (tag.toLowerCase().contains(word)) {
          score += 0.4;
        }
      }

      // Difficulty match
      if (lesson.difficulty.toLowerCase().contains(word)) {
        score += 0.3;
      }
    }

    // Normalize score by query length
    return queryWords.isEmpty ? 0.0 : score / queryWords.length;
  }

  double _calculateAssetRelevance(String query, Asset asset) {
    double score = 0.0;
    final queryWords = query.split(' ').where((w) => w.isNotEmpty).toList();

    for (final word in queryWords) {
      if (asset.name.toLowerCase().contains(word)) {
        score += 1.0;
      }
      if (asset.description.toLowerCase().contains(word)) {
        score += 0.6;
      }
      if (asset.type.toString().toLowerCase().contains(word)) {
        score += 0.4;
      }
    }

    return queryWords.isEmpty ? 0.0 : score / queryWords.length;
  }

  double _calculateChapterRelevance(String query, ChapterEntity chapter) {
    double score = 0.0;
    final queryWords = query.split(' ').where((w) => w.isNotEmpty).toList();

    for (final word in queryWords) {
      if (chapter.title.toLowerCase().contains(word)) {
        score += 1.0;
      }
      if (chapter.description.toLowerCase().contains(word)) {
        score += 0.6;
      }
      if (chapter.subjectId.toLowerCase().contains(word)) {
        score += 0.8;
      }
    }

    return queryWords.isEmpty ? 0.0 : score / queryWords.length;
  }

  void _addSuggestions(Set<String> suggestions, String query, List<String> sources) {
    for (final source in sources) {
      final words = source.toLowerCase().split(' ');
      for (final word in words) {
        if (word.startsWith(query) && word.length > query.length) {
          suggestions.add(word);
        }
      }
      
      // Add full phrases that contain the query
      if (source.toLowerCase().contains(query) && source.length > query.length) {
        suggestions.add(source);
      }
    }
  }

  void _sortResults(List<SearchResult> results, String sortBy, bool ascending) {
    results.sort((a, b) {
      int comparison;
      
      switch (sortBy) {
        case 'title':
          comparison = a.title.compareTo(b.title);
          break;
        case 'duration':
          final aDuration = a.metadata['duration'] as int? ?? 0;
          final bDuration = b.metadata['duration'] as int? ?? 0;
          comparison = aDuration.compareTo(bDuration);
          break;
        case 'date':
          // For now, sort by title as a fallback
          comparison = a.title.compareTo(b.title);
          break;
        case 'relevance':
        default:
          comparison = b.relevanceScore.compareTo(a.relevanceScore);
          break;
      }

      return ascending ? comparison : -comparison;
    });
  }
}
