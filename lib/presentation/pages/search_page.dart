import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/search_service.dart';
import '../providers/search_provider.dart';
import '../widgets/search_result_card.dart';
import '../widgets/search_filters_sheet.dart';
import '../../generated/l10n/app_localizations.dart';

class SearchPage extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchPage({
    super.key,
    this.initialQuery,
  });

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _searchFocusNode = FocusNode();
    
    // Perform initial search if query provided
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchProvider.notifier).search(widget.initialQuery!);
      });
    }

    // Listen to focus changes
    _searchFocusNode.addListener(() {
      setState(() {
        _showSuggestions = _searchFocusNode.hasFocus && _searchController.text.length >= 2;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final searchState = ref.watch(searchProvider);
    final popularTerms = ref.watch(popularSearchTermsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.search),
        elevation: 1,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search input
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: l10n.searchLessons,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              _searchController.clear();
                              ref.read(searchProvider.notifier).clearSearch();
                              setState(() {
                                _showSuggestions = false;
                              });
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        IconButton(
                          onPressed: () => _showFiltersSheet(context),
                          icon: Icon(
                            Icons.tune,
                            color: searchState.filters != null 
                                ? Theme.of(context).primaryColor 
                                : null,
                          ),
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _showSuggestions = value.length >= 2 && _searchFocusNode.hasFocus;
                    });
                    
                    if (value.length >= 2) {
                      ref.read(searchProvider.notifier).getSuggestions(value);
                    }
                  },
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      ref.read(searchProvider.notifier).search(value);
                      _searchFocusNode.unfocus();
                      setState(() {
                        _showSuggestions = false;
                      });
                    }
                  },
                ),

                // Active filters indicator
                if (searchState.filters != null) ...[
                  const SizedBox(height: AppTheme.spacingS),
                  _buildActiveFilters(context, searchState.filters!),
                ],
              ],
            ),
          ),

          // Content area
          Expanded(
            child: _showSuggestions
                ? _buildSuggestions(context, searchState)
                : _buildSearchResults(context, searchState, popularTerms),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context, SearchState searchState) {
    if (searchState.isLoadingSuggestions) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingL),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (searchState.suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: searchState.suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = searchState.suggestions[index];
        return ListTile(
          leading: const Icon(Icons.search, color: Colors.grey),
          title: Text(suggestion),
          onTap: () {
            _searchController.text = suggestion;
            ref.read(searchProvider.notifier).search(suggestion);
            _searchFocusNode.unfocus();
            setState(() {
              _showSuggestions = false;
            });
          },
        );
      },
    );
  }

  Widget _buildSearchResults(BuildContext context, SearchState searchState, List<String> popularTerms) {
    if (searchState.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingL),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (searchState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                'Search Error',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                searchState.error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              ElevatedButton(
                onPressed: () {
                  if (searchState.query.isNotEmpty) {
                    ref.read(searchProvider.notifier).search(searchState.query);
                  }
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (searchState.query.isEmpty) {
      return _buildEmptyState(context, searchState, popularTerms);
    }

    if (searchState.results.isEmpty) {
      return _buildNoResults(context, searchState);
    }

    return _buildResultsList(context, searchState);
  }

  Widget _buildEmptyState(BuildContext context, SearchState searchState, List<String> popularTerms) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (searchState.recentSearches.isNotEmpty) ...[
            Text(
              'Recent Searches',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Wrap(
              spacing: AppTheme.spacingS,
              runSpacing: AppTheme.spacingS,
              children: searchState.recentSearches.map((term) {
                return ActionChip(
                  label: Text(term),
                  onPressed: () {
                    _searchController.text = term;
                    ref.read(searchProvider.notifier).search(term);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spacingL),
          ],

          // Popular search terms
          Text(
            'Popular Searches',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Wrap(
            spacing: AppTheme.spacingS,
            runSpacing: AppTheme.spacingS,
            children: popularTerms.map((term) {
              return ActionChip(
                label: Text(term),
                onPressed: () {
                  _searchController.text = term;
                  ref.read(searchProvider.notifier).search(term);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: AppTheme.spacingL),

          // Search tips
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tips_and_updates, color: Colors.blue),
                      const SizedBox(width: AppTheme.spacingS),
                      Text(
                        'Search Tips',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  const Text('• Search by lesson title, description, or category'),
                  const Text('• Use filters to narrow down results'),
                  const Text('• Try keywords like "beginner", "grammar", "video"'),
                  const Text('• Search results include lessons, chapters, and assets'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(BuildContext context, SearchState searchState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'No Results Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'No results found for "${searchState.query}"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => _showFiltersSheet(context),
                  child: const Text('Adjust Filters'),
                ),
                const SizedBox(height: AppTheme.spacingS),
                TextButton(
                  onPressed: () {
                    ref.read(searchProvider.notifier).clearSearch();
                    _searchController.clear();
                  },
                  child: const Text('Clear Search'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, SearchState searchState) {
    return Column(
      children: [
        // Results count
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacingM),
          color: Colors.grey.shade50,
          child: Text(
            '${searchState.results.length} results for "${searchState.query}"',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            itemCount: searchState.results.length,
            itemBuilder: (context, index) {
              final result = searchState.results[index];
              return SearchResultCard(
                result: result,
                onTap: () => _handleResultTap(context, result),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFilters(BuildContext context, SearchFilters filters) {
    final activeFilters = <Widget>[];

    if (filters.categories != null && filters.categories!.isNotEmpty) {
      activeFilters.add(
        Chip(
          label: Text('Categories: ${filters.categories!.join(', ')}'),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            final newFilters = filters.copyWith(categories: null);
            ref.read(searchProvider.notifier).updateFilters(newFilters);
          },
        ),
      );
    }

    if (filters.difficulties != null && filters.difficulties!.isNotEmpty) {
      activeFilters.add(
        Chip(
          label: Text('Difficulty: ${filters.difficulties!.join(', ')}'),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            final newFilters = filters.copyWith(difficulties: null);
            ref.read(searchProvider.notifier).updateFilters(newFilters);
          },
        ),
      );
    }

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: AppTheme.spacingS,
            children: activeFilters,
          ),
        ),
        TextButton(
          onPressed: () {
            ref.read(searchProvider.notifier).clearFilters();
          },
          child: const Text('Clear All'),
        ),
      ],
    );
  }

  void _showFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SearchFiltersSheet(
        currentFilters: ref.read(searchProvider).filters,
        onFiltersChanged: (filters) {
          ref.read(searchProvider.notifier).updateFilters(filters);
        },
      ),
    );
  }

  void _handleResultTap(BuildContext context, SearchResult result) {
    // Navigate to the appropriate page based on result type
    switch (result.type) {
      case 'lesson':
        Navigator.of(context).pushNamed('/lesson/${result.id}');
        break;
      case 'asset':
        Navigator.of(context).pushNamed('/player/${result.id}');
        break;
      case 'chapter':
        Navigator.of(context).pushNamed('/chapter/${result.id}');
        break;
    }
  }
}
