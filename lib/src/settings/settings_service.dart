import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _themeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeValue = prefs.getString(_themeKey) ?? 'system';
    switch (themeValue) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    String themeValue;
    switch (theme) {
      case ThemeMode.light:
        themeValue = 'light';
        break;
      case ThemeMode.dark:
        themeValue = 'dark';
        break;
      case ThemeMode.system:
        themeValue = 'system';
        break;
    }
    await prefs.setString(_themeKey, themeValue);
  }

  Future<Locale> locale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey) ?? 'en';
    return Locale(languageCode);
  }

  Future<void> updateLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}
