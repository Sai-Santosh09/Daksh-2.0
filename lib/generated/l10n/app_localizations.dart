import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Daksh'**
  String get appTitle;

  /// Welcome message displayed on the learn page
  ///
  /// In en, this message translates to:
  /// **'Welcome to Daksh!'**
  String get welcomeMessage;

  /// Button text to start learning
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// Title for grammar categories section
  ///
  /// In en, this message translates to:
  /// **'Grammar Categories'**
  String get grammarCategories;

  /// Category name for parts of speech
  ///
  /// In en, this message translates to:
  /// **'Parts of Speech'**
  String get partsOfSpeech;

  /// Description for parts of speech category
  ///
  /// In en, this message translates to:
  /// **'Learn about nouns, verbs, adjectives, and more.'**
  String get partsOfSpeechDescription;

  /// Category name for sentence structure
  ///
  /// In en, this message translates to:
  /// **'Sentence Structure'**
  String get sentenceStructure;

  /// Description for sentence structure category
  ///
  /// In en, this message translates to:
  /// **'Master sentence formation and grammar rules.'**
  String get sentenceStructureDescription;

  /// Category name for tenses
  ///
  /// In en, this message translates to:
  /// **'Tenses'**
  String get tenses;

  /// Description for tenses category
  ///
  /// In en, this message translates to:
  /// **'Understand past, present, and future tenses.'**
  String get tensesDescription;

  /// Category name for punctuation
  ///
  /// In en, this message translates to:
  /// **'Punctuation'**
  String get punctuation;

  /// Description for punctuation category
  ///
  /// In en, this message translates to:
  /// **'Learn proper punctuation usage.'**
  String get punctuationDescription;

  /// Title for recent lessons section
  ///
  /// In en, this message translates to:
  /// **'Recent Lessons'**
  String get recentLessons;

  /// Generic lesson text
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get lesson;

  /// Basic grammar lesson title
  ///
  /// In en, this message translates to:
  /// **'Basic Grammar'**
  String get basicGrammar;

  /// Status text for completed items
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Time ago text with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Today} =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// Learn tab label
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// Practice tab label
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// Assess tab label
  ///
  /// In en, this message translates to:
  /// **'Assess'**
  String get assess;

  /// Downloads tab label
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Search functionality label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Search lessons tooltip
  ///
  /// In en, this message translates to:
  /// **'Search lessons'**
  String get searchLessons;

  /// Practice progress section title
  ///
  /// In en, this message translates to:
  /// **'Practice Progress'**
  String get practiceProgress;

  /// Label for completed exercises count
  ///
  /// In en, this message translates to:
  /// **'Exercises Completed'**
  String get exercisesCompleted;

  /// Label for practice streak
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// Days count with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String days(int count);

  /// Quick practice option
  ///
  /// In en, this message translates to:
  /// **'Quick Practice'**
  String get quickPractice;

  /// Description for quick practice
  ///
  /// In en, this message translates to:
  /// **'Short exercises for daily practice'**
  String get quickPracticeDescription;

  /// Focused practice option
  ///
  /// In en, this message translates to:
  /// **'Focused Practice'**
  String get focusedPractice;

  /// Description for focused practice
  ///
  /// In en, this message translates to:
  /// **'Target specific grammar areas'**
  String get focusedPracticeDescription;

  /// Challenge mode option
  ///
  /// In en, this message translates to:
  /// **'Challenge Mode'**
  String get challengeMode;

  /// Description for challenge mode
  ///
  /// In en, this message translates to:
  /// **'Test your skills with difficult exercises'**
  String get challengeModeDescription;

  /// Recent practice section title
  ///
  /// In en, this message translates to:
  /// **'Recent Practice'**
  String get recentPractice;

  /// Practice session label
  ///
  /// In en, this message translates to:
  /// **'Practice Session'**
  String get practiceSession;

  /// Score label
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Assessment center title
  ///
  /// In en, this message translates to:
  /// **'Assessment Center'**
  String get assessmentCenter;

  /// Assessment center description
  ///
  /// In en, this message translates to:
  /// **'Test your grammar knowledge and track your progress with comprehensive assessments.'**
  String get testYourKnowledge;

  /// Current level section title
  ///
  /// In en, this message translates to:
  /// **'Current Level'**
  String get currentLevel;

  /// Intermediate difficulty level
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// Current level description
  ///
  /// In en, this message translates to:
  /// **'Based on your recent performance'**
  String get basedOnPerformance;

  /// Available assessments section title
  ///
  /// In en, this message translates to:
  /// **'Available Assessments'**
  String get availableAssessments;

  /// Quick assessment option
  ///
  /// In en, this message translates to:
  /// **'Quick Assessment'**
  String get quickAssessment;

  /// Quick assessment description
  ///
  /// In en, this message translates to:
  /// **'5-10 minutes • Basic grammar knowledge'**
  String get quickAssessmentDescription;

  /// Comprehensive test option
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Test'**
  String get comprehensiveTest;

  /// Comprehensive test description
  ///
  /// In en, this message translates to:
  /// **'30-45 minutes • Full grammar evaluation'**
  String get comprehensiveTestDescription;

  /// Skill-specific test option
  ///
  /// In en, this message translates to:
  /// **'Skill-Specific Test'**
  String get skillSpecificTest;

  /// Skill-specific test description
  ///
  /// In en, this message translates to:
  /// **'15-20 minutes • Focus on specific areas'**
  String get skillSpecificTestDescription;

  /// Start button text
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Choose area button text
  ///
  /// In en, this message translates to:
  /// **'Choose Area'**
  String get chooseArea;

  /// Recent assessments section title
  ///
  /// In en, this message translates to:
  /// **'Recent Assessments'**
  String get recentAssessments;

  /// Storage overview section title
  ///
  /// In en, this message translates to:
  /// **'Storage Overview'**
  String get storageOverview;

  /// Downloaded lessons label
  ///
  /// In en, this message translates to:
  /// **'Downloaded Lessons'**
  String get downloadedLessons;

  /// Storage used label
  ///
  /// In en, this message translates to:
  /// **'Storage Used'**
  String get storageUsed;

  /// Available for download section title
  ///
  /// In en, this message translates to:
  /// **'Available for Download'**
  String get availableForDownload;

  /// Complete grammar course title
  ///
  /// In en, this message translates to:
  /// **'Complete Grammar Course'**
  String get completeGrammarCourse;

  /// Complete course description
  ///
  /// In en, this message translates to:
  /// **'All lessons and exercises'**
  String get allLessonsAndExercises;

  /// Practice exercises pack title
  ///
  /// In en, this message translates to:
  /// **'Practice Exercises Pack'**
  String get practiceExercisesPack;

  /// Practice pack description
  ///
  /// In en, this message translates to:
  /// **'Offline practice materials'**
  String get offlinePracticeMaterials;

  /// Assessment tests title
  ///
  /// In en, this message translates to:
  /// **'Assessment Tests'**
  String get assessmentTests;

  /// Assessment tests description
  ///
  /// In en, this message translates to:
  /// **'Offline assessment materials'**
  String get offlineAssessmentMaterials;

  /// Size label
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// Downloaded status
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get downloaded;

  /// Download button text
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Downloaded content section title
  ///
  /// In en, this message translates to:
  /// **'Downloaded Content'**
  String get downloadedContent;

  /// Downloaded date text
  ///
  /// In en, this message translates to:
  /// **'Downloaded {date}'**
  String downloadedOn(String date);

  /// Play button text
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Download settings section title
  ///
  /// In en, this message translates to:
  /// **'Download Settings'**
  String get downloadSettings;

  /// Wi-Fi only download setting
  ///
  /// In en, this message translates to:
  /// **'Download over Wi-Fi only'**
  String get downloadOverWifiOnly;

  /// Wi-Fi only setting description
  ///
  /// In en, this message translates to:
  /// **'Save mobile data by downloading only on Wi-Fi'**
  String get saveMobileData;

  /// Auto-download setting
  ///
  /// In en, this message translates to:
  /// **'Auto-download new content'**
  String get autoDownloadNewContent;

  /// Auto-download setting description
  ///
  /// In en, this message translates to:
  /// **'Automatically download new lessons when available'**
  String get automaticallyDownloadNewLessons;

  /// Profile section title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// App settings section title
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// Theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightTheme;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Hindi language option
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get hindi;

  /// Telugu language option
  ///
  /// In en, this message translates to:
  /// **'తెలుగు'**
  String get telugu;

  /// Audio settings
  ///
  /// In en, this message translates to:
  /// **'Audio Settings'**
  String get audioSettings;

  /// Audio settings description
  ///
  /// In en, this message translates to:
  /// **'Sound effects and voice'**
  String get soundEffectsAndVoice;

  /// Notifications setting
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications description
  ///
  /// In en, this message translates to:
  /// **'Practice reminders'**
  String get practiceReminders;

  /// Learning preferences section title
  ///
  /// In en, this message translates to:
  /// **'Learning Preferences'**
  String get learningPreferences;

  /// Daily goal setting
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// Minutes per day text
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes per day'**
  String minutesPerDay(int minutes);

  /// Practice reminder time
  ///
  /// In en, this message translates to:
  /// **'Every day at {time}'**
  String everyDayAt(String time);

  /// Difficulty level setting
  ///
  /// In en, this message translates to:
  /// **'Difficulty Level'**
  String get difficultyLevel;

  /// Data and privacy section title
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataAndPrivacy;

  /// Download data option
  ///
  /// In en, this message translates to:
  /// **'Download Data'**
  String get downloadData;

  /// Download data description
  ///
  /// In en, this message translates to:
  /// **'Export your learning progress'**
  String get exportYourProgress;

  /// Delete account option
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Delete account description
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account'**
  String get permanentlyDeleteAccount;

  /// Support and info section title
  ///
  /// In en, this message translates to:
  /// **'Support & Info'**
  String get supportAndInfo;

  /// Help and support option
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// Help and support description
  ///
  /// In en, this message translates to:
  /// **'Get help and contact support'**
  String get getHelpAndContactSupport;

  /// About option
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version text
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// Rate app option
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// Rate app description
  ///
  /// In en, this message translates to:
  /// **'Rate us on the app store'**
  String get rateUsOnAppStore;

  /// Edit profile tooltip
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Page not found error title
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFound;

  /// Page not found error message
  ///
  /// In en, this message translates to:
  /// **'Page not found: {location}'**
  String pageNotFoundMessage(String location);

  /// Go home button text
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
