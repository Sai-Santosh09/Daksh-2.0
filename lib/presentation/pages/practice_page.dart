import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';
import 'search_page.dart';

class PracticePage extends ConsumerWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.practice),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchPage(initialQuery: 'practice'),
                ),
              );
            },
            icon: const Icon(Icons.search),
            tooltip: 'Search practice materials',
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement practice settings
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Practice settings',
          ),
        ],
      ),
      body: _buildPracticeContent(context, l10n),
    );
  }

  Widget _buildPracticeContent(BuildContext context, AppLocalizations l10n) {
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
                    'Practice Exercises',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Practice what you\'ve learned with interactive exercises and quizzes.',
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
                          child: const Text('Start Practice'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Practice categories
          Text(
            'Practice Categories',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AppTheme.spacingM,
            mainAxisSpacing: AppTheme.spacingM,
            childAspectRatio: 1.2,
            children: [
              _buildPracticeCard(
                context,
                'Quick Quiz',
                Icons.quiz,
                'Test your knowledge with quick quizzes',
                () => context.go('/classes'),
              ),
              _buildPracticeCard(
                context,
                'Flashcards',
                Icons.style,
                'Review concepts with flashcards',
                () => context.go('/classes'),
              ),
              _buildPracticeCard(
                context,
                'Fill in the Blanks',
                Icons.edit_note,
                'Complete sentences and exercises',
                () => context.go('/classes'),
              ),
              _buildPracticeCard(
                context,
                'Multiple Choice',
                Icons.radio_button_checked,
                'Choose the correct answers',
                () => context.go('/classes'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}