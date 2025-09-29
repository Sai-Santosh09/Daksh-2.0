import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/entities/subject_entity.dart';
import '../../data/services/class_subject_service.dart';

// Provider for all classes
final classesProvider = Provider<List<ClassEntity>>((ref) {
  return ClassSubjectService.getAllClasses();
});

// Provider for active classes only
final activeClassesProvider = Provider<List<ClassEntity>>((ref) {
  return ClassSubjectService.getActiveClasses();
});

// Provider for a specific class by number
final classByNumberProvider = Provider.family<ClassEntity?, int>((ref, classNumber) {
  return ClassSubjectService.getClassByNumber(classNumber);
});

// Provider for subjects of a specific class
final subjectsForClassProvider = Provider.family<List<SubjectEntity>, int>((ref, classNumber) {
  return ClassSubjectService.getSubjectsForClass(classNumber);
});

// Provider for active subjects of a specific class
final activeSubjectsForClassProvider = Provider.family<List<SubjectEntity>, int>((ref, classNumber) {
  return ClassSubjectService.getActiveSubjectsForClass(classNumber);
});

// Provider for a specific subject by ID
final subjectByIdProvider = Provider.family<SubjectEntity?, String>((ref, subjectId) {
  return ClassSubjectService.getSubjectById(subjectId);
});

// Provider for classes that have a specific subject
final classesBySubjectProvider = Provider.family<List<ClassEntity>, String>((ref, subjectName) {
  return ClassSubjectService.getClassesBySubject(subjectName);
});

// Provider for selected class (for state management)
final selectedClassProvider = StateProvider<int?>((ref) => null);

// Provider for selected subject (for state management)
final selectedSubjectProvider = StateProvider<String?>((ref) => null);

