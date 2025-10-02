import '../../domain/entities/lesson.dart';
import '../../domain/entities/asset.dart';
import '../../domain/entities/chapter_entity.dart';

class DemoDataService {
  static List<Lesson> getDemoLessons() {
    return [
      Lesson(
        id: '1',
        title: 'English Grammar Basics',
        description: 'Learn the fundamental concepts of English grammar including nouns, verbs, and adjectives.',
        category: 'Grammar',
        duration: 30,
        difficulty: 'beginner',
        type: LessonType.interactive,
        tags: ['grammar', 'basics', 'english', 'beginner'],
        assetIds: ['asset_1', 'asset_2'],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        progress: 0.3,
      ),
      Lesson(
        id: '2',
        title: 'Advanced Vocabulary Building',
        description: 'Expand your vocabulary with advanced words and their usage in different contexts.',
        category: 'Vocabulary',
        duration: 45,
        difficulty: 'advanced',
        type: LessonType.video,
        tags: ['vocabulary', 'advanced', 'words', 'context'],
        assetIds: ['asset_3'],
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        progress: 0.7,
      ),
      Lesson(
        id: '3',
        title: 'Pronunciation Guide',
        description: 'Master proper pronunciation with audio examples and phonetic guides.',
        category: 'Pronunciation',
        duration: 25,
        difficulty: 'intermediate',
        type: LessonType.video,
        tags: ['pronunciation', 'audio', 'phonetics', 'speaking'],
        assetIds: ['asset_4', 'asset_5'],
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        isCompleted: true,
        progress: 1.0,
      ),
      Lesson(
        id: '4',
        title: 'Writing Skills Practice',
        description: 'Improve your writing skills with structured exercises and examples.',
        category: 'Writing',
        duration: 40,
        difficulty: 'intermediate',
        type: LessonType.exercise,
        tags: ['writing', 'practice', 'exercises', 'skills'],
        assetIds: ['asset_6'],
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        progress: 0.5,
      ),
      Lesson(
        id: '5',
        title: 'Reading Comprehension',
        description: 'Develop reading comprehension skills through various texts and exercises.',
        category: 'Reading',
        duration: 35,
        difficulty: 'beginner',
        type: LessonType.reading,
        tags: ['reading', 'comprehension', 'texts', 'understanding'],
        assetIds: ['asset_7', 'asset_8'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now(),
        progress: 0.2,
      ),
    ];
  }

  static List<Asset> getDemoAssets() {
    return [
      Asset(
        id: 'asset_1',
        lessonId: '1',
        name: 'Grammar Basics Video',
        description: 'Introduction video covering basic grammar concepts',
        type: AssetType.video,
        url: 'https://example.com/grammar-basics.mp4',
        sizeBytes: 15728640, // 15MB
        mimeType: 'video/mp4',
        metadata: {'duration': 600}, // 10 minutes
      ),
      Asset(
        id: 'asset_2',
        lessonId: '1',
        name: 'Grammar Exercise Worksheet',
        description: 'Printable worksheet with grammar exercises',
        type: AssetType.document,
        url: 'https://example.com/grammar-worksheet.pdf',
        sizeBytes: 2097152, // 2MB
        mimeType: 'application/pdf',
      ),
      Asset(
        id: 'asset_3',
        lessonId: '2',
        name: 'Vocabulary Audio Guide',
        description: 'Audio pronunciation guide for advanced vocabulary',
        type: AssetType.audio,
        url: 'https://example.com/vocab-audio.mp3',
        sizeBytes: 5242880, // 5MB
        mimeType: 'audio/mpeg',
        metadata: {'duration': 1200}, // 20 minutes
      ),
      Asset(
        id: 'asset_4',
        lessonId: '3',
        name: 'Pronunciation Video Tutorial',
        description: 'Step-by-step pronunciation tutorial',
        type: AssetType.video,
        url: 'https://example.com/pronunciation.mp4',
        sizeBytes: 20971520, // 20MB
        mimeType: 'video/mp4',
        metadata: {'duration': 900}, // 15 minutes
      ),
      Asset(
        id: 'asset_5',
        lessonId: '3',
        name: 'Phonetic Chart',
        description: 'Interactive phonetic chart reference',
        type: AssetType.interactive,
        url: 'https://example.com/phonetic-chart.html',
        sizeBytes: 1048576, // 1MB
        mimeType: 'text/html',
      ),
    ];
  }

  static List<ChapterEntity> getDemoChapters() {
    return [
      ChapterEntity(
        id: 'chapter_1',
        subjectId: 'english',
        title: 'Introduction to Grammar',
        description: 'Basic concepts and terminology in English grammar',
        type: ChapterType.video,
        videoUrl: 'https://example.com/intro-grammar.mp4',
        orderIndex: 1,
        estimatedDuration: const Duration(minutes: 20),
        difficulty: 'beginner',
        learningObjectives: [
          'Understand basic grammar terminology',
          'Identify parts of speech',
          'Apply basic grammar rules',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      ChapterEntity(
        id: 'chapter_2',
        subjectId: 'english',
        title: 'Sentence Structure',
        description: 'Learn how to construct proper sentences in English',
        type: ChapterType.interactive,
        orderIndex: 2,
        estimatedDuration: const Duration(minutes: 25),
        difficulty: 'intermediate',
        learningObjectives: [
          'Understand sentence components',
          'Build complex sentences',
          'Use proper punctuation',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        updatedAt: DateTime.now().subtract(const Duration(days: 6)),
        progress: 0.6,
      ),
      ChapterEntity(
        id: 'chapter_3',
        subjectId: 'mathematics',
        title: 'Basic Arithmetic',
        description: 'Fundamental arithmetic operations and concepts',
        type: ChapterType.reading,
        orderIndex: 1,
        estimatedDuration: const Duration(minutes: 30),
        difficulty: 'beginner',
        learningObjectives: [
          'Perform basic calculations',
          'Understand number properties',
          'Solve simple word problems',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        isCompleted: true,
        progress: 1.0,
      ),
    ];
  }
}
