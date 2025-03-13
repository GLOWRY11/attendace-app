import 'package:attendance_appschool/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider with ChangeNotifier {
  final _localizationManager = LocalizationManager();
  final List<Locale> _supportedLocales = S.delegate.supportedLocales;
  Locale _currentLocale = S.delegate.supportedLocales.first;

  LocalizationProvider() {
    _initLocale();
  }

  _initLocale() async {
    if (!await _localizationManager.isLocaleAvailable()) {
      return;
    }
    String? languageCode = await _localizationManager.getLocale();
    if (languageCode == null) {
      return;
    }
    final selectedLocal =
        _supportedLocales.firstWhere((l) => l.languageCode == languageCode);
    changeLocale(selectedLocal);
  }

  List<Locale> get supportedLocales {
    return _supportedLocales;
  }

  Locale get currentLocale {
    return _currentLocale;
  }

  int get localesCount {
    return _supportedLocales.length;
  }

  changeLocale(Locale newLocale) {
    if (S.delegate.isSupported(newLocale)) {
      _currentLocale = newLocale;
      _localizationManager.setLocale(newLocale.languageCode);
      notifyListeners();
    }
  }
}

class LocalizationManager {
  final String _resourceName = '_app_locale_lang_code';

  Future<void> setLocale(String languageCode) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_resourceName, languageCode);
  }

  Future<String?> getLocale() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString(_resourceName);
  }

  Future<void> clear() async {
    final instance = await SharedPreferences.getInstance();
    await instance.clear();
  }

  Future<bool> isLocaleAvailable() async {
    return await getLocale() != null;
  }
}
