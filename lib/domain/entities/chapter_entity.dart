import 'package:equatable/equatable.dart';

enum ChapterType {
  video,
  reading,
  interactive,
  assessment,
}

class ChapterEntity extends Equatable {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final ChapterType type;
  final String? videoUrl;
  final String? content;
  final int orderIndex;
  final Duration estimatedDuration;
  final String difficulty; // beginner, intermediate, advanced
  final List<String> learningObjectives;
  final bool isCompleted;
  final double progress; // 0.0 to 1.0
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChapterEntity({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.type,
    this.videoUrl,
    this.content,
    required this.orderIndex,
    required this.estimatedDuration,
    required this.difficulty,
    required this.learningObjectives,
    this.isCompleted = false,
    this.progress = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  ChapterEntity copyWith({
    String? id,
    String? subjectId,
    String? title,
    String? description,
    ChapterType? type,
    String? videoUrl,
    String? content,
    int? orderIndex,
    Duration? estimatedDuration,
    String? difficulty,
    List<String>? learningObjectives,
    bool? isCompleted,
    double? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChapterEntity(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      videoUrl: videoUrl ?? this.videoUrl,
      content: content ?? this.content,
      orderIndex: orderIndex ?? this.orderIndex,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      difficulty: difficulty ?? this.difficulty,
      learningObjectives: learningObjectives ?? this.learningObjectives,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasContent => content != null && content!.isNotEmpty;
  bool get isVideoChapter => type == ChapterType.video;
  bool get isAssessmentChapter => type == ChapterType.assessment;

  String get formattedDuration {
    final minutes = estimatedDuration.inMinutes;
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return remainingMinutes > 0 ? '${hours}h ${remainingMinutes}m' : '${hours}h';
  }

  @override
  List<Object?> get props => [
        id,
        subjectId,
        title,
        description,
        type,
        videoUrl,
        content,
        orderIndex,
        estimatedDuration,
        difficulty,
        learningObjectives,
        isCompleted,
        progress,
        createdAt,
        updatedAt,
      ];
}

