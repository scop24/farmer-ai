// DEMO DATA ONLY.
//
// Every value in this file is mocked for the UI demo: mandi prices,
// forecasts, the diagnosis and the chat replies are NOT real and must
// never be presented to a farmer as real data. Real data sources are
// integrated in a later phase.

/// Formats a rupee amount with thousands separators, e.g. 4650 -> 4,650.
String formatRupees(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

class DemoLanguage {
  final String english;
  final String native;
  const DemoLanguage(this.english, this.native);
}

const demoLanguages = <DemoLanguage>[
  DemoLanguage('Hindi', 'हिन्दी'),
  DemoLanguage('English', 'English'),
  DemoLanguage('Marathi', 'मराठी'),
  DemoLanguage('Gujarati', 'ગુજરાતી'),
  DemoLanguage('Punjabi', 'ਪੰਜਾਬੀ'),
  DemoLanguage('Tamil', 'தமிழ்'),
  DemoLanguage('Telugu', 'తెలుగు'),
];

class DemoCropPrice {
  final String crop;
  final String mandi;
  final int pricePerQuintal;
  final double changePercent;
  final List<double> spark;
  const DemoCropPrice({
    required this.crop,
    required this.mandi,
    required this.pricePerQuintal,
    required this.changePercent,
    required this.spark,
  });
}

const demoCropPrices = <DemoCropPrice>[
  DemoCropPrice(
    crop: 'Wheat',
    mandi: 'Indore Mandi',
    pricePerQuintal: 2275,
    changePercent: 1.2,
    spark: [2210, 2230, 2245, 2240, 2260, 2268, 2275],
  ),
  DemoCropPrice(
    crop: 'Rice',
    mandi: 'Ujjain Mandi',
    pricePerQuintal: 2203,
    changePercent: 0.6,
    spark: [2180, 2188, 2195, 2190, 2198, 2200, 2203],
  ),
  DemoCropPrice(
    crop: 'Soybean',
    mandi: 'Indore Mandi',
    pricePerQuintal: 4650,
    changePercent: -0.8,
    spark: [4720, 4705, 4690, 4680, 4665, 4655, 4650],
  ),
  DemoCropPrice(
    crop: 'Cotton',
    mandi: 'Khandwa Mandi',
    pricePerQuintal: 7120,
    changePercent: 2.1,
    spark: [6950, 6980, 7010, 7050, 7080, 7105, 7120],
  ),
  DemoCropPrice(
    crop: 'Tomato',
    mandi: 'Indore Mandi',
    pricePerQuintal: 1850,
    changePercent: 3.4,
    spark: [1720, 1750, 1780, 1795, 1810, 1830, 1850],
  ),
  DemoCropPrice(
    crop: 'Onion',
    mandi: 'Ujjain Mandi',
    pricePerQuintal: 1420,
    changePercent: -1.5,
    spark: [1480, 1465, 1455, 1448, 1438, 1428, 1420],
  ),
  DemoCropPrice(
    crop: 'Maize',
    mandi: 'Sehore Mandi',
    pricePerQuintal: 2090,
    changePercent: 0.4,
    spark: [2070, 2075, 2072, 2080, 2084, 2088, 2090],
  ),
  DemoCropPrice(
    crop: 'Mustard',
    mandi: 'Sehore Mandi',
    pricePerQuintal: 5650,
    changePercent: 0.9,
    spark: [5580, 5600, 5615, 5620, 5635, 5642, 5650],
  ),
  DemoCropPrice(
    crop: 'Gram',
    mandi: 'Indore Mandi',
    pricePerQuintal: 5440,
    changePercent: 1.0,
    spark: [5360, 5380, 5395, 5405, 5420, 5432, 5440],
  ),
];

/// Crops shown as quick chips on the home dashboard.
const demoChipCrops = <String>['Wheat', 'Rice', 'Soybean', 'Cotton'];

/// Mock 7-day price movement per chip crop, for the forecast chart.
const demoForecast = <String, List<double>>{
  'Wheat': [2240, 2255, 2262, 2258, 2270, 2281, 2290],
  'Rice': [2188, 2194, 2199, 2203, 2208, 2212, 2218],
  'Soybean': [4690, 4675, 4660, 4650, 4662, 4678, 4695],
  'Cotton': [7010, 7045, 7030, 7075, 7090, 7110, 7145],
};

class DemoDiagnosis {
  final String cropName;
  final String? diseaseName;
  final double confidence; // 0.0 to 1.0
  final List<String> treatments;
  const DemoDiagnosis({
    required this.cropName,
    required this.diseaseName,
    required this.confidence,
    required this.treatments,
  });

  /// Below 60% confidence the app must not suggest any medicine or
  /// treatment; it asks for a retake and refers to a local expert.
  bool get isLowConfidence => confidence < 0.6;
}

/// Mock high-confidence result used by the demo scan flow.
const demoDiagnosisStandard = DemoDiagnosis(
  cropName: 'Tomato',
  diseaseName: 'Leaf blight',
  confidence: 0.82,
  treatments: [
    'Remove badly affected leaves and destroy them away from the field.',
    'Water at the base of the plant and avoid wetting the leaves.',
  ],
);

/// Mock low-confidence result: no disease name, NO treatments.
const demoDiagnosisLow = DemoDiagnosis(
  cropName: 'Tomato',
  diseaseName: null,
  confidence: 0.45,
  treatments: [],
);

class DemoChatMessage {
  final String text;
  final bool fromUser;
  const DemoChatMessage({required this.text, required this.fromUser});
}

const demoChatSeed = <DemoChatMessage>[
  DemoChatMessage(
    text: 'Namaste! Ask me about mandi prices, weather or crop problems.',
    fromUser: false,
  ),
  DemoChatMessage(text: 'What is the soybean price today?', fromUser: true),
  DemoChatMessage(
    text: 'Soybean is ₹4,650 per quintal at Indore Mandi today. (Demo data)',
    fromUser: false,
  ),
];

const demoSuggestions = <String>[
  'Soybean price today?',
  'Why are my tomato leaves yellow?',
  'Will it rain this week?',
];

const demoAssistantReply =
    'This is a demo reply. In the full app, the assistant will answer '
    'using live mandi, weather and crop data.';
