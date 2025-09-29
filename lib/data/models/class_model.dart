import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/class_entity.dart';
import 'subject_model.dart';

@JsonSerializable()
class ClassModel extends ClassEntity {
  const ClassModel({
    required super.classNumber,
    required super.name,
    required super.description,
    required super.subjects,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      classNumber: json['classNumber'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((e) => SubjectModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classNumber': classNumber,
      'name': name,
      'description': description,
      'subjects': subjects.map((e) => (e as SubjectModel).toJson()).toList(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ClassModel.fromEntity(ClassEntity entity) {
    return ClassModel(
      classNumber: entity.classNumber,
      name: entity.name,
      description: entity.description,
      subjects: entity.subjects.map((e) => SubjectModel.fromEntity(e)).toList(),
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

