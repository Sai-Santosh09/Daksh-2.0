import 'package:equatable/equatable.dart';

enum SubjectType {
  language,
  mathematics,
  science,
  socialStudies,
  arts,
  physicalEducation,
  computerScience,
}

class SubjectEntity extends Equatable {
  final String id;
  final String name;
  final String displayName;
  final String description;
  final SubjectType type;
  final String iconName;
  final String colorHex;
  final bool isActive;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubjectEntity({
    required this.id,
    required this.name,
    required this.displayName,
    required this.description,
    required this.type,
    required this.iconName,
    required this.colorHex,
    this.isActive = true,
    this.orderIndex = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  SubjectEntity copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    SubjectType? type,
    String? iconName,
    String? colorHex,
    bool? isActive,
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubjectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      type: type ?? this.type,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      isActive: isActive ?? this.isActive,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        displayName,
        description,
        type,
        iconName,
        colorHex,
        isActive,
        orderIndex,
        createdAt,
        updatedAt,
      ];
}

