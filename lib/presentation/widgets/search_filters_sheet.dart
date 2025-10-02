import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/search_service.dart';
import '../../domain/entities/lesson.dart';

class SearchFiltersSheet extends StatefulWidget {
  final SearchFilters? currentFilters;
  final Function(SearchFilters) onFiltersChanged;

  const SearchFiltersSheet({
    super.key,
    this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<SearchFiltersSheet> createState() => _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends State<SearchFiltersSheet> {
  late SearchFilters _filters;

  // Available options
  static const List<String> _categories = [
    'Grammar',
    'Vocabulary',
    'Pronunciation',
    'Writing',
    'Reading',
    'Listening',
    'Speaking',
  ];

  static const List<String> _difficulties = [
    'beginner',
    'intermediate',
    'advanced',
  ];

  static const List<LessonType> _lessonTypes = [
    LessonType.interactive,
    LessonType.video,
    LessonType.reading,
    LessonType.exercise,
    LessonType.assessment,
  ];

  static const List<String> _sortOptions = [
    'relevance',
    'title',
    'duration',
    'date',
  ];

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters ?? const SearchFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search Filters',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters = const SearchFilters();
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),

          const Divider(),

          // Filters content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  _buildFilterSection(
                    'Categories',
                    _buildCategoryFilters(),
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Difficulty
                  _buildFilterSection(
                    'Difficulty Level',
                    _buildDifficultyFilters(),
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Lesson Types
                  _buildFilterSection(
                    'Content Type',
                    _buildLessonTypeFilters(),
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Duration
                  _buildFilterSection(
                    'Duration',
                    _buildDurationFilters(),
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Completion Status
                  _buildFilterSection(
                    'Progress',
                    _buildCompletionFilters(),
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Sort Options
                  _buildFilterSection(
                    'Sort Results By',
                    _buildSortOptions(),
                  ),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFiltersChanged(_filters);
                  Navigator.of(context).pop();
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        content,
      ],
    );
  }

  Widget _buildCategoryFilters() {
    return Wrap(
      spacing: AppTheme.spacingS,
      runSpacing: AppTheme.spacingS,
      children: _categories.map((category) {
        final isSelected = _filters.categories?.contains(category) ?? false;
        return FilterChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final currentCategories = List<String>.from(_filters.categories ?? []);
              if (selected) {
                currentCategories.add(category);
              } else {
                currentCategories.remove(category);
              }
              _filters = _filters.copyWith(
                categories: currentCategories.isEmpty ? null : currentCategories,
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDifficultyFilters() {
    return Wrap(
      spacing: AppTheme.spacingS,
      runSpacing: AppTheme.spacingS,
      children: _difficulties.map((difficulty) {
        final isSelected = _filters.difficulties?.contains(difficulty) ?? false;
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getDifficultyIcon(difficulty),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(difficulty.toUpperCase()),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final currentDifficulties = List<String>.from(_filters.difficulties ?? []);
              if (selected) {
                currentDifficulties.add(difficulty);
              } else {
                currentDifficulties.remove(difficulty);
              }
              _filters = _filters.copyWith(
                difficulties: currentDifficulties.isEmpty ? null : currentDifficulties,
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildLessonTypeFilters() {
    return Wrap(
      spacing: AppTheme.spacingS,
      runSpacing: AppTheme.spacingS,
      children: _lessonTypes.map((type) {
        final isSelected = _filters.lessonTypes?.contains(type) ?? false;
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getLessonTypeIcon(type),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(_getLessonTypeLabel(type)),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final currentTypes = List<LessonType>.from(_filters.lessonTypes ?? []);
              if (selected) {
                currentTypes.add(type);
              } else {
                currentTypes.remove(type);
              }
              _filters = _filters.copyWith(
                lessonTypes: currentTypes.isEmpty ? null : currentTypes,
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDurationFilters() {
    return Column(
      children: [
        // Min duration
        Row(
          children: [
            const Text('Minimum: '),
            Expanded(
              child: Slider(
                value: (_filters.minDuration ?? 0).toDouble(),
                min: 0,
                max: 120,
                divisions: 24,
                label: '${_filters.minDuration ?? 0} min',
                onChanged: (value) {
                  setState(() {
                    _filters = _filters.copyWith(
                      minDuration: value.round() == 0 ? null : value.round(),
                    );
                  });
                },
              ),
            ),
            Text('${_filters.minDuration ?? 0} min'),
          ],
        ),

        // Max duration
        Row(
          children: [
            const Text('Maximum: '),
            Expanded(
              child: Slider(
                value: (_filters.maxDuration ?? 120).toDouble(),
                min: 0,
                max: 120,
                divisions: 24,
                label: '${_filters.maxDuration ?? 120} min',
                onChanged: (value) {
                  setState(() {
                    _filters = _filters.copyWith(
                      maxDuration: value.round() == 120 ? null : value.round(),
                    );
                  });
                },
              ),
            ),
            Text('${_filters.maxDuration ?? 120} min'),
          ],
        ),
      ],
    );
  }

  Widget _buildCompletionFilters() {
    return Column(
      children: [
        RadioListTile<bool?>(
          title: const Text('All lessons'),
          value: null,
          groupValue: _filters.completed,
          onChanged: (value) {
            setState(() {
              _filters = _filters.copyWith(completed: value);
            });
          },
        ),
        RadioListTile<bool?>(
          title: const Text('Completed only'),
          value: true,
          groupValue: _filters.completed,
          onChanged: (value) {
            setState(() {
              _filters = _filters.copyWith(completed: value);
            });
          },
        ),
        RadioListTile<bool?>(
          title: const Text('Not completed'),
          value: false,
          groupValue: _filters.completed,
          onChanged: (value) {
            setState(() {
              _filters = _filters.copyWith(completed: value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    return Column(
      children: _sortOptions.map((option) {
        return RadioListTile<String>(
          title: Text(_getSortLabel(option)),
          subtitle: Text(_getSortDescription(option)),
          value: option,
          groupValue: _filters.sortBy,
          onChanged: (value) {
            setState(() {
              _filters = _filters.copyWith(sortBy: value);
            });
          },
        );
      }).toList(),
    );
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Icons.star_border;
      case 'intermediate':
        return Icons.star_half;
      case 'advanced':
        return Icons.star;
      default:
        return Icons.help_outline;
    }
  }

  IconData _getLessonTypeIcon(LessonType type) {
    switch (type) {
      case LessonType.interactive:
        return Icons.touch_app;
      case LessonType.video:
        return Icons.play_circle_outline;
      case LessonType.reading:
        return Icons.menu_book;
      case LessonType.exercise:
        return Icons.fitness_center;
      case LessonType.assessment:
        return Icons.quiz;
    }
  }

  String _getLessonTypeLabel(LessonType type) {
    switch (type) {
      case LessonType.interactive:
        return 'Interactive';
      case LessonType.video:
        return 'Video';
      case LessonType.reading:
        return 'Reading';
      case LessonType.exercise:
        return 'Exercise';
      case LessonType.assessment:
        return 'Assessment';
    }
  }

  String _getSortLabel(String sortBy) {
    switch (sortBy) {
      case 'relevance':
        return 'Relevance';
      case 'title':
        return 'Title';
      case 'duration':
        return 'Duration';
      case 'date':
        return 'Date Modified';
      default:
        return sortBy;
    }
  }

  String _getSortDescription(String sortBy) {
    switch (sortBy) {
      case 'relevance':
        return 'Most relevant results first';
      case 'title':
        return 'Alphabetical order';
      case 'duration':
        return 'Shortest to longest';
      case 'date':
        return 'Most recently updated';
      default:
        return '';
    }
  }
}
