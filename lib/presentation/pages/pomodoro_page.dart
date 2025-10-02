import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../providers/settings_provider.dart';
import '../widgets/pomodoro_timer_widget.dart';
import 'pomodoro_settings_page.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    
    // Check if Pomodoro mode is enabled in settings
    if (!settingsState.settings.pomodoroModeEnabled) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pomodoro Timer'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer_off,
                  size: 100,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: AppTheme.spacingL),
                Text(
                  'Pomodoro Timer Disabled',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                Text(
                  'Enable Pomodoro mode in Settings to use the timer.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(); // Go back to previous page
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Go to Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PomodoroSettingsPage(),
              ),
            ),
            icon: const Icon(Icons.settings),
            tooltip: 'Timer Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main Timer Widget
            const PomodoroTimerWidget(showFullControls: true),
            
            // Tips and Information
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Productivity Tips',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      
                      _buildTipItem(
                        context,
                        '🎯 Focus completely during work sessions',
                        'Avoid distractions and concentrate on your current task',
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      
                      _buildTipItem(
                        context,
                        '☕ Take real breaks',
                        'Step away from your work area during break time',
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      
                      _buildTipItem(
                        context,
                        '📱 Minimize interruptions',
                        'Turn off notifications during focus sessions',
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      
                      _buildTipItem(
                        context,
                        '🎉 Celebrate completions',
                        'Acknowledge each completed pomodoro session',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTipItem(BuildContext context, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
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
      ],
    );
  }
}

