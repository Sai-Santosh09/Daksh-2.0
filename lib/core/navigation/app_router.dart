import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/learn_page.dart';
import '../../presentation/pages/practice_page.dart';
import '../../presentation/pages/assess_page.dart';
import '../../presentation/pages/downloads_page.dart';
import '../../presentation/pages/settings_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/lesson_detail_page.dart';
import '../../presentation/pages/media_player_page.dart';
import '../../presentation/pages/class_selection_page.dart';
import '../../presentation/pages/subject_selection_page.dart';
import '../../presentation/pages/lesson_list_page.dart';
import '../../presentation/pages/chapters_list_page.dart';
import '../../presentation/pages/chapter_detail_page.dart';
import '../../presentation/pages/quiz_page.dart';
import '../../presentation/pages/quiz_result_page.dart';
import '../../presentation/pages/edit_profile_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/signup_page.dart';
import '../../presentation/pages/profile_setup_page.dart';
import '../../presentation/providers/auth_provider.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      // This will be handled by the splash page
      return null;
    },
    routes: [
      // Splash screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      
      // Authentication routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),
      
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) => const ProfileSetupPage(),
      ),
      
      // Main app with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return HomePage(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const LearnPage(),
          ),
          GoRoute(
            path: AppRoutes.learn,
            builder: (context, state) => const LearnPage(),
          ),
          GoRoute(
            path: AppRoutes.practice,
            builder: (context, state) => const PracticePage(),
          ),
          GoRoute(
            path: AppRoutes.assess,
            builder: (context, state) => const AssessPage(),
          ),
          GoRoute(
            path: AppRoutes.downloads,
            builder: (context, state) => const DownloadsPage(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      
      // Full-screen pages
      GoRoute(
        path: '/lesson/:lessonId',
        builder: (context, state) {
          final lessonId = state.pathParameters['lessonId']!;
          return LessonDetailPage(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/player/:assetId',
        builder: (context, state) {
          final assetId = state.pathParameters['assetId']!;
          // This would need to be updated to get the asset from the ID
          // For now, we'll show a placeholder
          return Scaffold(
            appBar: AppBar(title: const Text('Media Player')),
            body: Center(
              child: Text('Media Player for Asset: $assetId'),
            ),
          );
        },
      ),
      
      // Class selection route
      GoRoute(
        path: '/classes',
        name: 'classes',
        builder: (context, state) {
          return const ClassSelectionPage();
        },
      ),
      
      // Subject selection route
      GoRoute(
        path: '/subjects/:classNumber',
        name: 'subjects',
        builder: (context, state) {
          final classNumber = int.parse(state.pathParameters['classNumber']!);
          return SubjectSelectionPage(classNumber: classNumber);
        },
      ),
      
      // Lesson list route
      GoRoute(
        path: '/lessons/:classNumber/:subjectId',
        name: 'lessons',
        builder: (context, state) {
          final classNumber = int.parse(state.pathParameters['classNumber']!);
          final subjectId = state.pathParameters['subjectId']!;
          return LessonListPage(
            classNumber: classNumber,
            subjectId: subjectId,
          );
        },
      ),
      
      // Chapters list route
      GoRoute(
        path: '/chapters/:classNumber/:subjectId',
        name: 'chapters',
        builder: (context, state) {
          final classNumber = int.parse(state.pathParameters['classNumber']!);
          final subjectId = state.pathParameters['subjectId']!;
          return ChaptersListPage(
            classNumber: classNumber,
            subjectId: subjectId,
          );
        },
      ),
      
      // Chapter detail route
      GoRoute(
        path: '/chapter/:chapterId',
        name: 'chapter',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return ChapterDetailPage(chapterId: chapterId);
        },
      ),
      
      // Quiz route
      GoRoute(
        path: '/quiz/:chapterId',
        name: 'quiz',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return QuizPage(chapterId: chapterId);
        },
      ),
      
      // Quiz result route
      GoRoute(
        path: '/quiz-result/:chapterId',
        name: 'quiz-result',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return QuizResultPage(chapterId: chapterId);
        },
      ),
      
      // Edit profile route
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  static GoRouter get router => _router;
}
