import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../models/user_profile_model.dart';

class UserProfileService {
  static const String _profileKey = 'user_profile';

  // Get user profile from local storage
  static Future<UserProfileEntity?> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      
      if (profileJson != null) {
        final profileData = json.decode(profileJson) as Map<String, dynamic>;
        return UserProfileModel.fromJson(profileData);
      }
      
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Save user profile to local storage
  static Future<bool> saveUserProfile(UserProfileEntity profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = json.encode(UserProfileModel.fromEntity(profile).toJson());
      return await prefs.setString(_profileKey, profileJson);
    } catch (e) {
      print('Error saving user profile: $e');
      return false;
    }
  }

  // Create default profile for new users
  static Future<UserProfileEntity> createDefaultProfile() async {
    final now = DateTime.now();
    final defaultProfile = UserProfileEntity(
      id: 'user_${now.millisecondsSinceEpoch}',
      name: 'Student',
      email: 'student@daksh.com',
      dateOfBirth: DateTime(2010, 1, 1), // Default age
      interests: ['english', 'math', 'science'],
      createdAt: now,
      updatedAt: now,
    );
    
    await saveUserProfile(defaultProfile);
    return defaultProfile;
  }

  // Update profile fields
  static Future<UserProfileEntity?> updateProfile({
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
      final currentProfile = await getUserProfile();
      if (currentProfile == null) return null;

      final updatedProfile = currentProfile.copyWith(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        dateOfBirth: dateOfBirth,
        school: school,
        currentClass: currentClass,
        interests: interests,
        updatedAt: DateTime.now(),
      );

      final saved = await saveUserProfile(updatedProfile);
      return saved ? updatedProfile : null;
    } catch (e) {
      print('Error updating profile: $e');
      return null;
    }
  }

  // Delete user profile
  static Future<bool> deleteUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_profileKey);
    } catch (e) {
      print('Error deleting user profile: $e');
      return false;
    }
  }
}

