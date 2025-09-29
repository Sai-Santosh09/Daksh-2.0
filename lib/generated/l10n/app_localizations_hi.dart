// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'दक्ष';

  @override
  String get welcomeMessage => 'दक्ष में आपका स्वागत है!';

  @override
  String get startLearning => 'सीखना शुरू करें';

  @override
  String get grammarCategories => 'व्याकरण श्रेणियां';

  @override
  String get partsOfSpeech => 'शब्द भेद';

  @override
  String get partsOfSpeechDescription =>
      'संज्ञा, क्रिया, विशेषण और अन्य के बारे में जानें।';

  @override
  String get sentenceStructure => 'वाक्य संरचना';

  @override
  String get sentenceStructureDescription =>
      'वाक्य निर्माण और व्याकरण नियमों में महारत हासिल करें।';

  @override
  String get tenses => 'काल';

  @override
  String get tensesDescription => 'भूत, वर्तमान और भविष्य काल को समझें।';

  @override
  String get punctuation => 'विराम चिह्न';

  @override
  String get punctuationDescription => 'उचित विराम चिह्न का उपयोग सीखें।';

  @override
  String get recentLessons => 'हाल के पाठ';

  @override
  String get lesson => 'पाठ';

  @override
  String get basicGrammar => 'मूल व्याकरण';

  @override
  String get completed => 'पूर्ण';

  @override
  String daysAgo(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString दिन पहले',
      one: '1 दिन पहले',
      zero: 'आज',
    );
    return '$_temp0';
  }

  @override
  String get learn => 'सीखें';

  @override
  String get practice => 'अभ्यास';

  @override
  String get assess => 'मूल्यांकन';

  @override
  String get downloads => 'डाउनलोड';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get search => 'खोजें';

  @override
  String get searchLessons => 'पाठ खोजें';

  @override
  String get practiceProgress => 'अभ्यास प्रगति';

  @override
  String get exercisesCompleted => 'पूर्ण अभ्यास';

  @override
  String get streak => 'लगातार';

  @override
  String days(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString दिन',
      one: '1 दिन',
    );
    return '$_temp0';
  }

  @override
  String get quickPractice => 'त्वरित अभ्यास';

  @override
  String get quickPracticeDescription => 'दैनिक अभ्यास के लिए छोटे अभ्यास';

  @override
  String get focusedPractice => 'केंद्रित अभ्यास';

  @override
  String get focusedPracticeDescription =>
      'विशिष्ट व्याकरण क्षेत्रों को लक्षित करें';

  @override
  String get challengeMode => 'चुनौती मोड';

  @override
  String get challengeModeDescription =>
      'कठिन अभ्यासों के साथ अपने कौशल का परीक्षण करें';

  @override
  String get recentPractice => 'हाल का अभ्यास';

  @override
  String get practiceSession => 'अभ्यास सत्र';

  @override
  String get score => 'स्कोर';

  @override
  String get assessmentCenter => 'मूल्यांकन केंद्र';

  @override
  String get testYourKnowledge =>
      'अपने व्याकरण ज्ञान का परीक्षण करें और व्यापक मूल्यांकन के साथ अपनी प्रगति को ट्रैक करें।';

  @override
  String get currentLevel => 'वर्तमान स्तर';

  @override
  String get intermediate => 'मध्यम';

  @override
  String get basedOnPerformance => 'आपके हाल के प्रदर्शन के आधार पर';

  @override
  String get availableAssessments => 'उपलब्ध मूल्यांकन';

  @override
  String get quickAssessment => 'त्वरित मूल्यांकन';

  @override
  String get quickAssessmentDescription => '5-10 मिनट • मूल व्याकरण ज्ञान';

  @override
  String get comprehensiveTest => 'व्यापक परीक्षण';

  @override
  String get comprehensiveTestDescription =>
      '30-45 मिनट • पूर्ण व्याकरण मूल्यांकन';

  @override
  String get skillSpecificTest => 'कौशल-विशिष्ट परीक्षण';

  @override
  String get skillSpecificTestDescription =>
      '15-20 मिनट • विशिष्ट क्षेत्रों पर ध्यान केंद्रित करें';

  @override
  String get start => 'शुरू करें';

  @override
  String get chooseArea => 'क्षेत्र चुनें';

  @override
  String get recentAssessments => 'हाल के मूल्यांकन';

  @override
  String get storageOverview => 'भंडारण अवलोकन';

  @override
  String get downloadedLessons => 'डाउनलोड किए गए पाठ';

  @override
  String get storageUsed => 'उपयोग किया गया भंडारण';

  @override
  String get availableForDownload => 'डाउनलोड के लिए उपलब्ध';

  @override
  String get completeGrammarCourse => 'पूर्ण व्याकरण पाठ्यक्रम';

  @override
  String get allLessonsAndExercises => 'सभी पाठ और अभ्यास';

  @override
  String get practiceExercisesPack => 'अभ्यास अभ्यास पैक';

  @override
  String get offlinePracticeMaterials => 'ऑफ़लाइन अभ्यास सामग्री';

  @override
  String get assessmentTests => 'मूल्यांकन परीक्षण';

  @override
  String get offlineAssessmentMaterials => 'ऑफ़लाइन मूल्यांकन सामग्री';

  @override
  String get size => 'आकार';

  @override
  String get downloaded => 'डाउनलोड किया गया';

  @override
  String get download => 'डाउनलोड करें';

  @override
  String get downloadedContent => 'डाउनलोड की गई सामग्री';

  @override
  String downloadedOn(String date) {
    return '$date को डाउनलोड किया गया';
  }

  @override
  String get play => 'चलाएं';

  @override
  String get delete => 'हटाएं';

  @override
  String get downloadSettings => 'डाउनलोड सेटिंग्स';

  @override
  String get downloadOverWifiOnly => 'केवल वाई-फाई पर डाउनलोड करें';

  @override
  String get saveMobileData => 'केवल वाई-फाई पर डाउनलोड करके मोबाइल डेटा बचाएं';

  @override
  String get autoDownloadNewContent =>
      'नई सामग्री को स्वचालित रूप से डाउनलोड करें';

  @override
  String get automaticallyDownloadNewLessons =>
      'उपलब्ध होने पर नए पाठों को स्वचालित रूप से डाउनलोड करें';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get appSettings => 'ऐप सेटिंग्स';

  @override
  String get theme => 'थीम';

  @override
  String get lightTheme => 'हल्की थीम';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिंदी';

  @override
  String get telugu => 'తెలుగు';

  @override
  String get audioSettings => 'ऑडियो सेटिंग्स';

  @override
  String get soundEffectsAndVoice => 'ध्वनि प्रभाव और आवाज़';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get practiceReminders => 'अभ्यास अनुस्मारक';

  @override
  String get learningPreferences => 'सीखने की प्राथमिकताएं';

  @override
  String get dailyGoal => 'दैनिक लक्ष्य';

  @override
  String minutesPerDay(int minutes) {
    return 'प्रति दिन $minutes मिनट';
  }

  @override
  String everyDayAt(String time) {
    return 'हर दिन $time बजे';
  }

  @override
  String get difficultyLevel => 'कठिनाई स्तर';

  @override
  String get dataAndPrivacy => 'डेटा और गोपनीयता';

  @override
  String get downloadData => 'डेटा डाउनलोड करें';

  @override
  String get exportYourProgress => 'अपनी सीखने की प्रगति निर्यात करें';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get permanentlyDeleteAccount => 'अपना खाता स्थायी रूप से हटाएं';

  @override
  String get supportAndInfo => 'सहायता और जानकारी';

  @override
  String get helpAndSupport => 'सहायता और समर्थन';

  @override
  String get getHelpAndContactSupport =>
      'सहायता प्राप्त करें और समर्थन से संपर्क करें';

  @override
  String get about => 'के बारे में';

  @override
  String version(String version) {
    return 'संस्करण $version';
  }

  @override
  String get rateApp => 'ऐप को रेट करें';

  @override
  String get rateUsOnAppStore => 'हमें ऐप स्टोर पर रेट करें';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get tryAgain => 'फिर से कोशिश करें';

  @override
  String get pageNotFound => 'पृष्ठ नहीं मिला';

  @override
  String pageNotFoundMessage(String location) {
    return 'पृष्ठ नहीं मिला: $location';
  }

  @override
  String get goHome => 'होम पर जाएं';

  @override
  String get cancel => 'रद्द करें';
}
