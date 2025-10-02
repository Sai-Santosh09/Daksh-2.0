# Authentication Setup

## Current Implementation

The app currently uses a **simplified authentication system** for demo purposes that simulates Google Sign-In and email/password authentication without requiring Firebase setup.

### Features Implemented:

1. **Login Page** (`/login`)
   - Google Sign-In button (simulated)
   - Email sign-up option
   - Guest access option
   - Beautiful UI with gradients

2. **Sign-up Page** (`/signup`)
   - Complete registration form
   - Form validation
   - Google sign-up option
   - Terms and conditions

3. **Profile Setup Page** (`/profile-setup`)
   - State selection (36 Indian states/UTs)
   - Language selection (13 Indian languages)
   - User profile display
   - Skip option

4. **Authentication Flow**
   - Splash screen → Login → Profile Setup → Main App
   - Persistent user sessions
   - State management with Riverpod

### How It Works:

- **Google Sign-In**: Simulates successful authentication with demo user data
- **Email/Password**: Creates user account with provided details
- **Profile Setup**: Saves state and language preferences
- **Session Management**: Uses SharedPreferences for persistence

### To Enable Real Google Authentication:

1. **Add Firebase Dependencies**:
   ```yaml
   google_sign_in: ^6.2.1
   firebase_auth: ^4.15.3
   firebase_core: ^2.24.2
   ```

2. **Initialize Firebase** in `main.dart`:
   ```dart
   await Firebase.initializeApp();
   ```

3. **Update AuthService** to use real Firebase Auth methods

4. **Configure Firebase Project**:
   - Create Firebase project
   - Enable Google Sign-In
   - Add web configuration
   - Update `web/firebase-config.js`

### Current Demo Data:

- **Google User**: user@gmail.com, Demo User
- **Profile Image**: Placeholder image
- **States**: All 36 Indian states and union territories
- **Languages**: 13 Indian languages with native scripts

The authentication system is fully functional for demo purposes and provides a complete user experience flow! 🎉





