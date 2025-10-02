import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PomodoroState {
  idle,
  studySession,
  shortBreak,
  longBreak,
  paused,
}

enum PomodoroPhase {
  work,
  rest,
}

class PomodoroService {
  static const String _pomodoroStatsKey = 'pomodoro_stats';
  static const int _longBreakInterval = 4; // Every 4 sessions
  
  Timer? _timer;
  PomodoroState _currentState = PomodoroState.idle;
  int _remainingSeconds = 0;
  int _completedSessions = 0;
  int _totalSessions = 0;
  DateTime? _sessionStartTime;
  
  // Settings
  int _studyDuration = 25; // minutes
  int _shortBreakDuration = 5; // minutes
  int _longBreakDuration = 15; // minutes
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = true;
  
  // Stream controllers
  final StreamController<PomodoroState> _stateController = StreamController<PomodoroState>.broadcast();
  final StreamController<int> _timerController = StreamController<int>.broadcast();
  final StreamController<int> _sessionsController = StreamController<int>.broadcast();
  final StreamController<PomodoroPhase> _phaseController = StreamController<PomodoroPhase>.broadcast();
  
  // Getters
  PomodoroState get currentState => _currentState;
  int get remainingSeconds => _remainingSeconds;
  int get completedSessions => _completedSessions;
  int get totalSessions => _totalSessions;
  int get studyDuration => _studyDuration;
  int get shortBreakDuration => _shortBreakDuration;
  int get longBreakDuration => _longBreakDuration;
  bool get isActive => _currentState != PomodoroState.idle;
  bool get isPaused => _currentState == PomodoroState.paused;
  
  // Streams
  Stream<PomodoroState> get stateStream => _stateController.stream;
  Stream<int> get timerStream => _timerController.stream;
  Stream<int> get sessionsStream => _sessionsController.stream;
  Stream<PomodoroPhase> get phaseStream => _phaseController.stream;
  
  // Initialize service
  Future<void> initialize() async {
    await _loadSettings();
    await _loadStats();
  }
  
  // Update settings
  void updateSettings({
    int? studyDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
  }) {
    _studyDuration = studyDuration ?? _studyDuration;
    _shortBreakDuration = shortBreakDuration ?? _shortBreakDuration;
    _longBreakDuration = longBreakDuration ?? _longBreakDuration;
    _soundEnabled = soundEnabled ?? _soundEnabled;
    _vibrationEnabled = vibrationEnabled ?? _vibrationEnabled;
    _notificationsEnabled = notificationsEnabled ?? _notificationsEnabled;
    
    _saveSettings();
  }
  
  // Start a study session
  Future<void> startStudySession() async {
    if (_currentState == PomodoroState.paused && _remainingSeconds > 0) {
      // Resume paused session
      _resumeTimer();
    } else {
      // Start new session
      _currentState = PomodoroState.studySession;
      _remainingSeconds = _studyDuration * 60;
      _sessionStartTime = DateTime.now();
      _startTimer();
      _phaseController.add(PomodoroPhase.work);
    }
    
    _stateController.add(_currentState);
    _timerController.add(_remainingSeconds);
  }
  
  // Start break (short or long)
  Future<void> startBreak() async {
    final isLongBreak = (_completedSessions % _longBreakInterval == 0) && _completedSessions > 0;
    
    _currentState = isLongBreak ? PomodoroState.longBreak : PomodoroState.shortBreak;
    _remainingSeconds = (isLongBreak ? _longBreakDuration : _shortBreakDuration) * 60;
      _phaseController.add(PomodoroPhase.rest);
    
    _startTimer();
    _stateController.add(_currentState);
    _timerController.add(_remainingSeconds);
    
    if (_notificationsEnabled) {
      _showNotification(
        'Break Time!',
        isLongBreak 
          ? 'Take a long break for $_longBreakDuration minutes'
          : 'Take a short break for $_shortBreakDuration minutes',
      );
    }
    
    if (_vibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
  }
  
  // Pause timer
  void pauseTimer() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
      _currentState = PomodoroState.paused;
      _stateController.add(_currentState);
    }
  }
  
  // Resume timer
  void resumeTimer() {
    if (_currentState == PomodoroState.paused) {
      _resumeTimer();
    }
  }
  
  // Stop current session
  void stopSession() {
    _timer?.cancel();
    _currentState = PomodoroState.idle;
    _remainingSeconds = 0;
    _sessionStartTime = null;
    
    _stateController.add(_currentState);
    _timerController.add(_remainingSeconds);
  }
  
  // Reset all stats
  Future<void> resetStats() async {
    _completedSessions = 0;
    _totalSessions = 0;
    await _saveStats();
    _sessionsController.add(_completedSessions);
  }
  
  // Private methods
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      _timerController.add(_remainingSeconds);
      
      if (_remainingSeconds <= 0) {
        _onTimerComplete();
      }
    });
  }
  
  void _resumeTimer() {
    if (_currentState == PomodoroState.paused) {
      // Determine the correct state to resume to based on remaining time context
      _currentState = PomodoroState.studySession; // Default to study session
    }
    _startTimer();
    _stateController.add(_currentState);
  }
  
  void _onTimerComplete() {
    _timer?.cancel();
    
    if (_currentState == PomodoroState.studySession) {
      // Study session completed
      _completedSessions++;
      _totalSessions++;
      _saveStats();
      _sessionsController.add(_completedSessions);
      
      if (_notificationsEnabled) {
        _showNotification(
          'Study Session Complete!',
          'Great job! You completed a $_studyDuration minute study session.',
        );
      }
      
      if (_vibrationEnabled) {
        HapticFeedback.heavyImpact();
      }
      
      // Automatically start break
      startBreak();
    } else {
      // Break completed
      _currentState = PomodoroState.idle;
      _stateController.add(_currentState);
      
      if (_notificationsEnabled) {
        _showNotification(
          'Break Complete!',
          'Ready for another study session?',
        );
      }
      
      if (_vibrationEnabled) {
        HapticFeedback.mediumImpact();
      }
    }
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _studyDuration = prefs.getInt('pomodoro_study_duration') ?? 25;
      _shortBreakDuration = prefs.getInt('pomodoro_short_break') ?? 5;
      _longBreakDuration = prefs.getInt('pomodoro_long_break') ?? 15;
      _soundEnabled = prefs.getBool('pomodoro_sound') ?? true;
      _vibrationEnabled = prefs.getBool('pomodoro_vibration') ?? true;
      _notificationsEnabled = prefs.getBool('pomodoro_notifications') ?? true;
    } catch (e) {
      print('Error loading Pomodoro settings: $e');
    }
  }
  
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('pomodoro_study_duration', _studyDuration);
      await prefs.setInt('pomodoro_short_break', _shortBreakDuration);
      await prefs.setInt('pomodoro_long_break', _longBreakDuration);
      await prefs.setBool('pomodoro_sound', _soundEnabled);
      await prefs.setBool('pomodoro_vibration', _vibrationEnabled);
      await prefs.setBool('pomodoro_notifications', _notificationsEnabled);
    } catch (e) {
      print('Error saving Pomodoro settings: $e');
    }
  }
  
  Future<void> _loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _completedSessions = prefs.getInt('pomodoro_completed_sessions') ?? 0;
      _totalSessions = prefs.getInt('pomodoro_total_sessions') ?? 0;
      _sessionsController.add(_completedSessions);
    } catch (e) {
      print('Error loading Pomodoro stats: $e');
    }
  }
  
  Future<void> _saveStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('pomodoro_completed_sessions', _completedSessions);
      await prefs.setInt('pomodoro_total_sessions', _totalSessions);
    } catch (e) {
      print('Error saving Pomodoro stats: $e');
    }
  }
  
  void _showNotification(String title, String body) {
    // In a real app, you would use flutter_local_notifications
    // For now, this is a placeholder
    print('Notification: $title - $body');
  }
  
  // Dispose resources
  void dispose() {
    _timer?.cancel();
    _stateController.close();
    _timerController.close();
    _sessionsController.close();
    _phaseController.close();
  }
  
  // Get formatted time string
  String getFormattedTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Get progress percentage (0.0 to 1.0)
  double getProgress() {
    if (_currentState == PomodoroState.idle) return 0.0;
    
    final totalDuration = _currentState == PomodoroState.studySession
        ? _studyDuration * 60
        : (_currentState == PomodoroState.longBreak ? _longBreakDuration : _shortBreakDuration) * 60;
    
    return 1.0 - (_remainingSeconds / totalDuration);
  }
}
