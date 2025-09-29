import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  // Notification Settings
  final bool notificationsEnabled;
  final bool lessonReminders;
  final bool quizReminders;
  final bool achievementNotifications;
  final bool dailyProgressNotifications;
  final String reminderTime; // Format: "HH:mm"

  // Learning Preferences
  final String preferredLanguage;
  final String difficultyLevel; // beginner, intermediate, advanced
  final bool autoPlayVideos;
  final bool showSubtitles;
  final String playbackSpeed; // 0.5x, 0.75x, 1x, 1.25x, 1.5x, 2x
  final bool darkModeEnabled;
  final bool offlineModeEnabled;

  // App Preferences
  final bool autoDownloadNewContent;
  final bool downloadOverWifiOnly;
  final bool dataSaverMode;
  final bool hapticFeedbackEnabled;
  final bool soundEffectsEnabled;
  final bool analyticsEnabled;

  // Privacy & Security
  final bool profileVisibility; // true = public, false = private
  final bool shareProgressWithFriends;
  final bool allowDataCollection;
  final bool biometricLoginEnabled;

  // Study Settings
  final int studySessionDuration; // in minutes
  final int breakDuration; // in minutes
  final bool pomodoroModeEnabled;
  final bool focusModeEnabled;

  const SettingsEntity({
    // Notification Settings
    this.notificationsEnabled = true,
    this.lessonReminders = true,
    this.quizReminders = true,
    this.achievementNotifications = true,
    this.dailyProgressNotifications = true,
    this.reminderTime = '09:00',

    // Learning Preferences
    this.preferredLanguage = 'en',
    this.difficultyLevel = 'beginner',
    this.autoPlayVideos = true,
    this.showSubtitles = false,
    this.playbackSpeed = '1x',
    this.darkModeEnabled = false,
    this.offlineModeEnabled = false,

    // App Preferences
    this.autoDownloadNewContent = false,
    this.downloadOverWifiOnly = true,
    this.dataSaverMode = false,
    this.hapticFeedbackEnabled = true,
    this.soundEffectsEnabled = true,
    this.analyticsEnabled = true,

    // Privacy & Security
    this.profileVisibility = false,
    this.shareProgressWithFriends = false,
    this.allowDataCollection = true,
    this.biometricLoginEnabled = false,

    // Study Settings
    this.studySessionDuration = 25,
    this.breakDuration = 5,
    this.pomodoroModeEnabled = false,
    this.focusModeEnabled = false,
  });

  SettingsEntity copyWith({
    // Notification Settings
    bool? notificationsEnabled,
    bool? lessonReminders,
    bool? quizReminders,
    bool? achievementNotifications,
    bool? dailyProgressNotifications,
    String? reminderTime,

    // Learning Preferences
    String? preferredLanguage,
    String? difficultyLevel,
    bool? autoPlayVideos,
    bool? showSubtitles,
    String? playbackSpeed,
    bool? darkModeEnabled,
    bool? offlineModeEnabled,

    // App Preferences
    bool? autoDownloadNewContent,
    bool? downloadOverWifiOnly,
    bool? dataSaverMode,
    bool? hapticFeedbackEnabled,
    bool? soundEffectsEnabled,
    bool? analyticsEnabled,

    // Privacy & Security
    bool? profileVisibility,
    bool? shareProgressWithFriends,
    bool? allowDataCollection,
    bool? biometricLoginEnabled,

    // Study Settings
    int? studySessionDuration,
    int? breakDuration,
    bool? pomodoroModeEnabled,
    bool? focusModeEnabled,
  }) {
    return SettingsEntity(
      // Notification Settings
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      lessonReminders: lessonReminders ?? this.lessonReminders,
      quizReminders: quizReminders ?? this.quizReminders,
      achievementNotifications: achievementNotifications ?? this.achievementNotifications,
      dailyProgressNotifications: dailyProgressNotifications ?? this.dailyProgressNotifications,
      reminderTime: reminderTime ?? this.reminderTime,

      // Learning Preferences
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
      showSubtitles: showSubtitles ?? this.showSubtitles,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      offlineModeEnabled: offlineModeEnabled ?? this.offlineModeEnabled,

      // App Preferences
      autoDownloadNewContent: autoDownloadNewContent ?? this.autoDownloadNewContent,
      downloadOverWifiOnly: downloadOverWifiOnly ?? this.downloadOverWifiOnly,
      dataSaverMode: dataSaverMode ?? this.dataSaverMode,
      hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,

      // Privacy & Security
      profileVisibility: profileVisibility ?? this.profileVisibility,
      shareProgressWithFriends: shareProgressWithFriends ?? this.shareProgressWithFriends,
      allowDataCollection: allowDataCollection ?? this.allowDataCollection,
      biometricLoginEnabled: biometricLoginEnabled ?? this.biometricLoginEnabled,

      // Study Settings
      studySessionDuration: studySessionDuration ?? this.studySessionDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      pomodoroModeEnabled: pomodoroModeEnabled ?? this.pomodoroModeEnabled,
      focusModeEnabled: focusModeEnabled ?? this.focusModeEnabled,
    );
  }

  @override
  List<Object?> get props => [
        // Notification Settings
        notificationsEnabled,
        lessonReminders,
        quizReminders,
        achievementNotifications,
        dailyProgressNotifications,
        reminderTime,

        // Learning Preferences
        preferredLanguage,
        difficultyLevel,
        autoPlayVideos,
        showSubtitles,
        playbackSpeed,
        darkModeEnabled,
        offlineModeEnabled,

        // App Preferences
        autoDownloadNewContent,
        downloadOverWifiOnly,
        dataSaverMode,
        hapticFeedbackEnabled,
        soundEffectsEnabled,
        analyticsEnabled,

        // Privacy & Security
        profileVisibility,
        shareProgressWithFriends,
        allowDataCollection,
        biometricLoginEnabled,

        // Study Settings
        studySessionDuration,
        breakDuration,
        pomodoroModeEnabled,
        focusModeEnabled,
      ];
}

