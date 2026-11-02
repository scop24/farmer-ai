/// Every user-facing string of the app lives in this one file so the
/// whole UI can later be translated (Hindi first) without hunting
/// through widget code. Values are English for the demo build.
class AppStrings {
  AppStrings._();

  // General
  static const String appName = 'KisanSathi';
  static const String demoBadge = 'Demo data';

  // Welcome / language
  static const String welcomeTagline =
      'Crop prices, crop health and farming help — in your language.';
  static const String chooseLanguage = 'Choose your language';
  static const String continueLabel = 'Continue';

  // Bottom navigation
  static const String navHome = 'Home';
  static const String navPrices = 'Prices';
  static const String navScan = 'Scan';
  static const String navVoice = 'Voice';

  // Home
  static const String greeting = 'Namaste, Farmer';
  static const String greetingSub = 'Here is today\'s mandi update for you.';
  static const String forecastTitle = 'Price forecast';
  static const String todaysPrices = 'Today\'s prices';
  static const String quickActions = 'Quick actions';
  static const String actionScan = 'Scan Crop';
  static const String actionPrices = 'Crop Prices';
  static const String actionVoice = 'Voice Assistant';
  static const String perQuintal = '/quintal';

  // Prices
  static const String pricesTitle = 'Crop Prices';
  static const String searchHint = 'Search crop';
  static const String noPricesMatch = 'No crops match your search.';
  static const String updatedToday = 'Updated today (demo)';

  // Scan
  static const String scanTitle = 'Scan Crop';
  static const String cameraPlaceholder = 'Your leaf photo will appear here';
  static const String takePhoto = 'Take photo';
  static const String retakePhoto = 'Retake photo';
  static const String scanStepsTitle = 'How to scan';
  static const String step1 = 'Take a clear photo of the affected leaf';
  static const String step2 = 'Keep the leaf in daylight, avoid shadows';
  static const String step3 = 'Tap Analyze and wait a few seconds';
  static const String scanTip =
      'Tip: Fill the frame with one leaf. A clear photo gives a better result.';
  static const String analyzeButton = 'Analyze leaf photo';
  static const String analyzing = 'Analyzing your crop...';
  static const String lowConfidenceDemo = 'Demo: low-confidence result';

  // Diagnosis
  static const String diagnosisTitle = 'Diagnosis Result';
  static const String confidenceLabel = 'Confidence';
  static const String treatmentTitle = 'What you can do';
  static const String uncertainTitle = 'Result is uncertain';
  static const String uncertainBody =
      'We could not identify the problem clearly from this photo. Please '
      'retake the photo in daylight. If the problem continues, please show '
      'the plant to your nearest agriculture expert or Krishi Vigyan Kendra.';
  static const String scanAnother = 'Scan another leaf';

  /// This note is ALWAYS shown on the diagnosis screen, word for word.
  static const String expertNote =
      'This is AI guidance for demo purposes. Please confirm with a local '
      'agriculture expert before using any medicine.';

  // Voice assistant
  static const String voiceTitle = 'Voice Assistant';
  static const String voiceHint = 'Ask about prices, weather or crop problems';
  static const String listening = 'Listening...';
  static const String tapMic = 'Tap the mic and speak';
  static const String voiceUnavailable =
      'Voice is not available in this browser — please type your question';
  static const String typeHint = 'Type your question';
}
