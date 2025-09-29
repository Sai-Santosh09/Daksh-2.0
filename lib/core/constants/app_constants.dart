import 'package:flutter/material.dart';

class AppConstants {
  // App information
  static const String appName = 'Daksh - Education is for everyone';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Comprehensive education platform for all subjects with interactive lessons and practice exercises';
  
  // Tab labels
  static const String learnTab = 'Learn';
  static const String practiceTab = 'Practice';
  static const String assessTab = 'Assess';
  static const String downloadsTab = 'Downloads';
  static const String settingsTab = 'Settings';
  
  // Tab icons (Material Icons)
  static const IconData learnIcon = Icons.school;
  static const IconData practiceIcon = Icons.fitness_center;
  static const IconData assessIcon = Icons.quiz;
  static const IconData downloadsIcon = Icons.download;
  static const IconData settingsIcon = Icons.settings;
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // API constants (if needed later)
  static const String baseUrl = 'https://api.gramlearn.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Storage keys
  static const String userPreferencesKey = 'user_preferences';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
}
