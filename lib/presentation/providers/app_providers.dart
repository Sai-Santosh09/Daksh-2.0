import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Example providers for the app
// These can be expanded based on your specific needs

// Theme provider with persistence
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'app_theme_mode';
  
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadThemeMode();
  }

  // Load saved theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);
      if (themeIndex != null) {
        state = ThemeMode.values[themeIndex];
      }
    } catch (e) {
      // If loading fails, keep default theme mode (light)
      debugPrint('Failed to load theme mode: $e');
    }
  }

  // Change theme mode and save to SharedPreferences
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, mode.index);
      state = mode;
    } catch (e) {
      debugPrint('Failed to save theme mode: $e');
    }
  }
}

// User preferences provider
final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier();
});

// User preferences state
class UserPreferences {
  final String language;
  final bool notificationsEnabled;
  final int dailyGoalMinutes;
  final String difficultyLevel;

  const UserPreferences({
    this.language = 'en',
    this.notificationsEnabled = true,
    this.dailyGoalMinutes = 30,
    this.difficultyLevel = 'intermediate',
  });

  UserPreferences copyWith({
    String? language,
    bool? notificationsEnabled,
    int? dailyGoalMinutes,
    String? difficultyLevel,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
    );
  }
}

// User preferences notifier
class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  UserPreferencesNotifier() : super(const UserPreferences());

  void updateLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void toggleNotifications() {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
  }

  void updateDailyGoal(int minutes) {
    state = state.copyWith(dailyGoalMinutes: minutes);
  }

  void updateDifficultyLevel(String level) {
    state = state.copyWith(difficultyLevel: level);
  }
}

// Navigation provider for tracking current tab
final currentTabProvider = StateProvider<int>((ref) => 0);

// Loading state provider
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Error message provider
final errorMessageProvider = StateProvider<String?>((ref) => null);
