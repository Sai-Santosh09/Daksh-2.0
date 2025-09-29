import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/settings_entity.dart';

class SettingsService {
  static const String _settingsKey = 'app_settings';

  // Get saved settings
  static Future<SettingsEntity> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsData = prefs.getString(_settingsKey);
      
      if (settingsData != null) {
        return _parseSettings(settingsData);
      }
      
      return const SettingsEntity(); // Return default settings
    } catch (e) {
      print('Error getting settings: $e');
      return const SettingsEntity();
    }
  }

  // Save settings
  static Future<void> saveSettings(SettingsEntity settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsData = _serializeSettings(settings);
      await prefs.setString(_settingsKey, settingsData);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  // Update specific setting
  static Future<void> updateSetting(String key, dynamic value) async {
    try {
      final currentSettings = await getSettings();
      final updatedSettings = _updateSettingByKey(currentSettings, key, value);
      await saveSettings(updatedSettings);
    } catch (e) {
      print('Error updating setting: $e');
    }
  }

  // Reset all settings to default
  static Future<void> resetSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_settingsKey);
    } catch (e) {
      print('Error resetting settings: $e');
    }
  }

  // Simple serialization (in a real app, use proper JSON serialization)
  static String _serializeSettings(SettingsEntity settings) {
    return [
      // Notification Settings
      settings.notificationsEnabled,
      settings.lessonReminders,
      settings.quizReminders,
      settings.achievementNotifications,
      settings.dailyProgressNotifications,
      settings.reminderTime,

      // Learning Preferences
      settings.preferredLanguage,
      settings.difficultyLevel,
      settings.autoPlayVideos,
      settings.showSubtitles,
      settings.playbackSpeed,
      settings.darkModeEnabled,
      settings.offlineModeEnabled,

      // App Preferences
      settings.autoDownloadNewContent,
      settings.downloadOverWifiOnly,
      settings.dataSaverMode,
      settings.hapticFeedbackEnabled,
      settings.soundEffectsEnabled,
      settings.analyticsEnabled,

      // Privacy & Security
      settings.profileVisibility,
      settings.shareProgressWithFriends,
      settings.allowDataCollection,
      settings.biometricLoginEnabled,

      // Study Settings
      settings.studySessionDuration,
      settings.breakDuration,
      settings.pomodoroModeEnabled,
      settings.focusModeEnabled,
    ].join('|');
  }

  static SettingsEntity _parseSettings(String data) {
    try {
      final parts = data.split('|');
      if (parts.length >= 26) {
        return SettingsEntity(
          // Notification Settings
          notificationsEnabled: parts[0] == 'true',
          lessonReminders: parts[1] == 'true',
          quizReminders: parts[2] == 'true',
          achievementNotifications: parts[3] == 'true',
          dailyProgressNotifications: parts[4] == 'true',
          reminderTime: parts[5],

          // Learning Preferences
          preferredLanguage: parts[6],
          difficultyLevel: parts[7],
          autoPlayVideos: parts[8] == 'true',
          showSubtitles: parts[9] == 'true',
          playbackSpeed: parts[10],
          darkModeEnabled: parts[11] == 'true',
          offlineModeEnabled: parts[12] == 'true',

          // App Preferences
          autoDownloadNewContent: parts[13] == 'true',
          downloadOverWifiOnly: parts[14] == 'true',
          dataSaverMode: parts[15] == 'true',
          hapticFeedbackEnabled: parts[16] == 'true',
          soundEffectsEnabled: parts[17] == 'true',
          analyticsEnabled: parts[18] == 'true',

          // Privacy & Security
          profileVisibility: parts[19] == 'true',
          shareProgressWithFriends: parts[20] == 'true',
          allowDataCollection: parts[21] == 'true',
          biometricLoginEnabled: parts[22] == 'true',

          // Study Settings
          studySessionDuration: int.tryParse(parts[23]) ?? 25,
          breakDuration: int.tryParse(parts[24]) ?? 5,
          pomodoroModeEnabled: parts[25] == 'true',
          focusModeEnabled: parts.length > 26 ? parts[26] == 'true' : false,
        );
      }
    } catch (e) {
      print('Error parsing settings: $e');
    }
    return const SettingsEntity();
  }

  static SettingsEntity _updateSettingByKey(SettingsEntity settings, String key, dynamic value) {
    switch (key) {
      // Notification Settings
      case 'notificationsEnabled':
        return settings.copyWith(notificationsEnabled: value as bool);
      case 'lessonReminders':
        return settings.copyWith(lessonReminders: value as bool);
      case 'quizReminders':
        return settings.copyWith(quizReminders: value as bool);
      case 'achievementNotifications':
        return settings.copyWith(achievementNotifications: value as bool);
      case 'dailyProgressNotifications':
        return settings.copyWith(dailyProgressNotifications: value as bool);
      case 'reminderTime':
        return settings.copyWith(reminderTime: value as String);

      // Learning Preferences
      case 'preferredLanguage':
        return settings.copyWith(preferredLanguage: value as String);
      case 'difficultyLevel':
        return settings.copyWith(difficultyLevel: value as String);
      case 'autoPlayVideos':
        return settings.copyWith(autoPlayVideos: value as bool);
      case 'showSubtitles':
        return settings.copyWith(showSubtitles: value as bool);
      case 'playbackSpeed':
        return settings.copyWith(playbackSpeed: value as String);
      case 'darkModeEnabled':
        return settings.copyWith(darkModeEnabled: value as bool);
      case 'offlineModeEnabled':
        return settings.copyWith(offlineModeEnabled: value as bool);

      // App Preferences
      case 'autoDownloadNewContent':
        return settings.copyWith(autoDownloadNewContent: value as bool);
      case 'downloadOverWifiOnly':
        return settings.copyWith(downloadOverWifiOnly: value as bool);
      case 'dataSaverMode':
        return settings.copyWith(dataSaverMode: value as bool);
      case 'hapticFeedbackEnabled':
        return settings.copyWith(hapticFeedbackEnabled: value as bool);
      case 'soundEffectsEnabled':
        return settings.copyWith(soundEffectsEnabled: value as bool);
      case 'analyticsEnabled':
        return settings.copyWith(analyticsEnabled: value as bool);

      // Privacy & Security
      case 'profileVisibility':
        return settings.copyWith(profileVisibility: value as bool);
      case 'shareProgressWithFriends':
        return settings.copyWith(shareProgressWithFriends: value as bool);
      case 'allowDataCollection':
        return settings.copyWith(allowDataCollection: value as bool);
      case 'biometricLoginEnabled':
        return settings.copyWith(biometricLoginEnabled: value as bool);

      // Study Settings
      case 'studySessionDuration':
        return settings.copyWith(studySessionDuration: value as int);
      case 'breakDuration':
        return settings.copyWith(breakDuration: value as int);
      case 'pomodoroModeEnabled':
        return settings.copyWith(pomodoroModeEnabled: value as bool);
      case 'focusModeEnabled':
        return settings.copyWith(focusModeEnabled: value as bool);

      default:
        return settings;
    }
  }
}


