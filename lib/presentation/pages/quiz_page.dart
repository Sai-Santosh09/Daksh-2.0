import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/chapter_provider.dart';
import 'quiz_result_page.dart';

class QuizPage extends ConsumerStatefulWidget {
  final String chapterId;
  
  const QuizPage({
    super.key,
    required this.chapterId,
  });

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  @override
  void initState() {
    super.initState();
    // Initialize quiz when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quiz = ref.read(quizForChapterProvider(widget.chapterId));
      if (quiz != null) {
        ref.read(quizStateProvider.notifier).startQuiz(quiz.questions.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quiz = ref.watch(quizForChapterProvider(widget.chapterId));
    final quizState = ref.watch(quizStateProvider);

    if (quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Not Found')),
        body: const Center(
          child: Text('Quiz not found for this chapter'),
        ),
      );
    }

    if (quizState.isCompleted) {
      // Navigate to result page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacement('/quiz-result/${widget.chapterId}');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = quiz.questions[quizState.currentQuestionIndex];
    final hasAnswered = quizState.hasAnsweredCurrentQuestion;
    final selectedAnswer = quizState.currentQuestionIndex < quizState.userAnswers.length 
        ? quizState.userAnswers[quizState.currentQuestionIndex] 
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${quizState.currentQuestionIndex + 1}/${quiz.questions.length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: quizState.progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${quizState.currentQuestionIndex + 1}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          Text(
                            currentQuestion.question,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Options
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedAnswer == index;
                        final isCorrect = index == currentQuestion.correctAnswerIndex;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
                          child: InkWell(
                            onTap: () {
                              ref.read(quizStateProvider.notifier).answerQuestion(
                                quizState.currentQuestionIndex,
                                index,
                              );
                            },
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            child: Container(
                              padding: const EdgeInsets.all(AppTheme.spacingM),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                                border: Border.all(
                                  color: isSelected 
                                    ? Theme.of(context).primaryColor 
                                    : Colors.transparent,
                                  width: 2,
                                ),
                                color: isSelected 
                                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                                  : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected 
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      color: isSelected 
                                        ? Theme.of(context).primaryColor
                                        : null,
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: AppTheme.spacingM),
                                  Expanded(
                                    child: Text(
                                      currentQuestion.options[index],
                                      style: TextStyle(
                                        fontWeight: isSelected 
                                          ? FontWeight.w600 
                                          : FontWeight.normal,
                                        color: isSelected 
                                          ? Theme.of(context).primaryColor
                                          : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Navigation Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: quizState.currentQuestionIndex > 0
                              ? () => ref.read(quizStateProvider.notifier).previousQuestion()
                              : null,
                          child: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: hasAnswered
                              ? () {
                                  if (quizState.currentQuestionIndex < quiz.questions.length - 1) {
                                    ref.read(quizStateProvider.notifier).nextQuestion();
                                  } else {
                                    // Complete quiz
                                    ref.read(quizStateProvider.notifier).completeQuiz(quiz.questions);
                                  }
                                }
                              : null,
                          child: Text(
                            quizState.currentQuestionIndex < quiz.questions.length - 1
                                ? 'Next'
                                : 'Finish Quiz',
                          ),
                        ),
                      ),
                    ],
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

