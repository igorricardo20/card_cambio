import 'package:flutter/material.dart';
import 'package:card_cambio/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  void setLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;

    _locale = locale;
    notifyListeners();
    await _saveLocale(locale);
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale');
    if (localeCode == null) {
      _locale = Locale(PlatformDispatcher.instance.locale.languageCode);
    } else {
      _locale = Locale(localeCode);
    }
    notifyListeners();
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }
}