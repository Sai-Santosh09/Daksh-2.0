import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/settings_entity.dart';
import '../../data/services/settings_service.dart';

// Settings state
class SettingsState {
  final SettingsEntity settings;
  final bool isLoading;
  final String? error;

  const SettingsState({
    required this.settings,
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    SettingsEntity? settings,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Settings notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState(settings: const SettingsEntity())) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final settings = await SettingsService.getSettings();
      state = state.copyWith(settings: settings, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load settings: $e',
        isLoading: false,
      );
    }
  }

  Future<void> updateSetting(String key, dynamic value) async {
    try {
      await SettingsService.updateSetting(key, value);
      final updatedSettings = await SettingsService.getSettings();
      state = state.copyWith(settings: updatedSettings);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update setting: $e',
      );
    }
  }

  Future<void> saveSettings(SettingsEntity settings) async {
    try {
      await SettingsService.saveSettings(settings);
      state = state.copyWith(settings: settings);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to save settings: $e',
      );
    }
  }

  Future<void> resetSettings() async {
    try {
      await SettingsService.resetSettings();
      state = state.copyWith(settings: const SettingsEntity());
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to reset settings: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

final currentSettingsProvider = Provider<SettingsEntity>((ref) {
  return ref.watch(settingsProvider).settings;
});

// Individual setting providers for easy access
final notificationsEnabledProvider = Provider<bool>((ref) {
  return ref.watch(currentSettingsProvider).notificationsEnabled;
});

final darkModeEnabledProvider = Provider<bool>((ref) {
  return ref.watch(currentSettingsProvider).darkModeEnabled;
});

final autoPlayVideosProvider = Provider<bool>((ref) {
  return ref.watch(currentSettingsProvider).autoPlayVideos;
});

final downloadOverWifiOnlyProvider = Provider<bool>((ref) {
  return ref.watch(currentSettingsProvider).downloadOverWifiOnly;
});

