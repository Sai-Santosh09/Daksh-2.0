import '../../domain/entities/chapter_entity.dart';
import '../../domain/entities/quiz_entity.dart';

class ChapterService {
  static final Map<String, List<ChapterEntity>> _chaptersBySubject = _generateChapters();
  static final Map<String, QuizEntity> _quizzesByChapter = _generateQuizzes();

  static Map<String, List<ChapterEntity>> _generateChapters() {
    final now = DateTime.now();
    final chapters = <String, List<ChapterEntity>>{};

    // Generate chapters for each subject
    final subjects = ['english', 'gujarati', 'hindi', 'math', 'science', 'social_studies'];
    
    for (final subject in subjects) {
      chapters[subject] = _generateChaptersForSubject(subject, now);
    }

    return chapters;
  }

  static List<ChapterEntity> _generateChaptersForSubject(String subject, DateTime now) {
    switch (subject) {
      case 'english':
        return [
          ChapterEntity(
            id: 'english_1',
            subjectId: 'english',
            title: 'Reading Comprehension',
            description: 'Learn to understand and analyze written texts',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/english_1.mp4',
            orderIndex: 1,
            estimatedDuration: const Duration(minutes: 15),
            difficulty: 'beginner',
            learningObjectives: [
              'Identify main ideas in texts',
              'Understand context clues',
              'Answer comprehension questions',
            ],
            createdAt: now,
            updatedAt: now,
          ),
          ChapterEntity(
            id: 'english_2',
            subjectId: 'english',
            title: 'Creative Writing',
            description: 'Express ideas through creative writing techniques',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/english_2.mp4',
            orderIndex: 2,
            estimatedDuration: const Duration(minutes: 20),
            difficulty: 'beginner',
            learningObjectives: [
              'Write descriptive paragraphs',
              'Use vivid vocabulary',
              'Structure stories effectively',
            ],
            createdAt: now,
            updatedAt: now,
          ),
          ChapterEntity(
            id: 'english_3',
            subjectId: 'english',
            title: 'Grammar Fundamentals',
            description: 'Essential grammar rules and proper usage',
            type: ChapterType.interactive,
            orderIndex: 3,
            estimatedDuration: const Duration(minutes: 25),
            difficulty: 'intermediate',
            learningObjectives: [
              'Master parts of speech',
              'Apply correct tenses',
              'Use punctuation properly',
            ],
            createdAt: now,
            updatedAt: now,
          ),
        ];

      case 'math':
        return [
          ChapterEntity(
            id: 'math_1',
            subjectId: 'math',
            title: 'Basic Addition and Subtraction',
            description: 'Learn fundamental arithmetic operations',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/math_1.mp4',
            orderIndex: 1,
            estimatedDuration: const Duration(minutes: 18),
            difficulty: 'beginner',
            learningObjectives: [
              'Perform basic addition',
              'Perform basic subtraction',
              'Solve word problems',
            ],
            createdAt: now,
            updatedAt: now,
          ),
          ChapterEntity(
            id: 'math_2',
            subjectId: 'math',
            title: 'Multiplication Tables',
            description: 'Master multiplication from 1 to 10',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/math_2.mp4',
            orderIndex: 2,
            estimatedDuration: const Duration(minutes: 22),
            difficulty: 'beginner',
            learningObjectives: [
              'Memorize multiplication tables',
              'Apply multiplication in problems',
              'Improve calculation speed',
            ],
            createdAt: now,
            updatedAt: now,
          ),
          ChapterEntity(
            id: 'math_3',
            subjectId: 'math',
            title: 'Word Problems',
            description: 'Solve real-world math problems',
            type: ChapterType.interactive,
            orderIndex: 3,
            estimatedDuration: const Duration(minutes: 30),
            difficulty: 'intermediate',
            learningObjectives: [
              'Read and understand word problems',
              'Apply appropriate operations',
              'Check answers for accuracy',
            ],
            createdAt: now,
            updatedAt: now,
          ),
        ];

      case 'gujarati':
        return [
          ChapterEntity(
            id: 'gujarati_1',
            subjectId: 'gujarati',
            title: 'ગુજરાતી વ્યાકરણ',
            description: 'ગુજરાતી ભાષાના મૂળભૂત નિયમો અને વ્યાકરણ',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/gujarati_1.mp4',
            orderIndex: 1,
            estimatedDuration: const Duration(minutes: 16),
            difficulty: 'beginner',
            learningObjectives: [
              'ગુજરાતી વર્ણમાળા શીખો',
              'વ્યાકરણના મૂળભૂત નિયમો',
              'વાક્ય રચના અને શબ્દો',
            ],
            createdAt: now,
            updatedAt: now,
          ),
          ChapterEntity(
            id: 'gujarati_2',
            subjectId: 'gujarati',
            title: 'કવિતા અને સાહિત્ય',
            description: 'ગુજરાતી કવિતા અને સાહિત્યનો પરિચય',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/gujarati_2.mp4',
            orderIndex: 2,
            estimatedDuration: const Duration(minutes: 18),
            difficulty: 'intermediate',
            learningObjectives: [
              'કવિતાના પ્રકારો શીખો',
              'સાહિત્યિક શૈલી સમજો',
              'અલંકારો અને છંદો',
            ],
            createdAt: now,
            updatedAt: now,
          ),
        ];

      case 'hindi':
        return [
          ChapterEntity(
            id: 'hindi_1',
            subjectId: 'hindi',
            title: 'हिंदी व्याकरण',
            description: 'हिंदी भाषा के मूलभूत नियम और संरचना',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/hindi_1.mp4',
            orderIndex: 1,
            estimatedDuration: const Duration(minutes: 17),
            difficulty: 'beginner',
            learningObjectives: [
              'हिंदी वर्णमाला सीखें',
              'व्याकरण के नियम समझें',
              'वाक्य रचना सीखें',
            ],
            createdAt: now,
            updatedAt: now,
          ),
          ChapterEntity(
            id: 'hindi_2',
            subjectId: 'hindi',
            title: 'कहानी और कविता',
            description: 'हिंदी साहित्य की कहानियाँ और कविताएँ',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/hindi_2.mp4',
            orderIndex: 2,
            estimatedDuration: const Duration(minutes: 19),
            difficulty: 'intermediate',
            learningObjectives: [
              'कहानी की समझ विकसित करें',
              'कविता का अर्थ समझें',
              'साहित्यिक शैली सीखें',
            ],
            createdAt: now,
            updatedAt: now,
          ),
        ];

      case 'science':
        return [
          ChapterEntity(
            id: 'science_1',
            subjectId: 'science',
            title: 'Introduction to Plants',
            description: 'Learn about different types of plants and their parts',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/science_1.mp4',
            orderIndex: 1,
            estimatedDuration: const Duration(minutes: 20),
            difficulty: 'beginner',
            learningObjectives: [
              'Identify different plant parts',
              'Understand plant functions',
              'Classify plant types',
            ],
            createdAt: now,
            updatedAt: now,
          ),
          ChapterEntity(
            id: 'science_2',
            subjectId: 'science',
            title: 'Water Cycle',
            description: 'Understand how water moves through the environment',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/science_2.mp4',
            orderIndex: 2,
            estimatedDuration: const Duration(minutes: 25),
            difficulty: 'intermediate',
            learningObjectives: [
              'Understand the water cycle process',
              'Identify different stages',
              'Explain environmental importance',
            ],
            createdAt: now,
            updatedAt: now,
          ),
        ];

      case 'social_studies':
        return [
          ChapterEntity(
            id: 'social_1',
            subjectId: 'social_studies',
            title: 'Our Country - India',
            description: 'Learn about India\'s geography, culture, and history',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/social_1.mp4',
            orderIndex: 1,
            estimatedDuration: const Duration(minutes: 18),
            difficulty: 'beginner',
            learningObjectives: [
              'Identify Indian states and capitals',
              'Learn about Indian culture and traditions',
              'Understand Indian history basics',
            ],
            createdAt: now,
            updatedAt: now,
          ),
          ChapterEntity(
            id: 'social_2',
            subjectId: 'social_studies',
            title: 'Government and Democracy',
            description: 'Understanding how our government works',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/social_2.mp4',
            orderIndex: 2,
            estimatedDuration: const Duration(minutes: 15),
            difficulty: 'intermediate',
            learningObjectives: [
              'Learn about democracy and voting',
              'Understand government structure',
              'Know your rights and responsibilities',
            ],
            createdAt: now,
            updatedAt: now,
          ),
          ChapterEntity(
            id: 'social_3',
            subjectId: 'social_studies',
            title: 'Environmental Conservation',
            description: 'Protecting our planet and natural resources',
            type: ChapterType.interactive,
            orderIndex: 3,
            estimatedDuration: const Duration(minutes: 17),
            difficulty: 'intermediate',
            learningObjectives: [
              'Understand environmental issues',
              'Learn conservation methods',
              'Practice eco-friendly habits',
            ],
            createdAt: now,
            updatedAt: now,
          ),
        ];

      default:
        return [
          ChapterEntity(
            id: '${subject}_1',
            subjectId: subject,
            title: 'Introduction to ${subject.replaceAll('_', ' ').toUpperCase()}',
            description: 'Get started with ${subject.replaceAll('_', ' ')}',
            type: ChapterType.video,
            videoUrl: 'https://example.com/videos/${subject}_1.mp4',
            orderIndex: 1,
            estimatedDuration: const Duration(minutes: 15),
            difficulty: 'beginner',
            learningObjectives: [
              'Understand basic concepts',
              'Learn fundamental principles',
              'Apply knowledge practically',
            ],
            createdAt: now,
            updatedAt: now,
          ),
        ];
    }
  }

  static Map<String, QuizEntity> _generateQuizzes() {
    final now = DateTime.now();
    final quizzes = <String, QuizEntity>{};

    // Generate quiz for each chapter
    for (final subjectChapters in _chaptersBySubject.values) {
      for (final chapter in subjectChapters) {
        quizzes[chapter.id] = _generateQuizForChapter(chapter, now);
      }
    }

    return quizzes;
  }

  static QuizEntity _generateQuizForChapter(ChapterEntity chapter, DateTime now) {
    return QuizEntity(
      id: 'quiz_${chapter.id}',
      chapterId: chapter.id,
      title: '${chapter.title} - Quiz',
      description: 'Test your knowledge of ${chapter.title.toLowerCase()}',
      questions: _generateQuestionsForChapter(chapter),
      timeLimit: const Duration(minutes: 10),
      passingScore: 70,
      createdAt: now,
      updatedAt: now,
    );
  }

  static List<QuizQuestion> _generateQuestionsForChapter(ChapterEntity chapter) {
    switch (chapter.id) {
      case 'english_1':
        return [
          QuizQuestion(
            id: 'q1',
            question: 'What is a noun?',
            options: [
              'A word that describes an action',
              'A word that names a person, place, or thing',
              'A word that describes a noun',
              'A word that connects words',
            ],
            correctAnswerIndex: 1,
            explanation: 'A noun is a word that names a person, place, thing, or idea.',
          ),
          QuizQuestion(
            id: 'q2',
            question: 'Which of the following is a verb?',
            options: ['Cat', 'Run', 'Beautiful', 'Quickly'],
            correctAnswerIndex: 1,
            explanation: 'A verb is a word that describes an action or state of being.',
          ),
        ];

      case 'math_1':
        return [
          QuizQuestion(
            id: 'q1',
            question: 'What is 5 + 3?',
            options: ['7', '8', '9', '6'],
            correctAnswerIndex: 1,
            explanation: '5 + 3 = 8',
          ),
          QuizQuestion(
            id: 'q2',
            question: 'What is 10 - 4?',
            options: ['5', '6', '7', '8'],
            correctAnswerIndex: 1,
            explanation: '10 - 4 = 6',
          ),
        ];

      default:
        return [
          QuizQuestion(
            id: 'q1',
            question: 'What did you learn in this chapter?',
            options: [
              'Basic concepts',
              'Advanced topics',
              'Nothing',
              'Everything',
            ],
            correctAnswerIndex: 0,
            explanation: 'This chapter covered basic concepts of the topic.',
          ),
        ];
    }
  }

  // Getters
  static List<ChapterEntity> getChaptersForSubject(String subjectId) {
    return _chaptersBySubject[subjectId] ?? [];
  }

  static ChapterEntity? getChapterById(String chapterId) {
    for (final chapters in _chaptersBySubject.values) {
      try {
        return chapters.firstWhere((c) => c.id == chapterId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  static QuizEntity? getQuizForChapter(String chapterId) {
    return _quizzesByChapter[chapterId];
  }

  static List<ChapterEntity> getAllChapters() {
    final allChapters = <ChapterEntity>[];
    for (final chapters in _chaptersBySubject.values) {
      allChapters.addAll(chapters);
    }
    return allChapters;
  }
}
