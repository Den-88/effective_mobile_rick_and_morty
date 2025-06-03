import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  late Box<String> _themeBox;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _initTheme();
  }

  Future<void> _initTheme() async {
    _themeBox = await Hive.openBox<String>('theme_settings');
    final savedTheme = _themeBox.get('themeMode');

    if (savedTheme != null) {
      if (savedTheme == 'light') {
        _themeMode = ThemeMode.light;
      } else if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    }
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      _themeBox.put('themeMode', 'dark');
    } else if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.system;
      _themeBox.put('themeMode', 'system');
    } else {
      _themeMode = ThemeMode.light;
      _themeBox.put('themeMode', 'light');
    }
    notifyListeners();
  }
}