class AppStrings {
  final String code;
  const AppStrings(this.code);
  bool get te => code == 'te';
  String get appName => 'DailyCalc';
  String get tagline => te ? 'భారతదేశం కోసం రోజువారీ కాలిక్యులేటర్' : 'Everyday Calculator for India';
  String get subtitle => te ? 'డబ్బు, రుణాలు, షాపింగ్ మరియు రోజువారీ లెక్కలు — వేగంగా, ప్రైవేట్‌గా.' : 'Money, loans, shopping and life calculations — private and fast.';
  String get searchHint => te ? 'EMI, వయస్సు, వడ్డీ, GST వెతకండి...' : 'Search EMI, age, Vaddi, GST...';
  String get allCalculators => te ? 'అన్ని కాలిక్యులేటర్లు' : 'All calculators';
  String get history => te ? 'సేవ్ చేసిన లెక్కలు' : 'Saved & History';
  String get settings => te ? 'సెట్టింగ్స్ & గోప్యత' : 'Settings & Privacy';
  String get offline => te ? 'ఆఫ్‌లైన్' : 'Offline-first';
  String get noLogin => te ? 'లాగిన్ అవసరం లేదు' : 'No login';
  String get saveResults => te ? 'ఫలితాలు సేవ్ చేయండి' : 'Save results';
}
