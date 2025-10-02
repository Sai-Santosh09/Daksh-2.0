import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/pomodoro_service.dart';
import '../providers/pomodoro_provider.dart';

class PomodoroTimerWidget extends ConsumerWidget {
  final bool showFullControls;
  final VoidCallback? onSessionComplete;
  
  const PomodoroTimerWidget({
    super.key,
    this.showFullControls = true,
    this.onSessionComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(pomodoroStateProvider);
    final timerAsync = ref.watch(pomodoroTimerProvider);
    final sessionsAsync = ref.watch(pomodoroSessionsProvider);
    final phaseAsync = ref.watch(pomodoroPhaseProvider);
    final controller = ref.watch(pomodoroControllerProvider);
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pomodoro Timer',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showFullControls)
                  IconButton(
                    onPressed: () => _showSettingsDialog(context, ref),
                    icon: const Icon(Icons.settings),
                    tooltip: 'Timer Settings',
                  ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Timer Display
            stateAsync.when(
              data: (state) => timerAsync.when(
                data: (remainingSeconds) => _buildTimerDisplay(
                  context,
                  state,
                  remainingSeconds,
                  controller.progress,
                ),
                loading: () => _buildTimerDisplay(context, state, 0, 0.0),
                error: (_, __) => _buildTimerDisplay(context, state, 0, 0.0),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading timer'),
            ),
            
            const SizedBox(height: 20),
            
            // Phase Indicator
            phaseAsync.when(
              data: (phase) => _buildPhaseIndicator(context, phase),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 20),
            
            // Control Buttons
            stateAsync.when(
              data: (state) => _buildControlButtons(context, state, controller),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            
            if (showFullControls) ...[
              const SizedBox(height: 20),
              
              // Sessions Counter
              sessionsAsync.when(
                data: (sessions) => _buildSessionsCounter(context, sessions),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildTimerDisplay(
    BuildContext context,
    PomodoroState state,
    int remainingSeconds,
    double progress,
  ) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    
    Color progressColor;
    switch (state) {
      case PomodoroState.studySession:
        progressColor = Colors.blue;
        break;
      case PomodoroState.shortBreak:
        progressColor = Colors.green;
        break;
      case PomodoroState.longBreak:
        progressColor = Colors.lightBlue;
        break;
      case PomodoroState.paused:
        progressColor = Colors.orange;
        break;
      default:
        progressColor = Colors.grey;
    }
    
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress Circle
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),
          
          // Timer Text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeText,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: progressColor,
                ),
              ),
              Text(
                _getStateText(state),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPhaseIndicator(BuildContext context, PomodoroPhase phase) {
    final isWork = phase == PomodoroPhase.work;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isWork ? Colors.blue.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWork ? Colors.blue : Colors.green,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isWork ? Icons.work : Icons.coffee,
            size: 16,
            color: isWork ? Colors.blue : Colors.green,
          ),
          const SizedBox(width: 8),
          Text(
            isWork ? 'Focus Time' : 'Break Time',
            style: TextStyle(
              color: isWork ? Colors.blue : Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlButtons(
    BuildContext context,
    PomodoroState state,
    PomodoroController controller,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Start/Resume Button
        if (state == PomodoroState.idle || state == PomodoroState.paused)
          ElevatedButton.icon(
            onPressed: () => controller.startStudySession(),
            icon: Icon(state == PomodoroState.paused ? Icons.play_arrow : Icons.play_arrow),
            label: Text(state == PomodoroState.paused ? 'Resume' : 'Start'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        
        // Pause Button
        if (state == PomodoroState.studySession || 
            state == PomodoroState.shortBreak || 
            state == PomodoroState.longBreak)
          ElevatedButton.icon(
            onPressed: () => controller.pauseTimer(),
            icon: const Icon(Icons.pause),
            label: const Text('Pause'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        
        // Stop Button
        if (state != PomodoroState.idle)
          ElevatedButton.icon(
            onPressed: () => _showStopConfirmation(context, controller),
            icon: const Icon(Icons.stop),
            label: const Text('Stop'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
      ],
    );
  }
  
  Widget _buildSessionsCounter(BuildContext context, int sessions) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Completed Sessions: $sessions',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  String _getStateText(PomodoroState state) {
    switch (state) {
      case PomodoroState.idle:
        return 'Ready to start';
      case PomodoroState.studySession:
        return 'Study session';
      case PomodoroState.shortBreak:
        return 'Short break';
      case PomodoroState.longBreak:
        return 'Long break';
      case PomodoroState.paused:
        return 'Paused';
    }
  }
  
  void _showStopConfirmation(BuildContext context, PomodoroController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Timer'),
        content: const Text('Are you sure you want to stop the current session? Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.stopSession();
              Navigator.of(context).pop();
            },
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
  
  void _showSettingsDialog(BuildContext context, WidgetRef ref) {
    final controller = ref.read(pomodoroControllerProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pomodoro Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDurationSlider(
                'Study Duration',
                controller.studyDuration,
                15,
                60,
                (value) => controller.updateSettings(studyDuration: value.round()),
              ),
              const SizedBox(height: 16),
              _buildDurationSlider(
                'Short Break',
                controller.shortBreakDuration,
                2,
                15,
                (value) => controller.updateSettings(shortBreakDuration: value.round()),
              ),
              const SizedBox(height: 16),
              _buildDurationSlider(
                'Long Break',
                controller.longBreakDuration,
                15,
                30,
                (value) => controller.updateSettings(longBreakDuration: value.round()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDurationSlider(
    String label,
    int currentValue,
    int min,
    int max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $currentValue minutes'),
        Slider(
          value: currentValue.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
