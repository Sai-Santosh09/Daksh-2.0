import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chapter_entity.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../data/services/chapter_service.dart';

// Provider for chapters of a specific subject
final chaptersForSubjectProvider = Provider.family<List<ChapterEntity>, String>((ref, subjectId) {
  return ChapterService.getChaptersForSubject(subjectId);
});

// Provider for a specific chapter by ID
final chapterByIdProvider = Provider.family<ChapterEntity?, String>((ref, chapterId) {
  return ChapterService.getChapterById(chapterId);
});

// Provider for quiz of a specific chapter
final quizForChapterProvider = Provider.family<QuizEntity?, String>((ref, chapterId) {
  return ChapterService.getQuizForChapter(chapterId);
});

// Provider for all chapters
final allChaptersProvider = Provider<List<ChapterEntity>>((ref) {
  return ChapterService.getAllChapters();
});

// Provider for selected chapter (for state management)
final selectedChapterProvider = StateProvider<String?>((ref) => null);

// Quiz state management
class QuizState {
  final List<int?> userAnswers;
  final int currentQuestionIndex;
  final bool isCompleted;
  final int score;
  final DateTime? startTime;
  final DateTime? endTime;

  const QuizState({
    this.userAnswers = const [],
    this.currentQuestionIndex = 0,
    this.isCompleted = false,
    this.score = 0,
    this.startTime,
    this.endTime,
  });

  QuizState copyWith({
    List<int?>? userAnswers,
    int? currentQuestionIndex,
    bool? isCompleted,
    int? score,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return QuizState(
      userAnswers: userAnswers ?? this.userAnswers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  bool get hasAnsweredCurrentQuestion => 
    currentQuestionIndex < userAnswers.length && userAnswers[currentQuestionIndex] != null;

  int get totalQuestions => userAnswers.length;
  int get answeredQuestions => userAnswers.where((answer) => answer != null).length;
  double get progress => totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(const QuizState());

  void startQuiz(int totalQuestions) {
    state = state.copyWith(
      userAnswers: List.filled(totalQuestions, null),
      currentQuestionIndex: 0,
      isCompleted: false,
      score: 0,
      startTime: DateTime.now(),
      endTime: null,
    );
  }

  void answerQuestion(int questionIndex, int answerIndex) {
    final newAnswers = List<int?>.from(state.userAnswers);
    newAnswers[questionIndex] = answerIndex;
    
    state = state.copyWith(userAnswers: newAnswers);
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.totalQuestions - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      );
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      );
    }
  }

  void goToQuestion(int questionIndex) {
    if (questionIndex >= 0 && questionIndex < state.totalQuestions) {
      state = state.copyWith(currentQuestionIndex: questionIndex);
    }
  }

  void completeQuiz(List<QuizQuestion> questions) {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (state.userAnswers[i] == questions[i].correctAnswerIndex) {
        score += 10; // 10 points per correct answer
      }
    }

    state = state.copyWith(
      isCompleted: true,
      score: score,
      endTime: DateTime.now(),
    );
  }

  void resetQuiz() {
    state = const QuizState();
  }
}

// Provider for quiz state
final quizStateProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier();
});

