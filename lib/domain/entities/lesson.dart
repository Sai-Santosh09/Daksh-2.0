import 'package:equatable/equatable.dart';
import 'asset.dart';

enum LessonStatus {
  draft,
  published,
  archived,
}

enum LessonType {
  interactive,
  video,
  reading,
  exercise,
  assessment,
}

class Lesson extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final int duration; // in minutes
  final String difficulty; // beginner, intermediate, advanced
  final LessonType type;
  final LessonStatus status;
  final bool isCompleted;
  final double progress; // 0.0 to 1.0
  final List<String> tags;
  final List<String> assetIds;
  final String? thumbnailUrl;
  final String? localThumbnailPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? prerequisites;
  final Map<String, dynamic> metadata;
  final int orderIndex;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.type,
    this.status = LessonStatus.published,
    this.isCompleted = false,
    this.progress = 0.0,
    this.tags = const [],
    this.assetIds = const [],
    this.thumbnailUrl,
    this.localThumbnailPath,
    required this.createdAt,
    required this.updatedAt,
    this.prerequisites,
    this.metadata = const {},
    this.orderIndex = 0,
  });

  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? duration,
    String? difficulty,
    LessonType? type,
    LessonStatus? status,
    bool? isCompleted,
    double? progress,
    List<String>? tags,
    List<String>? assetIds,
    String? thumbnailUrl,
    String? localThumbnailPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? prerequisites,
    Map<String, dynamic>? metadata,
    int? orderIndex,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
      status: status ?? this.status,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      tags: tags ?? this.tags,
      assetIds: assetIds ?? this.assetIds,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      localThumbnailPath: localThumbnailPath ?? this.localThumbnailPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      prerequisites: prerequisites ?? this.prerequisites,
      metadata: metadata ?? this.metadata,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  bool get isPublished => status == LessonStatus.published;
  bool get isAvailable => isPublished && !isCompleted;
  bool get hasThumbnail => thumbnailUrl != null || localThumbnailPath != null;
  
  String get formattedDuration {
    if (duration < 60) return '${duration}m';
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        duration,
        difficulty,
        type,
        status,
        isCompleted,
        progress,
        tags,
        assetIds,
        thumbnailUrl,
        localThumbnailPath,
        createdAt,
        updatedAt,
        prerequisites,
        metadata,
        orderIndex,
      ];
}
