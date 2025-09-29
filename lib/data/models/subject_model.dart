import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/subject_entity.dart';

@JsonSerializable()
class SubjectModel extends SubjectEntity {
  const SubjectModel({
    required super.id,
    required super.name,
    required super.displayName,
    required super.description,
    required super.type,
    required super.iconName,
    required super.colorHex,
    super.isActive,
    super.orderIndex,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      type: SubjectType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SubjectType.language,
      ),
      iconName: json['iconName'] as String,
      colorHex: json['colorHex'] as String,
      isActive: json['isActive'] as bool? ?? true,
      orderIndex: json['orderIndex'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'description': description,
      'type': type.name,
      'iconName': iconName,
      'colorHex': colorHex,
      'isActive': isActive,
      'orderIndex': orderIndex,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SubjectModel.fromEntity(SubjectEntity entity) {
    return SubjectModel(
      id: entity.id,
      name: entity.name,
      displayName: entity.displayName,
      description: entity.description,
      type: entity.type,
      iconName: entity.iconName,
      colorHex: entity.colorHex,
      isActive: entity.isActive,
      orderIndex: entity.orderIndex,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

