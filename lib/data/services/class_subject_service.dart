import '../../domain/entities/class_entity.dart';
import '../../domain/entities/subject_entity.dart';
import '../models/class_model.dart';
import '../models/subject_model.dart';

class ClassSubjectService {
  static final List<ClassEntity> _classes = _generateClasses();

  static List<ClassEntity> _generateClasses() {
    final now = DateTime.now();
    final classes = <ClassEntity>[];

    for (int classNum = 1; classNum <= 10; classNum++) {
      final subjects = _generateSubjectsForClass(classNum, now);
      classes.add(ClassEntity(
        classNumber: classNum,
        name: 'Class $classNum',
        description: 'Educational content for Class $classNum students',
        subjects: subjects,
        createdAt: now,
        updatedAt: now,
      ));
    }

    return classes;
  }

  static List<SubjectEntity> _generateSubjectsForClass(int classNumber, DateTime now) {
    return [
      // English
      SubjectEntity(
        id: 'english_c$classNumber',
        name: 'english',
        displayName: 'English',
        description: 'English language and literature for Class $classNumber',
        type: SubjectType.language,
        iconName: 'language',
        colorHex: '#2196F3', // Blue
        orderIndex: 1,
        createdAt: now,
        updatedAt: now,
      ),
      
      // Gujarati
      SubjectEntity(
        id: 'gujarati_c$classNumber',
        name: 'gujarati',
        displayName: 'ગુજરાતી',
        description: 'Gujarati language and literature for Class $classNumber',
        type: SubjectType.language,
        iconName: 'translate',
        colorHex: '#4CAF50', // Green
        orderIndex: 2,
        createdAt: now,
        updatedAt: now,
      ),
      
      // Hindi
      SubjectEntity(
        id: 'hindi_c$classNumber',
        name: 'hindi',
        displayName: 'हिंदी',
        description: 'Hindi language and literature for Class $classNumber',
        type: SubjectType.language,
        iconName: 'translate',
        colorHex: '#FF9800', // Orange
        orderIndex: 3,
        createdAt: now,
        updatedAt: now,
      ),
      
      // Mathematics
      SubjectEntity(
        id: 'math_c$classNumber',
        name: 'mathematics',
        displayName: 'Mathematics',
        description: 'Mathematics for Class $classNumber',
        type: SubjectType.mathematics,
        iconName: 'calculate',
        colorHex: '#9C27B0', // Purple
        orderIndex: 4,
        createdAt: now,
        updatedAt: now,
      ),
      
      // Science
      SubjectEntity(
        id: 'science_c$classNumber',
        name: 'science',
        displayName: 'Science',
        description: 'Science (Physics, Chemistry, Biology) for Class $classNumber',
        type: SubjectType.science,
        iconName: 'science',
        colorHex: '#F44336', // Red
        orderIndex: 5,
        createdAt: now,
        updatedAt: now,
      ),
      
      // Social Studies
      SubjectEntity(
        id: 'social_c$classNumber',
        name: 'social_studies',
        displayName: 'Social Studies',
        description: 'Social Studies (History, Geography, Civics) for Class $classNumber',
        type: SubjectType.socialStudies,
        iconName: 'public',
        colorHex: '#795548', // Brown
        orderIndex: 6,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  // Get all classes
  static List<ClassEntity> getAllClasses() {
    return List.unmodifiable(_classes);
  }

  // Get class by number
  static ClassEntity? getClassByNumber(int classNumber) {
    try {
      return _classes.firstWhere((c) => c.classNumber == classNumber);
    } catch (e) {
      return null;
    }
  }

  // Get subjects for a specific class
  static List<SubjectEntity> getSubjectsForClass(int classNumber) {
    final classEntity = getClassByNumber(classNumber);
    return classEntity?.subjects ?? [];
  }

  // Get subject by ID
  static SubjectEntity? getSubjectById(String subjectId) {
    for (final classEntity in _classes) {
      try {
        return classEntity.subjects.firstWhere((s) => s.id == subjectId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  // Get classes by subject name
  static List<ClassEntity> getClassesBySubject(String subjectName) {
    return _classes.where((c) => 
      c.subjects.any((s) => s.name == subjectName)
    ).toList();
  }

  // Get active classes only
  static List<ClassEntity> getActiveClasses() {
    return _classes.where((c) => c.isActive).toList();
  }

  // Get active subjects for a class
  static List<SubjectEntity> getActiveSubjectsForClass(int classNumber) {
    final subjects = getSubjectsForClass(classNumber);
    return subjects.where((s) => s.isActive).toList();
  }
}

