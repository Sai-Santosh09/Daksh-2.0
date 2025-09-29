import 'package:equatable/equatable.dart';
import 'subject_entity.dart';

class ClassEntity extends Equatable {
  final int classNumber;
  final String name;
  final String description;
  final List<SubjectEntity> subjects;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClassEntity({
    required this.classNumber,
    required this.name,
    required this.description,
    required this.subjects,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  ClassEntity copyWith({
    int? classNumber,
    String? name,
    String? description,
    List<SubjectEntity>? subjects,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClassEntity(
      classNumber: classNumber ?? this.classNumber,
      name: name ?? this.name,
      description: description ?? this.description,
      subjects: subjects ?? this.subjects,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayName => 'Class $classNumber';
  String get shortName => 'C$classNumber';
  
  int get totalSubjects => subjects.length;
  int get activeSubjects => subjects.where((s) => s.isActive).length;

  @override
  List<Object?> get props => [
        classNumber,
        name,
        description,
        subjects,
        isActive,
        createdAt,
        updatedAt,
      ];
}

