import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/services/auth_service.dart';

// Auth state
class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get isAuthenticated => user != null;
  bool get hasCompletedProfile => user?.state != null && user?.language != null;
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Check if user is already signed in
      final savedUser = await AuthService.getSavedUserData();
      if (savedUser != null) {
        state = state.copyWith(user: savedUser, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to initialize authentication: $e',
        isLoading: false,
      );
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await AuthService.signInWithGoogle();
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          error: 'Sign in was cancelled or failed',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Sign in failed: $e',
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await AuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          error: 'Sign up failed',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Sign up failed: $e',
        isLoading: false,
      );
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await AuthService.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        error: 'Sign out failed: $e',
        isLoading: false,
      );
    }
  }

  Future<void> updateProfile({
    String? state,
    String? language,
  }) async {
    if (this.state.user == null) return;
    
    try {
      await AuthService.updateUserProfile(
        state: state,
        language: language,
      );
      
      // Update local state
      final updatedUser = this.state.user!.copyWith(
        state: state,
        language: language,
        updatedAt: DateTime.now(),
      );
      
      this.state = this.state.copyWith(user: updatedUser);
    } catch (e) {
      this.state = this.state.copyWith(
        error: 'Failed to update profile: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final hasCompletedProfileProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).hasCompletedProfile;
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authProvider).user;
});
