import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/pomodoro_service.dart';

// Pomodoro service provider
final pomodoroServiceProvider = Provider<PomodoroService>((ref) {
  final service = PomodoroService();
  service.initialize();
  
  // Dispose when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

// Pomodoro state provider
final pomodoroStateProvider = StreamProvider<PomodoroState>((ref) {
  final service = ref.watch(pomodoroServiceProvider);
  return service.stateStream;
});

// Timer provider
final pomodoroTimerProvider = StreamProvider<int>((ref) {
  final service = ref.watch(pomodoroServiceProvider);
  return service.timerStream;
});

// Sessions count provider
final pomodoroSessionsProvider = StreamProvider<int>((ref) {
  final service = ref.watch(pomodoroServiceProvider);
  return service.sessionsStream;
});

// Phase provider (work/break)
final pomodoroPhaseProvider = StreamProvider<PomodoroPhase>((ref) {
  final service = ref.watch(pomodoroServiceProvider);
  return service.phaseStream;
});

// Formatted time provider
final pomodoroFormattedTimeProvider = Provider<String>((ref) {
  final service = ref.watch(pomodoroServiceProvider);
  return service.getFormattedTime();
});

// Progress provider
final pomodoroProgressProvider = Provider<double>((ref) {
  final service = ref.watch(pomodoroServiceProvider);
  return service.getProgress();
});

// Pomodoro controller provider for actions
final pomodoroControllerProvider = Provider<PomodoroController>((ref) {
  final service = ref.watch(pomodoroServiceProvider);
  return PomodoroController(service);
});

// Controller class for Pomodoro actions
class PomodoroController {
  final PomodoroService _service;
  
  PomodoroController(this._service);
  
  // Start study session
  Future<void> startStudySession() => _service.startStudySession();
  
  // Start break
  Future<void> startBreak() => _service.startBreak();
  
  // Pause timer
  void pauseTimer() => _service.pauseTimer();
  
  // Resume timer
  void resumeTimer() => _service.resumeTimer();
  
  // Stop session
  void stopSession() => _service.stopSession();
  
  // Reset stats
  Future<void> resetStats() => _service.resetStats();
  
  // Update settings
  void updateSettings({
    int? studyDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
  }) {
    _service.updateSettings(
      studyDuration: studyDuration,
      shortBreakDuration: shortBreakDuration,
      longBreakDuration: longBreakDuration,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
      notificationsEnabled: notificationsEnabled,
    );
  }
  
  // Getters
  PomodoroState get currentState => _service.currentState;
  int get remainingSeconds => _service.remainingSeconds;
  int get completedSessions => _service.completedSessions;
  int get totalSessions => _service.totalSessions;
  int get studyDuration => _service.studyDuration;
  int get shortBreakDuration => _service.shortBreakDuration;
  int get longBreakDuration => _service.longBreakDuration;
  bool get isActive => _service.isActive;
  bool get isPaused => _service.isPaused;
  String get formattedTime => _service.getFormattedTime();
  double get progress => _service.getProgress();
}
