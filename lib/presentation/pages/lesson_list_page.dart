import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/class_provider.dart';

class LessonListPage extends ConsumerWidget {
  final int classNumber;
  final String subjectId;
  
  const LessonListPage({
    super.key,
    required this.classNumber,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                            subject.description,
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
            
            // Lessons Section
            Text(
              'Lessons',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            // Sample Lessons (you can replace this with actual lesson data)
            Expanded(
              child: ListView.builder(
                itemCount: _getSampleLessons(subject.name).length,
                itemBuilder: (context, index) {
                  final lesson = _getSampleLessons(subject.name)[index];
                  return _buildLessonCard(context, lesson);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, Map<String, dynamic> lesson) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
          child: Icon(
            Icons.play_circle_outline,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          lesson['title'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(lesson['description']),
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
                  lesson['duration'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.school,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  lesson['difficulty'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade400,
        ),
        onTap: () {
          // Navigate to lesson detail
          context.push('/lesson/${lesson['id']}');
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getSampleLessons(String subjectName) {
    switch (subjectName) {
      case 'english':
        return [
          {
            'id': '1',
            'title': 'Introduction to English Grammar',
            'description': 'Learn the basics of English grammar and sentence structure',
            'duration': '15 min',
            'difficulty': 'Beginner',
          },
          {
            'id': '2',
            'title': 'Parts of Speech',
            'description': 'Understanding nouns, verbs, adjectives, and more',
            'duration': '20 min',
            'difficulty': 'Beginner',
          },
          {
            'id': '3',
            'title': 'Reading Comprehension',
            'description': 'Practice reading and understanding texts',
            'duration': '25 min',
            'difficulty': 'Intermediate',
          },
        ];
      case 'mathematics':
        return [
          {
            'id': '4',
            'title': 'Basic Addition and Subtraction',
            'description': 'Learn fundamental arithmetic operations',
            'duration': '18 min',
            'difficulty': 'Beginner',
          },
          {
            'id': '5',
            'title': 'Multiplication Tables',
            'description': 'Master multiplication from 1 to 10',
            'duration': '22 min',
            'difficulty': 'Beginner',
          },
          {
            'id': '6',
            'title': 'Word Problems',
            'description': 'Solve real-world math problems',
            'duration': '30 min',
            'difficulty': 'Intermediate',
          },
        ];
      case 'science':
        return [
          {
            'id': '7',
            'title': 'Introduction to Plants',
            'description': 'Learn about different types of plants and their parts',
            'duration': '20 min',
            'difficulty': 'Beginner',
          },
          {
            'id': '8',
            'title': 'Water Cycle',
            'description': 'Understand how water moves through the environment',
            'duration': '25 min',
            'difficulty': 'Intermediate',
          },
        ];
      default:
        return [
          {
            'id': '9',
            'title': 'Introduction to ${subjectName}',
            'description': 'Get started with ${subjectName}',
            'duration': '15 min',
            'difficulty': 'Beginner',
          },
        ];
    }
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
}

