import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// class LocalizationProvider extends ChangeNotifier {
//   Locale _locale = const Locale('en');
//
//   Locale get locale => _locale;
//
//   void changeLanguage(Locale newLocale) {
//     _locale = newLocale;
//     notifyListeners();
//   }
// }


import 'package:hive_flutter/hive_flutter.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale? _locale;
  final Box settingsBox = Hive.box('settings');

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  LocalizationProvider() {
    _loadSavedLocale();
  }

  void setSelectedIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }

  Locale? get locale => _locale;

  void _loadSavedLocale() {
    String? savedLanguageCode = settingsBox.get('language');

    if (savedLanguageCode == null || savedLanguageCode == "system") {
      _locale = null; // Use system locale
    } else {
      _locale = Locale(savedLanguageCode);
    }
    notifyListeners();
  }

  void setLocale(Locale? locale) {
    if (locale == null || locale.languageCode == "system") {
      settingsBox.put('language', 'system');
      _locale = null; // Set to system default
    } else {
      settingsBox.put('language', locale.languageCode);
      _locale = locale;
    }
    notifyListeners();
  }
}

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('es'),
    const Locale('fr'),
    const Locale('de'),
    const Locale('hi'),
    const Locale('it'),
    const Locale('zh'),
    const Locale('pa'),
    const Locale('nl'),
  ];
}





