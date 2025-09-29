// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'app_localizations.dart';

class messages_te extends messages {
  @override
  String get localeName => 'te';

  static messages_te? _current;

  static messages_te get messages {
    _current ??= messages_te();
    return _current!;
  }

  @override
  String get appTitle => 'దక్ష్';

  @override
  String get welcomeMessage => 'దక్ష్‌కు స్వాగతం!';

  @override
  String get startLearning => 'నేర్చుకోవడం ప్రారంభించండి';

  @override
  String get grammarCategories => 'వ్యాకరణ వర్గాలు';

  @override
  String get partsOfSpeech => 'పదజాలం';

  @override
  String get partsOfSpeechDescription => 'నామవాచకాలు, క్రియలు, విశేషణాలు మరియు మరిన్ని గురించి తెలుసుకోండి.';

  @override
  String get sentenceStructure => 'వాక్య నిర్మాణం';

  @override
  String get sentenceStructureDescription => 'వాక్య నిర్మాణం మరియు వ్యాకరణ నియమాలను నేర్చుకోండి.';

  @override
  String get tenses => 'కాలాలు';

  @override
  String get tensesDescription => 'భూత, వర్తమాన మరియు భవిష్యత్ కాలాలను అర్థం చేసుకోండి.';

  @override
  String get punctuation => 'విరామ చిహ్నాలు';

  @override
  String get punctuationDescription => 'సరైన విరామ చిహ్నాల వాడకాన్ని నేర్చుకోండి.';

  @override
  String get recentLessons => 'ఇటీవలి పాఠాలు';

  @override
  String get lesson => 'పాఠం';

  @override
  String get basicGrammar => 'ప్రాథమిక వ్యాకరణం';

  @override
  String get completed => 'పూర్తయింది';

  @override
  String daysAgo(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      zero: 'ఈరోజు',
      one: '1 రోజు క్రితం',
      other: '$count రోజులు క్రితం',
    );
  }

  @override
  String get learn => 'నేర్చుకోండి';

  @override
  String get practice => 'అభ్యాసం';

  @override
  String get assess => 'మూల్యాంకనం';

  @override
  String get downloads => 'డౌన్‌లోడ్‌లు';

  @override
  String get settings => 'సెట్టింగ్‌లు';

  @override
  String get search => 'వెతకండి';

  @override
  String get searchLessons => 'పాఠాలను వెతకండి';

  @override
  String get practiceProgress => 'అభ్యాస పురోగతి';

  @override
  String get exercisesCompleted => 'పూర్తయిన వ్యాయామాలు';

  @override
  String get streak => 'వరుస';

  @override
  String days(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '1 రోజు',
      other: '$count రోజులు',
    );
  }

  @override
  String get quickPractice => 'త్వరిత అభ్యాసం';

  @override
  String get quickPracticeDescription => 'రోజువారీ అభ్యాసానికి చిన్న వ్యాయామాలు';

  @override
  String get focusedPractice => 'కేంద్రీకృత అభ్యాసం';

  @override
  String get focusedPracticeDescription => 'నిర్దిష్ట వ్యాకరణ ప్రాంతాలను లక్ష్యంగా చేసుకోండి';

  @override
  String get challengeMode => 'సవాల్ మోడ్';

  @override
  String get challengeModeDescription => 'కష్టమైన వ్యాయామాలతో మీ నైపుణ్యాలను పరీక్షించండి';

  @override
  String get recentPractice => 'ఇటీవలి అభ్యాసం';

  @override
  String get practiceSession => 'అభ్యాస సెషన్';

  @override
  String get score => 'స్కోరు';

  @override
  String get assessmentCenter => 'మూల్యాంకన కేంద్రం';

  @override
  String get testYourKnowledge => 'మీ వ్యాకరణ జ్ఞానాన్ని పరీక్షించండి మరియు సమగ్ర మూల్యాంకనలతో మీ పురోగతిని ట్రాక్ చేయండి.';

  @override
  String get currentLevel => 'ప్రస్తుత స్థాయి';

  @override
  String get intermediate => 'మధ్యస్థ';

  @override
  String get basedOnPerformance => 'మీ ఇటీవలి పనితీరు ఆధారంగా';

  @override
  String get availableAssessments => 'అందుబాటులో ఉన్న మూల్యాంకనలు';

  @override
  String get quickAssessment => 'త్వరిత మూల్యాంకనం';

  @override
  String get quickAssessmentDescription => '5-10 నిమిషాలు • ప్రాథమిక వ్యాకరణ జ్ఞానం';

  @override
  String get comprehensiveTest => 'సమగ్ర పరీక్ష';

  @override
  String get comprehensiveTestDescription => '30-45 నిమిషాలు • పూర్తి వ్యాకరణ మూల్యాంకనం';

  @override
  String get skillSpecificTest => 'నైపుణ్య-నిర్దిష్ట పరీక్ష';

  @override
  String get skillSpecificTestDescription => '15-20 నిమిషాలు • నిర్దిష్ట ప్రాంతాలపై దృష్టి పెట్టండి';

  @override
  String get start => 'ప్రారంభించండి';

  @override
  String get chooseArea => 'ప్రాంతాన్ని ఎంచుకోండి';

  @override
  String get recentAssessments => 'ఇటీవలి మూల్యాంకనలు';

  @override
  String get storageOverview => 'నిల్వ అవలోకనం';

  @override
  String get downloadedLessons => 'డౌన్‌లోడ్ చేసిన పాఠాలు';

  @override
  String get storageUsed => 'వాడిన నిల్వ';

  @override
  String get availableForDownload => 'డౌన్‌లోడ్ కోసం అందుబాటులో ఉంది';

  @override
  String get completeGrammarCourse => 'పూర్తి వ్యాకరణ కోర్సు';

  @override
  String get allLessonsAndExercises => 'అన్ని పాఠాలు మరియు వ్యాయామాలు';

  @override
  String get practiceExercisesPack => 'అభ్యాస వ్యాయామ ప్యాక్';

  @override
  String get offlinePracticeMaterials => 'ఆఫ్‌లైన్ అభ్యాస సామగ్రి';

  @override
  String get assessmentTests => 'మూల్యాంకన పరీక్షలు';

  @override
  String get offlineAssessmentMaterials => 'ఆఫ్‌లైన్ మూల్యాంకన సామగ్రి';

  @override
  String get size => 'పరిమాణం';

  @override
  String get downloaded => 'డౌన్‌లోడ్ చేయబడింది';

  @override
  String get download => 'డౌన్‌లోడ్ చేయండి';

  @override
  String get downloadedContent => 'డౌన్‌లోడ్ చేసిన కంటెంట్';

  @override
  String downloadedOn(String date) {
    return '$dateన డౌన్‌లోడ్ చేయబడింది';
  }

  @override
  String get play => 'ప్లే చేయండి';

  @override
  String get delete => 'తొలగించండి';

  @override
  String get downloadSettings => 'డౌన్‌లోడ్ సెట్టింగ్‌లు';

  @override
  String get downloadOverWifiOnly => 'Wi-Fi మాత్రమే డౌన్‌లోడ్ చేయండి';

  @override
  String get saveMobileData => 'Wi-Fi మాత్రమే డౌన్‌లోడ్ చేసి మొబైల్ డేటాను ఆదా చేయండి';

  @override
  String get autoDownloadNewContent => 'కొత్త కంటెంట్‌ను స్వయంచాలకంగా డౌన్‌లోడ్ చేయండి';

  @override
  String get automaticallyDownloadNewLessons => 'అందుబాటులో ఉన్నప్పుడు కొత్త పాఠాలను స్వయంచాలకంగా డౌన్‌లోడ్ చేయండి';

  @override
  String get profile => 'ప్రొఫైల్';

  @override
  String get appSettings => 'అనువర్తన సెట్టింగ్‌లు';

  @override
  String get theme => 'థీమ్';

  @override
  String get lightTheme => 'తేలికైన థీమ్';

  @override
  String get language => 'భాష';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिंदी';

  @override
  String get telugu => 'తెలుగు';

  @override
  String get audioSettings => 'ఆడియో సెట్టింగ్‌లు';

  @override
  String get soundEffectsAndVoice => 'ధ్వని ప్రభావాలు మరియు వాయిస్';

  @override
  String get notifications => 'నోటిఫికేషన్‌లు';

  @override
  String get practiceReminders => 'అభ్యాస గుర్తుకు తెచ్చేవి';

  @override
  String get learningPreferences => 'అభ్యాస ప్రాధాన్యతలు';

  @override
  String get dailyGoal => 'రోజువారీ లక్ష్యం';

  @override
  String minutesPerDay(int minutes) {
    return 'రోజుకు $minutes నిమిషాలు';
  }

  @override
  String get practiceReminders => 'అభ్యాస గుర్తుకు తెచ్చేవి';

  @override
  String everyDayAt(String time) {
    return 'ప్రతిరోజు $timeకు';
  }

  @override
  String get difficultyLevel => 'కష్టత స్థాయి';

  @override
  String get dataAndPrivacy => 'డేటా మరియు గోప్యత';

  @override
  String get downloadData => 'డేటాను డౌన్‌లోడ్ చేయండి';

  @override
  String get exportYourProgress => 'మీ అభ్యాస పురోగతిని ఎగుమతి చేయండి';

  @override
  String get deleteAccount => 'ఖాతాను తొలగించండి';

  @override
  String get permanentlyDeleteAccount => 'మీ ఖాతాను శాశ్వతంగా తొలగించండి';

  @override
  String get supportAndInfo => 'మద్దతు మరియు సమాచారం';

  @override
  String get helpAndSupport => 'సహాయం మరియు మద్దతు';

  @override
  String get getHelpAndContactSupport => 'సహాయం పొందండి మరియు మద్దతుతో సంప్రదించండి';

  @override
  String get about => 'గురించి';

  @override
  String version(String version) {
    return 'వెర్షన్ $version';
  }

  @override
  String get rateApp => 'అనువర్తనాన్ని రేట్ చేయండి';

  @override
  String get rateUsOnAppStore => 'అనువర్తన స్టోర్‌లో మమ్మల్ని రేట్ చేయండి';

  @override
  String get editProfile => 'ప్రొఫైల్‌ను సవరించండి';

  @override
  String get tryAgain => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get pageNotFound => 'పేజీ కనుగొనబడలేదు';

  @override
  String pageNotFoundMessage(String location) {
    return 'పేజీ కనుగొనబడలేదు: $location';
  }

  @override
  String get goHome => 'హోమ్‌కు వెళ్లండి';

  @override
  String get cancel => 'రద్దు చేయండి';
}

abstract class messages extends AppLocalizations {
  @override
  String get localeName => 'te';
}


