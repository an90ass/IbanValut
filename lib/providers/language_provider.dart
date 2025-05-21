import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = Locale('en'); 
  Locale get locale => _locale;
  LanguageProvider() {
    _loadSavedLocale(); 
  }
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('language');

    if (savedLanguage != null) {
      _locale = Locale(savedLanguage); 
    } else {
      _locale = Locale(PlatformDispatcher.instance.locale.languageCode); 
    }
    notifyListeners();
  }
  Future<void> changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode); 
  }

  void toggleLanguage() async {
    String newLanguage = (_locale.languageCode == 'en') ? 'tr' : 'en';
    await changeLanguage(newLanguage);
  }
}