import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/lesson.dart';

// part 'lesson_model.g.dart';

@JsonSerializable()
class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.duration,
    required super.difficulty,
    required super.type,
    super.status,
    super.isCompleted,
    super.progress,
    super.tags,
    super.assetIds,
    super.thumbnailUrl,
    super.localThumbnailPath,
    required super.createdAt,
    required super.updatedAt,
    super.prerequisites,
    super.metadata,
    super.orderIndex,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      duration: json['duration'] as int? ?? 0,
      difficulty: json['difficulty'] as String,
      type: LessonType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LessonType.interactive,
      ),
      status: LessonStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => LessonStatus.published,
      ),
      isCompleted: json['isCompleted'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      assetIds: (json['assetIds'] as List<dynamic>?)?.cast<String>() ?? [],
      thumbnailUrl: json['thumbnailUrl'] as String?,
      localThumbnailPath: json['localThumbnailPath'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
      prerequisites: json['prerequisites'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      orderIndex: json['orderIndex'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'duration': duration,
      'difficulty': difficulty,
      'type': type.name,
      'status': status.name,
      'isCompleted': isCompleted,
      'progress': progress,
      'tags': tags,
      'assetIds': assetIds,
      'thumbnailUrl': thumbnailUrl,
      'localThumbnailPath': localThumbnailPath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'prerequisites': prerequisites,
      'metadata': metadata,
      'orderIndex': orderIndex,
    };
  }

  factory LessonModel.fromEntity(Lesson lesson) {
    return LessonModel(
      id: lesson.id,
      title: lesson.title,
      description: lesson.description,
      category: lesson.category,
      duration: lesson.duration,
      difficulty: lesson.difficulty,
      type: lesson.type,
      status: lesson.status,
      isCompleted: lesson.isCompleted,
      progress: lesson.progress,
      tags: lesson.tags,
      assetIds: lesson.assetIds,
      thumbnailUrl: lesson.thumbnailUrl,
      localThumbnailPath: lesson.localThumbnailPath,
      createdAt: lesson.createdAt,
      updatedAt: lesson.updatedAt,
      prerequisites: lesson.prerequisites,
      metadata: lesson.metadata,
      orderIndex: lesson.orderIndex,
    );
  }

  Lesson toEntity() {
    return Lesson(
      id: id,
      title: title,
      description: description,
      category: category,
      duration: duration,
      difficulty: difficulty,
      type: type,
      status: status,
      isCompleted: isCompleted,
      progress: progress,
      tags: tags,
      assetIds: assetIds,
      thumbnailUrl: thumbnailUrl,
      localThumbnailPath: localThumbnailPath,
      createdAt: createdAt,
      updatedAt: updatedAt,
      prerequisites: prerequisites,
      metadata: metadata,
      orderIndex: orderIndex,
    );
  }
}

// Extension methods for enum serialization
extension LessonStatusExtension on LessonStatus {
  String get value {
    switch (this) {
      case LessonStatus.draft:
        return 'draft';
      case LessonStatus.published:
        return 'published';
      case LessonStatus.archived:
        return 'archived';
    }
  }

  static LessonStatus fromString(String value) {
    switch (value) {
      case 'draft':
        return LessonStatus.draft;
      case 'published':
        return LessonStatus.published;
      case 'archived':
        return LessonStatus.archived;
      default:
        throw ArgumentError('Unknown LessonStatus: $value');
    }
  }
}

extension LessonTypeExtension on LessonType {
  String get value {
    switch (this) {
      case LessonType.interactive:
        return 'interactive';
      case LessonType.video:
        return 'video';
      case LessonType.reading:
        return 'reading';
      case LessonType.exercise:
        return 'exercise';
      case LessonType.assessment:
        return 'assessment';
    }
  }

  static LessonType fromString(String value) {
    switch (value) {
      case 'interactive':
        return LessonType.interactive;
      case 'video':
        return LessonType.video;
      case 'reading':
        return LessonType.reading;
      case 'exercise':
        return LessonType.exercise;
      case 'assessment':
        return LessonType.assessment;
      default:
        throw ArgumentError('Unknown LessonType: $value');
    }
  }
}


