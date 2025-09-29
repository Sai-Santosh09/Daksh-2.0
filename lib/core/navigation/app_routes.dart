class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profileSetup = '/profile-setup';
  static const String home = '/home';
  static const String learn = '/learn';
  static const String practice = '/practice';
  static const String assess = '/assess';
  static const String downloads = '/downloads';
  static const String settings = '/settings';
  static const String lessonDetail = '/lesson/:id';
  static const String mediaPlayer = '/media/:id';
  static const String classes = '/classes';
  static const String subjects = '/subjects/:classNumber';
  static const String lessons = '/lessons/:classNumber/:subjectId';
  static const String chapters = '/chapters/:classNumber/:subjectId';
  static const String chapter = '/chapter/:chapterId';
  static const String quiz = '/quiz/:chapterId';
  static const String quizResult = '/quiz-result/:chapterId';
  static const String editProfile = '/edit-profile';
}
