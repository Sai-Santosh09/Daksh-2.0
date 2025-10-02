import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';
import 'search_page.dart';

class LearnPage extends ConsumerWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.learn),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
            tooltip: l10n.searchLessons,
          ),
        ],
      ),
      body: _buildLearnContent(context, l10n),
    );
  }

  Widget _buildLearnContent(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.welcomeMessage,
                    style: Theme.of(context).textTheme.headlineMedium,
                    semanticsLabel: l10n.welcomeMessage,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Start your educational journey with comprehensive lessons across all subjects designed for all skill levels.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.go('/classes');
                          },
                          child: const Text('Browse Classes'),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.go('/classes');
                          },
                          child: Text(l10n.startLearning),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Quick access section
          Text(
            'Quick Access',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                children: [
                  Icon(
                    Icons.school,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Text(
                    'Start Learning',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Browse classes and subjects to begin your learning journey.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/classes');
                    },
                    child: const Text('Browse Classes'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}