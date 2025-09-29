import 'package:equatable/equatable.dart';

class QuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final String? imageUrl;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.imageUrl,
  });

  QuizQuestion copyWith({
    String? id,
    String? question,
    List<String>? options,
    int? correctAnswerIndex,
    String? explanation,
    String? imageUrl,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      explanation: explanation ?? this.explanation,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        question,
        options,
        correctAnswerIndex,
        explanation,
        imageUrl,
      ];
}

class QuizEntity extends Equatable {
  final String id;
  final String chapterId;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final Duration timeLimit;
  final int passingScore; // percentage
  final DateTime createdAt;
  final DateTime updatedAt;

  const QuizEntity({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.questions,
    required this.timeLimit,
    required this.passingScore,
    required this.createdAt,
    required this.updatedAt,
  });

  QuizEntity copyWith({
    String? id,
    String? chapterId,
    String? title,
    String? description,
    List<QuizQuestion>? questions,
    Duration? timeLimit,
    int? passingScore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuizEntity(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      timeLimit: timeLimit ?? this.timeLimit,
      passingScore: passingScore ?? this.passingScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get totalQuestions => questions.length;
  int get maxScore => questions.length * 10; // 10 points per question

  String get formattedTimeLimit {
    final minutes = timeLimit.inMinutes;
    if (minutes < 60) return '${minutes} minutes';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return remainingMinutes > 0 ? '${hours}h ${remainingMinutes}m' : '${hours}h';
  }

  @override
  List<Object?> get props => [
        id,
        chapterId,
        title,
        description,
        questions,
        timeLimit,
        passingScore,
        createdAt,
        updatedAt,
      ];
}

