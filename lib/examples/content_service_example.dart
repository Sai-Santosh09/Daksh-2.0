import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/providers/content_provider.dart';
import '../domain/entities/lesson.dart';
import '../domain/entities/asset.dart';

/// Example widget demonstrating how to use the ContentService
class ContentServiceExample extends ConsumerWidget {
  const ContentServiceExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider);
    final refreshState = ref.watch(contentRefreshProvider);
    final cacheSizeAsync = ref.watch(cacheSizeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Service Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(contentRefreshProvider.notifier).refreshContent(forceRefresh: true);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Refresh status
          if (refreshState.isRefreshing)
            const LinearProgressIndicator(),
          
          if (refreshState.error != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red.shade100,
              child: Text(
                'Error: ${refreshState.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),

          // Cache size
          cacheSizeAsync.when(
            data: (size) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Cache Size: ${_formatBytes(size)}'),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),

          // Lessons list
          Expanded(
            child: lessonsAsync.when(
              data: (lessons) => ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return LessonCard(
                    lesson: lesson,
                    onDownloadAssets: () {
                      ref.read(lessonAssetsDownloadProvider(lesson.id).notifier)
                          .downloadLessonAssets();
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading lessons: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class LessonCard extends ConsumerWidget {
  final Lesson lesson;
  final VoidCallback onDownloadAssets;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onDownloadAssets,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadState = ref.watch(lessonAssetsDownloadProvider(lesson.id));

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(lesson.id.substring(lesson.id.length - 1)),
        ),
        title: Text(lesson.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lesson.description),
            const SizedBox(height: 4),
            Text('Duration: ${lesson.formattedDuration}'),
            Text('Difficulty: ${lesson.difficulty}'),
            Text('Assets: ${lesson.assetIds.length}'),
            if (downloadState.isDownloading)
              LinearProgressIndicator(value: downloadState.progress),
            if (downloadState.error != null)
              Text(
                'Download Error: ${downloadState.error}',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: downloadState.isDownloading ? null : onDownloadAssets,
            ),
            if (downloadState.downloadedAssets.isNotEmpty)
              Text('${downloadState.downloadedAssets.length} downloaded'),
          ],
        ),
        onTap: () {
          // Navigate to lesson detail
          _showLessonDetail(context, ref, lesson);
        },
      ),
    );
  }

  void _showLessonDetail(BuildContext context, WidgetRef ref, Lesson lesson) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lesson.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${lesson.description}'),
            const SizedBox(height: 8),
            Text('Category: ${lesson.category}'),
            Text('Duration: ${lesson.formattedDuration}'),
            Text('Difficulty: ${lesson.difficulty}'),
            Text('Type: ${lesson.type.name}'),
            Text('Assets: ${lesson.assetIds.length}'),
            if (lesson.prerequisites != null)
              Text('Prerequisites: ${lesson.prerequisites}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDownloadAssets();
            },
            child: const Text('Download Assets'),
          ),
        ],
      ),
    );
  }
}

/// Example of how to use the ContentService directly
class ContentServiceDirectExample {
  static Future<void> demonstrateUsage() async {
    // This would typically be done through dependency injection
    // but here's how you would use it directly:

    /*
    // 1. Initialize dependencies
    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final connectivity = Connectivity();
    
    // 2. Create ContentService
    final contentService = ContentService(
      dio: dio,
      prefs: prefs,
      connectivity: connectivity,
    );

    try {
      // 3. Get manifest (offline-first)
      final manifest = await contentService.getManifest();
      print('Manifest version: ${manifest.version}');
      print('Lessons count: ${manifest.lessons.length}');
      print('Assets count: ${manifest.assets.length}');

      // 4. Get lessons
      final lessons = await contentService.getLessons();
      print('Available lessons: ${lessons.length}');

      // 5. Get lessons by category
      final grammarLessons = await contentService.getLessons(category: 'Parts of Speech');
      print('Grammar lessons: ${grammarLessons.length}');

      // 6. Get a specific lesson
      final lesson = await contentService.getLesson('lesson_001');
      if (lesson != null) {
        print('Lesson title: ${lesson.title}');
        
        // 7. Download lesson assets
        await contentService.downloadLessonAssets(lesson.id);
        print('Assets downloaded for lesson: ${lesson.id}');
      }

      // 8. Get downloaded assets
      final downloadedAssets = await contentService.getDownloadedAssets();
      print('Downloaded assets: ${downloadedAssets.length}');

      // 9. Get cache size
      final cacheSize = await contentService.getCacheSize();
      print('Cache size: $cacheSize bytes');

      // 10. Force refresh content
      await contentService.getManifest(forceRefresh: true);
      print('Content refreshed');

    } catch (e) {
      print('Error: $e');
    }
    */
  }
}


