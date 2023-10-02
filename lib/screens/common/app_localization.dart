import 'dart:ui';
import 'package:flutter/cupertino.dart';

class AppLocalization {
  Locale _locale;

  AppLocalization(this._locale);

  Locale get locale => _locale;

  void changeLocale(Locale locale) {
    _locale = locale;
  }

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'language': 'Language',
      'theme': 'Theme',
      'default': 'Default',
      'green': 'Green',
      // ... other translations ...
    },
    'ur': {
      'language': 'زبان',
      'theme': 'تھیم',
      'default': 'پہلے طرز',
      'green': 'گرین',
      // ... other translations ...
    },
  };

  String get language {
    return _localizedValues[locale.languageCode]!['language']!;
  }

  String get theme {
    return _localizedValues[locale.languageCode]!['theme']!;
  }

  String get defaultTheme {
    return _localizedValues[locale.languageCode]!['default']!;
  }

  String get greenTheme {
    return _localizedValues[locale.languageCode]!['green']!;
  }

  // ... other translations ...

  static Future<AppLocalization> load(Locale locale) async {
    final localization = AppLocalization(locale);
    await localization.loadTranslation();
    return localization;
  }

  Future<void> loadTranslation() async {
    // Load translations here if needed
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ur'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    return AppLocalization.load(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) {
    return false;
  }
}
