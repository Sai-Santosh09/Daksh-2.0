import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/chapter_provider.dart';
import '../providers/class_provider.dart';

class ChaptersListPage extends ConsumerWidget {
  
  const ChaptersListPage({
    super.key,
    required this.classNumber,
    required this.subjectId,
  });
  final int classNumber;
  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapters = ref.watch(chaptersForSubjectProvider(subjectId));
    final subject = ref.watch(subjectByIdProvider(subjectId));
    final classEntity = ref.watch(classByNumberProvider(classNumber));

    if (subject == null || classEntity == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(
          child: Text('Subject or class not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${classEntity.displayName} - ${subject.displayName}'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _getSubjectColor(subject.colorHex).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      child: Icon(
                        _getSubjectIcon(subject.iconName),
                        size: 30,
                        color: _getSubjectColor(subject.colorHex),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject.displayName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${chapters.length} Chapters Available',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            // Chapters Section
            Text(
              'Chapters',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            // Chapters List
            Expanded(
              child: ListView.builder(
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  return _buildChapterCard(context, ref, chapter);
                },
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.go('/subjects/$classNumber');
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacingM,
                  ),
                ),
                child: const Text('Go Back to Subjects'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterCard(BuildContext context, WidgetRef ref, chapter) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: InkWell(
        onTap: () {
          ref.read(selectedChapterProvider.notifier).state = chapter.id;
          context.push('/chapter/${chapter.id}');
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              // Chapter Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getChapterTypeColor(chapter.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Icon(
                  _getChapterTypeIcon(chapter.type),
                  color: _getChapterTypeColor(chapter.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              
              // Chapter Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chapter.description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          chapter.formattedDuration,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(chapter.difficulty).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chapter.difficulty.toUpperCase(),
                            style: TextStyle(
                              color: _getDifficultyColor(chapter.difficulty),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (chapter.isCompleted)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          )
                        else
                          Icon(
                            Icons.play_circle_outline,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSubjectColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  IconData _getSubjectIcon(String iconName) {
    switch (iconName) {
      case 'language':
        return Icons.language;
      case 'translate':
        return Icons.translate;
      case 'calculate':
        return Icons.calculate;
      case 'science':
        return Icons.science;
      case 'public':
        return Icons.public;
      default:
        return Icons.book;
    }
  }

  Color _getChapterTypeColor(chapterType) {
    switch (chapterType.toString()) {
      case 'ChapterType.video':
        return Colors.red;
      case 'ChapterType.interactive':
        return Colors.blue;
      case 'ChapterType.assessment':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getChapterTypeIcon(chapterType) {
    switch (chapterType.toString()) {
      case 'ChapterType.video':
        return Icons.play_circle_outline;
      case 'ChapterType.interactive':
        return Icons.touch_app;
      case 'ChapterType.assessment':
        return Icons.quiz;
      default:
        return Icons.book;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
