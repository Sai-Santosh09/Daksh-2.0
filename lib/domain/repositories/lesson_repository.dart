import '../entities/lesson.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getAllLessons();
  Future<List<Lesson>> getLessonsByCategory(String category);
  Future<List<Lesson>> getLessonsByDifficulty(String difficulty);
  Future<Lesson?> getLessonById(String id);
  Future<void> markLessonAsCompleted(String lessonId);
  Future<void> updateLessonProgress(String lessonId, double progress);
  Future<List<Lesson>> getCompletedLessons();
  Future<List<Lesson>> getInProgressLessons();
}


