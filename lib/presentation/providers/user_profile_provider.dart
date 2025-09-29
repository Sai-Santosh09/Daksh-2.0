import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../data/services/user_profile_service.dart';

// User profile provider
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfileEntity?>((ref) {
  return UserProfileNotifier();
});

class UserProfileNotifier extends StateNotifier<UserProfileEntity?> {
  UserProfileNotifier() : super(null) {
    _loadProfile();
  }

  // Load profile from storage
  Future<void> _loadProfile() async {
    try {
      final profile = await UserProfileService.getUserProfile();
      if (profile != null) {
        state = profile;
      } else {
        // Create default profile for new users
        final defaultProfile = await UserProfileService.createDefaultProfile();
        state = defaultProfile;
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  // Update profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? school,
    int? currentClass,
    List<String>? interests,
  }) async {
    try {
      final updatedProfile = await UserProfileService.updateProfile(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        dateOfBirth: dateOfBirth,
        school: school,
        currentClass: currentClass,
        interests: interests,
      );

      if (updatedProfile != null) {
        state = updatedProfile;
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // Refresh profile
  Future<void> refreshProfile() async {
    await _loadProfile();
  }

  // Clear profile
  Future<void> clearProfile() async {
    await UserProfileService.deleteUserProfile();
    state = null;
  }
}


