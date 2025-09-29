import '../entities/lesson.dart';
import '../repositories/lesson_repository.dart';

class GetLessonsUseCase {
  final LessonRepository _repository;

  GetLessonsUseCase({required LessonRepository repository})
      : _repository = repository;

  Future<List<Lesson>> call({
    String? category,
    String? difficulty,
    bool includeAssets = false,
  }) async {
    try {
      if (category != null && difficulty != null) {
        // Get lessons filtered by both category and difficulty
        final categoryLessons = await _repository.getLessonsByCategory(category);
        return categoryLessons.where((lesson) => lesson.difficulty == difficulty).toList();
      } else if (category != null) {
        return await _repository.getLessonsByCategory(category);
      } else if (difficulty != null) {
        return await _repository.getLessonsByDifficulty(difficulty);
      } else {
        return await _repository.getAllLessons();
      }
    } catch (e) {
      throw Exception('Failed to get lessons: $e');
    }
  }
}

class GetLessonByIdUseCase {
  final LessonRepository _repository;

  GetLessonByIdUseCase({required LessonRepository repository})
      : _repository = repository;

  Future<Lesson?> call(String lessonId) async {
    try {
      return await _repository.getLessonById(lessonId);
    } catch (e) {
      throw Exception('Failed to get lesson by id: $e');
    }
  }
}

class MarkLessonCompletedUseCase {
  final LessonRepository _repository;

  MarkLessonCompletedUseCase({required LessonRepository repository})
      : _repository = repository;

  Future<void> call(String lessonId) async {
    try {
      await _repository.markLessonAsCompleted(lessonId);
    } catch (e) {
      throw Exception('Failed to mark lesson as completed: $e');
    }
  }
}

class UpdateLessonProgressUseCase {
  final LessonRepository _repository;

  UpdateLessonProgressUseCase({required LessonRepository repository})
      : _repository = repository;

  Future<void> call(String lessonId, double progress) async {
    try {
      if (progress < 0.0 || progress > 1.0) {
        throw ArgumentError('Progress must be between 0.0 and 1.0');
      }
      await _repository.updateLessonProgress(lessonId, progress);
    } catch (e) {
      throw Exception('Failed to update lesson progress: $e');
    }
  }
}

class GetCompletedLessonsUseCase {
  final LessonRepository _repository;

  GetCompletedLessonsUseCase({required LessonRepository repository})
      : _repository = repository;

  Future<List<Lesson>> call() async {
    try {
      return await _repository.getCompletedLessons();
    } catch (e) {
      throw Exception('Failed to get completed lessons: $e');
    }
  }
}

class GetInProgressLessonsUseCase {
  final LessonRepository _repository;

  GetInProgressLessonsUseCase({required LessonRepository repository})
      : _repository = repository;

  Future<List<Lesson>> call() async {
    try {
      return await _repository.getInProgressLessons();
    } catch (e) {
      throw Exception('Failed to get in-progress lessons: $e');
    }
  }
}


