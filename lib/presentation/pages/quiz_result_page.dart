import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/chapter_provider.dart';
import '../../domain/entities/quiz_entity.dart';

class QuizResultPage extends ConsumerWidget {
  const QuizResultPage({
    super.key,
    required this.chapterId,
  });
  
  final String chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quiz = ref.watch(quizForChapterProvider(chapterId));
    final quizState = ref.watch(quizStateProvider);

    if (quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Not Found')),
        body: const Center(
          child: Text('Quiz not found for this chapter'),
        ),
      );
    }

    final score = _calculateScore(quiz.questions, quizState.userAnswers);
    final percentage = (score / quiz.questions.length * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          children: [
            // Score Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingXL),
                child: Column(
                  children: [
                    // Score Circle
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$score',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '/${quiz.questions.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Percentage
                    Text(
                      '$percentage%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingS),
                    
                    // Performance Message
                    Text(
                      _getPerformanceMessage(percentage),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Detailed Results
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question Review',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.spacingM),
                      
                      Expanded(
                        child: ListView.builder(
                          itemCount: quiz.questions.length,
                          itemBuilder: (context, index) {
                            final question = quiz.questions[index];
                            final userAnswer = index < quizState.userAnswers.length 
                                ? quizState.userAnswers[index] 
                                : null;
                            final isCorrect = userAnswer == question.correctAnswerIndex;
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
                              color: isCorrect 
                                  ? Colors.green.shade50 
                                  : Colors.red.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.spacingM),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          isCorrect ? Icons.check_circle : Icons.cancel,
                                          color: isCorrect ? Colors.green : Colors.red,
                                          size: 20,
                                        ),
                                        const SizedBox(width: AppTheme.spacingS),
                                        Expanded(
                                          child: Text(
                                            'Question ${index + 1}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: AppTheme.spacingS),
                                    
                                    Text(
                                      question.question,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    
                                    const SizedBox(height: AppTheme.spacingS),
                                    
                                    if (userAnswer != null) ...[
                                      Text(
                                        'Your answer: ${question.options[userAnswer]}',
                                        style: TextStyle(
                                          color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                    
                                    if (!isCorrect) ...[
                                      Text(
                                        'Correct answer: ${question.options[question.correctAnswerIndex]}',
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Reset quiz state and go back to quiz
                      ref.read(quizStateProvider.notifier).resetQuiz();
                      context.go('/quiz/$chapterId');
                    },
                    child: const Text('Retake Quiz'),
                  ),
                ),
                
                const SizedBox(width: AppTheme.spacingM),
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Reset quiz state and go back to chapter
                      ref.read(quizStateProvider.notifier).resetQuiz();
                      context.go('/chapter/$chapterId');
                    },
                    child: const Text('Back to Chapter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _calculateScore(List<QuizQuestion> questions, List<int?> userAnswers) {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (i < userAnswers.length && userAnswers[i] != null && userAnswers[i] == questions[i].correctAnswerIndex) {
        score++;
      }
    }
    return score;
  }

  String _getPerformanceMessage(int percentage) {
    if (percentage >= 90) {
      return 'Excellent! You have mastered this topic.';
    } else if (percentage >= 80) {
      return 'Great job! You have a good understanding.';
    } else if (percentage >= 70) {
      return 'Good work! Review the incorrect answers.';
    } else if (percentage >= 60) {
      return 'Not bad! Consider reviewing the material.';
    } else {
      return 'Keep studying! You can do better next time.';
    }
  }
}
