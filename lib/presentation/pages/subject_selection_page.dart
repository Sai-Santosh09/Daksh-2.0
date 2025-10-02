import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/class_provider.dart';

class SubjectSelectionPage extends ConsumerWidget {
  
  const SubjectSelectionPage({
    super.key,
    required this.classNumber,
  });
  final int classNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(activeSubjectsForClassProvider(classNumber));
    final selectedSubject = ref.watch(selectedSubjectProvider);
    final classEntity = ref.watch(classByNumberProvider(classNumber));

    if (classEntity == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Class Not Found')),
        body: const Center(
          child: Text('Class not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${classEntity.displayName} - Subjects'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a subject to study',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Select the subject you want to learn',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: AppTheme.spacingM,
                  mainAxisSpacing: AppTheme.spacingM,
                ),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  final isSelected = selectedSubject == subject.id;
                  
                  return _buildSubjectCard(
                    context,
                    ref,
                    subject,
                    isSelected,
                  );
                },
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/classes');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacingM,
                      ),
                    ),
                    child: const Text('Go Back'),
                  ),
                ),
                if (selectedSubject != null) ...[
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/chapters/$classNumber/$selectedSubject');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingM,
                        ),
                      ),
                      child: const Text('Start Learning'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context,
    WidgetRef ref,
    subject,
    bool isSelected,
  ) {
    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        side: BorderSide(
          color: isSelected 
            ? Theme.of(context).primaryColor 
            : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          ref.read(selectedSubjectProvider.notifier).state = subject.id;
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : _getSubjectColor(subject.colorHex).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Icon(
                  _getSubjectIcon(subject.iconName),
                  size: 24,
                  color: isSelected 
                    ? Theme.of(context).primaryColor
                    : _getSubjectColor(subject.colorHex),
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                subject.displayName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected 
                    ? Theme.of(context).primaryColor
                    : null,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _getSubjectTypeText(subject.type),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
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

  String _getSubjectTypeText(subjectType) {
    switch (subjectType.toString()) {
      case 'SubjectType.language':
        return 'Language';
      case 'SubjectType.mathematics':
        return 'Mathematics';
      case 'SubjectType.science':
        return 'Science';
      case 'SubjectType.socialStudies':
        return 'Social Studies';
      default:
        return 'Subject';
    }
  }
}
