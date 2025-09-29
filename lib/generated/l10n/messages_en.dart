// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'app_localizations.dart';

class messages_en extends messages {
  @override
  String get localeName => 'en';

  static messages_en? _current;

  static messages_en get messages {
    _current ??= messages_en();
    return _current!;
  }

  @override
  String get appTitle => 'Daksh';

  @override
  String get welcomeMessage => 'Welcome to Daksh!';

  @override
  String get startLearning => 'Start Learning';

  @override
  String get grammarCategories => 'Grammar Categories';

  @override
  String get partsOfSpeech => 'Parts of Speech';

  @override
  String get partsOfSpeechDescription => 'Learn about nouns, verbs, adjectives, and more.';

  @override
  String get sentenceStructure => 'Sentence Structure';

  @override
  String get sentenceStructureDescription => 'Master sentence formation and grammar rules.';

  @override
  String get tenses => 'Tenses';

  @override
  String get tensesDescription => 'Understand past, present, and future tenses.';

  @override
  String get punctuation => 'Punctuation';

  @override
  String get punctuationDescription => 'Learn proper punctuation usage.';

  @override
  String get recentLessons => 'Recent Lessons';

  @override
  String get lesson => 'Lesson';

  @override
  String get basicGrammar => 'Basic Grammar';

  @override
  String get completed => 'Completed';

  @override
  String daysAgo(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      zero: 'Today',
      one: '1 day ago',
      other: '$count days ago',
    );
  }

  @override
  String get learn => 'Learn';

  @override
  String get practice => 'Practice';

  @override
  String get assess => 'Assess';

  @override
  String get downloads => 'Downloads';

  @override
  String get settings => 'Settings';

  @override
  String get search => 'Search';

  @override
  String get searchLessons => 'Search lessons';

  @override
  String get practiceProgress => 'Practice Progress';

  @override
  String get exercisesCompleted => 'Exercises Completed';

  @override
  String get streak => 'Streak';

  @override
  String days(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '1 day',
      other: '$count days',
    );
  }

  @override
  String get quickPractice => 'Quick Practice';

  @override
  String get quickPracticeDescription => 'Short exercises for daily practice';

  @override
  String get focusedPractice => 'Focused Practice';

  @override
  String get focusedPracticeDescription => 'Target specific grammar areas';

  @override
  String get challengeMode => 'Challenge Mode';

  @override
  String get challengeModeDescription => 'Test your skills with difficult exercises';

  @override
  String get recentPractice => 'Recent Practice';

  @override
  String get practiceSession => 'Practice Session';

  @override
  String get score => 'Score';

  @override
  String get assessmentCenter => 'Assessment Center';

  @override
  String get testYourKnowledge => 'Test your grammar knowledge and track your progress with comprehensive assessments.';

  @override
  String get currentLevel => 'Current Level';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get basedOnPerformance => 'Based on your recent performance';

  @override
  String get availableAssessments => 'Available Assessments';

  @override
  String get quickAssessment => 'Quick Assessment';

  @override
  String get quickAssessmentDescription => '5-10 minutes • Basic grammar knowledge';

  @override
  String get comprehensiveTest => 'Comprehensive Test';

  @override
  String get comprehensiveTestDescription => '30-45 minutes • Full grammar evaluation';

  @override
  String get skillSpecificTest => 'Skill-Specific Test';

  @override
  String get skillSpecificTestDescription => '15-20 minutes • Focus on specific areas';

  @override
  String get start => 'Start';

  @override
  String get chooseArea => 'Choose Area';

  @override
  String get recentAssessments => 'Recent Assessments';

  @override
  String get storageOverview => 'Storage Overview';

  @override
  String get downloadedLessons => 'Downloaded Lessons';

  @override
  String get storageUsed => 'Storage Used';

  @override
  String get availableForDownload => 'Available for Download';

  @override
  String get completeGrammarCourse => 'Complete Grammar Course';

  @override
  String get allLessonsAndExercises => 'All lessons and exercises';

  @override
  String get practiceExercisesPack => 'Practice Exercises Pack';

  @override
  String get offlinePracticeMaterials => 'Offline practice materials';

  @override
  String get assessmentTests => 'Assessment Tests';

  @override
  String get offlineAssessmentMaterials => 'Offline assessment materials';

  @override
  String get size => 'Size';

  @override
  String get downloaded => 'Downloaded';

  @override
  String get download => 'Download';

  @override
  String get downloadedContent => 'Downloaded Content';

  @override
  String downloadedOn(String date) {
    return 'Downloaded $date';
  }

  @override
  String get play => 'Play';

  @override
  String get delete => 'Delete';

  @override
  String get downloadSettings => 'Download Settings';

  @override
  String get downloadOverWifiOnly => 'Download over Wi-Fi only';

  @override
  String get saveMobileData => 'Save mobile data by downloading only on Wi-Fi';

  @override
  String get autoDownloadNewContent => 'Auto-download new content';

  @override
  String get automaticallyDownloadNewLessons => 'Automatically download new lessons when available';

  @override
  String get profile => 'Profile';

  @override
  String get appSettings => 'App Settings';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light theme';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिंदी';

  @override
  String get telugu => 'తెలుగు';

  @override
  String get audioSettings => 'Audio Settings';

  @override
  String get soundEffectsAndVoice => 'Sound effects and voice';

  @override
  String get notifications => 'Notifications';

  @override
  String get practiceReminders => 'Practice reminders';

  @override
  String get learningPreferences => 'Learning Preferences';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String minutesPerDay(int minutes) {
    return '$minutes minutes per day';
  }

  @override
  String get practiceReminders => 'Practice Reminders';

  @override
  String everyDayAt(String time) {
    return 'Every day at $time';
  }

  @override
  String get difficultyLevel => 'Difficulty Level';

  @override
  String get dataAndPrivacy => 'Data & Privacy';

  @override
  String get downloadData => 'Download Data';

  @override
  String get exportYourProgress => 'Export your learning progress';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get permanentlyDeleteAccount => 'Permanently delete your account';

  @override
  String get supportAndInfo => 'Support & Info';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get getHelpAndContactSupport => 'Get help and contact support';

  @override
  String get about => 'About';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get rateApp => 'Rate App';

  @override
  String get rateUsOnAppStore => 'Rate us on the app store';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String pageNotFoundMessage(String location) {
    return 'Page not found: $location';
  }

  @override
  String get goHome => 'Go Home';

  @override
  String get cancel => 'Cancel';
}

abstract class messages extends AppLocalizations {
  @override
  String get localeName => 'en';
}


