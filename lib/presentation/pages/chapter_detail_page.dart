import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/chapter_provider.dart';

class ChapterDetailPage extends ConsumerWidget {
  
  const ChapterDetailPage({
    super.key,
    required this.chapterId,
  });
  final String chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter = ref.watch(chapterByIdProvider(chapterId));
    final quiz = ref.watch(quizForChapterProvider(chapterId));

    if (chapter == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chapter Not Found')),
        body: const Center(
          child: Text('Chapter not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.title),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chapter Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _getChapterTypeColor(chapter.type).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          ),
                          child: Icon(
                            _getChapterTypeIcon(chapter.type),
                            color: _getChapterTypeColor(chapter.type),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapter.title,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      chapter.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Learning Objectives
            if (chapter.learningObjectives.isNotEmpty) ...[
              Text(
                'Learning Objectives',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    children: chapter.learningObjectives.map((objective) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: AppTheme.spacingS),
                            Expanded(
                              child: Text(
                                objective,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).toList(),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
            ],
            
            // Video Section
            if (chapter.hasVideo) ...[
              Text(
                'Video Lesson',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              Card(
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        'Video Player',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to play video lesson',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
            ],
            
            // Content Section
            if (chapter.hasContent) ...[
              Text(
                'Chapter Content',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Text(
                    chapter.content!,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
            ],
            
            // Action Buttons
            if (quiz != null) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/quiz/${chapter.id}');
                  },
                  icon: const Icon(Icons.quiz),
                  label: const Text('Start Quiz'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingM,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
            ],
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Mark chapter as completed
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chapter marked as completed!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text('Mark as Completed'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacingM,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

