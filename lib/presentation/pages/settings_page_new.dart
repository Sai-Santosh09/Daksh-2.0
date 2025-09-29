import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';
import '../widgets/language_selector.dart';
import '../providers/app_providers.dart';
import '../providers/user_profile_provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(userProfileProvider);
    final settingsState = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        actions: [
          IconButton(
            onPressed: () {
              _showResetSettingsDialog(context, settingsNotifier);
            },
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to defaults',
          ),
        ],
      ),
      body: settingsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  _buildProfileSection(context, l10n, profile),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Notification Settings
                  _buildNotificationSettings(context, settingsState.settings, settingsNotifier),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Learning Preferences
                  _buildLearningPreferences(context, settingsState.settings, settingsNotifier),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // App Preferences
                  _buildAppPreferences(context, settingsState.settings, settingsNotifier),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Study Settings
                  _buildStudySettings(context, settingsState.settings, settingsNotifier),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Privacy & Security
                  _buildPrivacySecurity(context, settingsState.settings, settingsNotifier),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Language & Theme
                  _buildLanguageTheme(context, ref, l10n),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // About & Support
                  _buildAboutSupport(context, l10n),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileSection(BuildContext context, AppLocalizations l10n, dynamic profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.profile,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TextButton.icon(
                  onPressed: () => context.go('/edit-profile'),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ],
            ),
            if (profile != null) ...[
              const SizedBox(height: AppTheme.spacingM),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: profile.profileImageUrl != null
                        ? ClipOval(
                            child: Image.network(
                              profile.profileImageUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 30,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          profile.email,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (profile.currentClass != null)
                          Text(
                            'Class ${profile.currentClass}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context, dynamic settings, SettingsNotifier notifier) {
    return _buildSettingsSection(
      context,
      'Notifications',
      Icons.notifications,
      Colors.blue,
      [
        _buildSwitchTile(
          context,
          'Enable Notifications',
          'Receive notifications for lessons, quizzes, and achievements',
          Icons.notifications_active,
          settings.notificationsEnabled,
          (value) => notifier.updateSetting('notificationsEnabled', value),
        ),
        if (settings.notificationsEnabled) ...[
          _buildSwitchTile(
            context,
            'Lesson Reminders',
            'Get reminded about upcoming lessons',
            Icons.school,
            settings.lessonReminders,
            (value) => notifier.updateSetting('lessonReminders', value),
          ),
          _buildSwitchTile(
            context,
            'Quiz Reminders',
            'Get reminded about pending quizzes',
            Icons.quiz,
            settings.quizReminders,
            (value) => notifier.updateSetting('quizReminders', value),
          ),
          _buildSwitchTile(
            context,
            'Achievement Notifications',
            'Get notified when you earn achievements',
            Icons.emoji_events,
            settings.achievementNotifications,
            (value) => notifier.updateSetting('achievementNotifications', value),
          ),
          _buildSwitchTile(
            context,
            'Daily Progress',
            'Get daily progress summaries',
            Icons.trending_up,
            settings.dailyProgressNotifications,
            (value) => notifier.updateSetting('dailyProgressNotifications', value),
          ),
          _buildListTile(
            context,
            'Reminder Time',
            'Set when to receive daily reminders',
            Icons.access_time,
            settings.reminderTime,
            () => _showTimePicker(context, notifier),
          ),
        ],
      ],
    );
  }

  Widget _buildLearningPreferences(BuildContext context, dynamic settings, SettingsNotifier notifier) {
    return _buildSettingsSection(
      context,
      'Learning Preferences',
      Icons.school,
      Colors.green,
      [
        _buildDropdownTile(
          context,
          'Difficulty Level',
          'Choose your preferred difficulty level',
          Icons.trending_up,
          settings.difficultyLevel,
          ['beginner', 'intermediate', 'advanced'],
          (value) => notifier.updateSetting('difficultyLevel', value),
        ),
        _buildSwitchTile(
          context,
          'Auto-play Videos',
          'Automatically start playing lesson videos',
          Icons.play_circle,
          settings.autoPlayVideos,
          (value) => notifier.updateSetting('autoPlayVideos', value),
        ),
        _buildSwitchTile(
          context,
          'Show Subtitles',
          'Display subtitles in videos',
          Icons.closed_caption,
          settings.showSubtitles,
          (value) => notifier.updateSetting('showSubtitles', value),
        ),
        _buildDropdownTile(
          context,
          'Playback Speed',
          'Set default video playback speed',
          Icons.speed,
          settings.playbackSpeed,
          ['0.5x', '0.75x', '1x', '1.25x', '1.5x', '2x'],
          (value) => notifier.updateSetting('playbackSpeed', value),
        ),
        _buildSwitchTile(
          context,
          'Offline Mode',
          'Enable offline learning capabilities',
          Icons.offline_bolt,
          settings.offlineModeEnabled,
          (value) => notifier.updateSetting('offlineModeEnabled', value),
        ),
      ],
    );
  }

  Widget _buildAppPreferences(BuildContext context, dynamic settings, SettingsNotifier notifier) {
    return _buildSettingsSection(
      context,
      'App Preferences',
      Icons.settings,
      Colors.orange,
      [
        _buildSwitchTile(
          context,
          'Auto-download New Content',
          'Automatically download new lessons and materials',
          Icons.download,
          settings.autoDownloadNewContent,
          (value) => notifier.updateSetting('autoDownloadNewContent', value),
        ),
        _buildSwitchTile(
          context,
          'Download over Wi-Fi Only',
          'Only download content when connected to Wi-Fi',
          Icons.wifi,
          settings.downloadOverWifiOnly,
          (value) => notifier.updateSetting('downloadOverWifiOnly', value),
        ),
        _buildSwitchTile(
          context,
          'Data Saver Mode',
          'Reduce data usage for slower connections',
          Icons.data_saver_off,
          settings.dataSaverMode,
          (value) => notifier.updateSetting('dataSaverMode', value),
        ),
        _buildSwitchTile(
          context,
          'Haptic Feedback',
          'Feel vibrations for interactions',
          Icons.vibration,
          settings.hapticFeedbackEnabled,
          (value) => notifier.updateSetting('hapticFeedbackEnabled', value),
        ),
        _buildSwitchTile(
          context,
          'Sound Effects',
          'Play sounds for app interactions',
          Icons.volume_up,
          settings.soundEffectsEnabled,
          (value) => notifier.updateSetting('soundEffectsEnabled', value),
        ),
        _buildSwitchTile(
          context,
          'Analytics',
          'Help improve the app by sharing usage data',
          Icons.analytics,
          settings.analyticsEnabled,
          (value) => notifier.updateSetting('analyticsEnabled', value),
        ),
      ],
    );
  }

  Widget _buildStudySettings(BuildContext context, dynamic settings, SettingsNotifier notifier) {
    return _buildSettingsSection(
      context,
      'Study Settings',
      Icons.psychology,
      Colors.purple,
      [
        _buildSliderTile(
          context,
          'Study Session Duration',
          'How long each study session should be',
          Icons.timer,
          settings.studySessionDuration.toDouble(),
          15.0,
          60.0,
          (value) => notifier.updateSetting('studySessionDuration', value.round()),
        ),
        _buildSliderTile(
          context,
          'Break Duration',
          'How long breaks between sessions should be',
          Icons.coffee,
          settings.breakDuration.toDouble(),
          2.0,
          30.0,
          (value) => notifier.updateSetting('breakDuration', value.round()),
        ),
        _buildSwitchTile(
          context,
          'Pomodoro Mode',
          'Use Pomodoro technique for study sessions',
          Icons.timer_outlined,
          settings.pomodoroModeEnabled,
          (value) => notifier.updateSetting('pomodoroModeEnabled', value),
        ),
        _buildSwitchTile(
          context,
          'Focus Mode',
          'Block distracting notifications during study',
          Icons.center_focus_strong,
          settings.focusModeEnabled,
          (value) => notifier.updateSetting('focusModeEnabled', value),
        ),
      ],
    );
  }

  Widget _buildPrivacySecurity(BuildContext context, dynamic settings, SettingsNotifier notifier) {
    return _buildSettingsSection(
      context,
      'Privacy & Security',
      Icons.security,
      Colors.red,
      [
        _buildSwitchTile(
          context,
          'Public Profile',
          'Allow others to see your learning progress',
          Icons.public,
          settings.profileVisibility,
          (value) => notifier.updateSetting('profileVisibility', value),
        ),
        _buildSwitchTile(
          context,
          'Share Progress with Friends',
          'Share your achievements with friends',
          Icons.share,
          settings.shareProgressWithFriends,
          (value) => notifier.updateSetting('shareProgressWithFriends', value),
        ),
        _buildSwitchTile(
          context,
          'Allow Data Collection',
          'Help improve the app by sharing anonymous data',
          Icons.data_usage,
          settings.allowDataCollection,
          (value) => notifier.updateSetting('allowDataCollection', value),
        ),
        _buildSwitchTile(
          context,
          'Biometric Login',
          'Use fingerprint or face recognition to login',
          Icons.fingerprint,
          settings.biometricLoginEnabled,
          (value) => notifier.updateSetting('biometricLoginEnabled', value),
        ),
      ],
    );
  }

  Widget _buildLanguageTheme(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return _buildSettingsSection(
      context,
      'Language & Theme',
      Icons.language,
      Colors.teal,
      [
        const LanguageSelector(),
        _buildThemeSelector(context, ref),
      ],
    );
  }

  Widget _buildAboutSupport(BuildContext context, AppLocalizations l10n) {
    return _buildSettingsSection(
      context,
      'About & Support',
      Icons.info,
      Colors.grey,
      [
        _buildInfoTile(
          context,
          'App Version',
          '1.0.0',
          Icons.info_outline,
        ),
        _buildActionTile(
          context,
          'Help & Support',
          'Get help and contact support',
          Icons.help_outline,
          () => _showHelpDialog(context),
        ),
        _buildActionTile(
          context,
          'Privacy Policy',
          'Read our privacy policy',
          Icons.privacy_tip_outlined,
          () => _showPrivacyDialog(context),
        ),
        _buildActionTile(
          context,
          'Terms of Service',
          'Read our terms of service',
          Icons.description_outlined,
          () => _showTermsDialog(context),
        ),
        _buildActionTile(
          context,
          'Rate App',
          'Rate us on the app store',
          Icons.star_outline,
          () => _showRateDialog(context),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Icon(icon, color: Colors.grey.shade600),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String value,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(icon, color: Colors.grey.shade600),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDropdownTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<String> options,
    ValueChanged<String> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(icon, color: Colors.grey.shade600),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: (newValue) {
          if (newValue != null) onChanged(newValue);
        },
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSliderTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: AppTheme.spacingS),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / 5).round(),
            label: '${value.round()} min',
            onChanged: onChanged,
          ),
        ],
      ),
      leading: Icon(icon, color: Colors.grey.shade600),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      leading: Icon(icon, color: Colors.grey.shade600),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(icon, color: Colors.grey.shade600),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildThemeSelector(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return ListTile(
      title: const Text('Theme'),
      subtitle: Text(_getThemeModeText(themeMode)),
      leading: Icon(
        themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
        color: Colors.grey.shade600,
      ),
      trailing: PopupMenuButton<ThemeMode>(
        onSelected: (mode) => themeNotifier.setThemeMode(mode),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: ThemeMode.light,
            child: Text('Light'),
          ),
          const PopupMenuItem(
            value: ThemeMode.dark,
            child: Text('Dark'),
          ),
          const PopupMenuItem(
            value: ThemeMode.system,
            child: Text('System'),
          ),
        ],
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showTimePicker(BuildContext context, SettingsNotifier notifier) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((time) {
      if (time != null) {
        final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        notifier.updateSetting('reminderTime', timeString);
      }
    });
  }

  void _showResetSettingsDialog(BuildContext context, SettingsNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to their default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              notifier.resetSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('For help and support, please contact us at:\n\nEmail: support@daksh.com\nPhone: +91-XXX-XXX-XXXX'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text('Our privacy policy explains how we collect, use, and protect your personal information...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text('Our terms of service outline the rules and regulations for using our app...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Our App'),
        content: const Text('If you enjoy using Daksh, please consider rating us on the app store!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your support!')),
              );
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }
}

