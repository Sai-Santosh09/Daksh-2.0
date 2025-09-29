import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';

class AuthService {
  static const String _userKey = 'user_data';

  // Get current user
  static UserEntity? _currentUser;

  // Sign in with Google (simplified for demo)
  static Future<UserEntity?> signInWithGoogle() async {
    try {
      // Simulate Google sign-in for demo purposes
      // In a real app, you would implement actual Google Sign-In
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      final userEntity = UserEntity(
        id: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user@gmail.com',
        name: 'Demo User',
        profileImageUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save user data locally
      await _saveUserData(userEntity);
      _currentUser = userEntity;
      
      return userEntity;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Sign in with email and password (simplified)
  static Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Simulate email/password sign-in for demo purposes
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      final userEntity = UserEntity(
        id: 'email_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save user data locally
      await _saveUserData(userEntity);
      _currentUser = userEntity;
      
      return userEntity;
    } catch (e) {
      print('Error signing in with email: $e');
      return null;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      _currentUser = null;
      await _clearUserData();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Get saved user data
  static Future<UserEntity?> getSavedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      
      if (userData != null) {
        // Parse user data from JSON (simplified for now)
        // In a real app, you'd use proper JSON serialization
        return _parseUserData(userData);
      }
      
      return null;
    } catch (e) {
      print('Error getting saved user data: $e');
      return null;
    }
  }

  // Get current user (for compatibility)
  static UserEntity? get currentUser => _currentUser;

  // Save user data locally
  static Future<void> _saveUserData(UserEntity user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = _serializeUserData(user);
      await prefs.setString(_userKey, userData);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Clear user data
  static Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  // Update user profile
  static Future<void> updateUserProfile({
    String? state,
    String? language,
  }) async {
    try {
      final currentUser = await getSavedUserData();
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          state: state,
          language: language,
          updatedAt: DateTime.now(),
        );
        await _saveUserData(updatedUser);
      }
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  // Simple serialization (in a real app, use proper JSON serialization)
  static String _serializeUserData(UserEntity user) {
    return '${user.id}|${user.email}|${user.name}|${user.profileImageUrl ?? ''}|${user.state ?? ''}|${user.language ?? ''}|${user.createdAt?.millisecondsSinceEpoch ?? 0}|${user.updatedAt?.millisecondsSinceEpoch ?? 0}';
  }

  static UserEntity? _parseUserData(String data) {
    try {
      final parts = data.split('|');
      if (parts.length >= 8) {
        return UserEntity(
          id: parts[0],
          email: parts[1],
          name: parts[2],
          profileImageUrl: parts[3].isEmpty ? null : parts[3],
          state: parts[4].isEmpty ? null : parts[4],
          language: parts[5].isEmpty ? null : parts[5],
          createdAt: parts[6] == '0' ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(parts[6])),
          updatedAt: parts[7] == '0' ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(parts[7])),
        );
      }
    } catch (e) {
      print('Error parsing user data: $e');
    }
    return null;
  }
}
