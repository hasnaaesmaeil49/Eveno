import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeMode appTheme = ThemeMode.light;

  AppThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString('appTheme');
    if (savedTheme != null) {
      appTheme = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  Future<void> changeTheme(ThemeMode newTheme) async {
    if (appTheme == newTheme) return;
    appTheme = newTheme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appTheme', newTheme == ThemeMode.dark ? 'dark' : 'light');
  }

  // الإضافة: معرفة إذا الوضع مظلم
  bool get isDarkMode => appTheme == ThemeMode.dark;

  // الإضافة: تبديل الوضع
  Future<void> toggleTheme() async {
    final newTheme = appTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await changeTheme(newTheme);
  }
}