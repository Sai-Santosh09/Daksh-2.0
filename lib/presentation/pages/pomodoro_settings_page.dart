import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../providers/pomodoro_provider.dart';
import '../widgets/pomodoro_timer_widget.dart';

class PomodoroSettingsPage extends ConsumerStatefulWidget {
  const PomodoroSettingsPage({super.key});

  @override
  ConsumerState<PomodoroSettingsPage> createState() => _PomodoroSettingsPageState();
}

class _PomodoroSettingsPageState extends ConsumerState<PomodoroSettingsPage> {
  late int _studyDuration;
  late int _shortBreakDuration;
  late int _longBreakDuration;
  late bool _soundEnabled;
  late bool _vibrationEnabled;
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    // Initialize with default values, will be updated in build method
    _studyDuration = 25;
    _shortBreakDuration = 5;
    _longBreakDuration = 15;
    _soundEnabled = true;
    _vibrationEnabled = true;
    _notificationsEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(pomodoroSessionsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _resetStats,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Statistics',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timer Widget
            const PomodoroTimerWidget(showFullControls: true),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Settings Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Timer Settings',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Study Duration
                    _buildDurationSetting(
                      'Study Session Duration',
                      'Focus time for each study session',
                      _studyDuration,
                      15,
                      60,
                      Icons.timer,
                      (value) {
                        setState(() => _studyDuration = value);
                        _updateSettings();
                      },
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Short Break Duration
                    _buildDurationSetting(
                      'Short Break Duration',
                      'Rest time between study sessions',
                      _shortBreakDuration,
                      2,
                      15,
                      Icons.coffee,
                      (value) {
                        setState(() => _shortBreakDuration = value);
                        _updateSettings();
                      },
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Long Break Duration
                    _buildDurationSetting(
                      'Long Break Duration',
                      'Extended rest after 4 study sessions',
                      _longBreakDuration,
                      15,
                      45,
                      Icons.hotel,
                      (value) {
                        setState(() => _longBreakDuration = value);
                        _updateSettings();
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Notification Settings
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notification Settings',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    
                    _buildSwitchSetting(
                      'Notifications',
                      'Show notifications for session changes',
                      Icons.notifications,
                      _notificationsEnabled,
                      (value) {
                        setState(() => _notificationsEnabled = value);
                        _updateSettings();
                      },
                    ),
                    
                    _buildSwitchSetting(
                      'Sound Effects',
                      'Play sounds when sessions start/end',
                      Icons.volume_up,
                      _soundEnabled,
                      (value) {
                        setState(() => _soundEnabled = value);
                        _updateSettings();
                      },
                    ),
                    
                    _buildSwitchSetting(
                      'Vibration',
                      'Vibrate device for session changes',
                      Icons.vibration,
                      _vibrationEnabled,
                      (value) {
                        setState(() => _vibrationEnabled = value);
                        _updateSettings();
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Statistics
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    
                    sessionsAsync.when(
                      data: (sessions) => _buildStatisticsContent(sessions),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('Error loading statistics'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // About Pomodoro Technique
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Pomodoro Technique',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    
                    const Text(
                      'The Pomodoro Technique is a time management method that uses a timer to break work into intervals, '
                      'traditionally 25 minutes in length, separated by short breaks.\n\n'
                      '• Work for 25 minutes (one "pomodoro")\n'
                      '• Take a 5-minute break\n'
                      '• After 4 pomodoros, take a longer break (15-30 minutes)\n\n'
                      'This technique helps improve focus and productivity while preventing burnout.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDurationSetting(
    String title,
    String subtitle,
    int currentValue,
    int min,
    int max,
    IconData icon,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$currentValue min',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: currentValue.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          activeColor: Colors.blue,
          onChanged: (value) => onChanged(value.round()),
        ),
      ],
    );
  }
  
  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        activeColor: Colors.blue,
        onChanged: onChanged,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
  
  Widget _buildStatisticsContent(int completedSessions) {
    final studyTime = completedSessions * _studyDuration;
    final breakTime = completedSessions * _shortBreakDuration;
    final totalTime = studyTime + breakTime;
    
    return Column(
      children: [
        _buildStatItem('Completed Sessions', '$completedSessions', Icons.check_circle),
        const SizedBox(height: 8),
        _buildStatItem('Total Study Time', '${studyTime}min', Icons.timer),
        const SizedBox(height: 8),
        _buildStatItem('Total Break Time', '${breakTime}min', Icons.coffee),
        const SizedBox(height: 8),
        _buildStatItem('Total Time', '${totalTime}min', Icons.access_time),
      ],
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blue),
        const SizedBox(width: 8),
        Text(label),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
  
  void _updateSettings() {
    final controller = ref.read(pomodoroControllerProvider);
    controller.updateSettings(
      studyDuration: _studyDuration,
      shortBreakDuration: _shortBreakDuration,
      longBreakDuration: _longBreakDuration,
      soundEnabled: _soundEnabled,
      vibrationEnabled: _vibrationEnabled,
      notificationsEnabled: _notificationsEnabled,
    );
  }
  
  void _resetStats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Statistics'),
        content: const Text('Are you sure you want to reset all Pomodoro statistics? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final controller = ref.read(pomodoroControllerProvider);
              controller.resetStats();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Statistics have been reset')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
