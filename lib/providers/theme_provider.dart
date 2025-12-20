import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = Colors.black;

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;

  ThemeProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    final modeStr = StorageService.instance.getThemeMode();
    switch (modeStr) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }

    final colorVal = StorageService.instance.getPrimaryColor();
    _primaryColor = Color(colorVal);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    String modeStr;
    switch (mode) {
      case ThemeMode.light:
        modeStr = 'light';
        break;
      case ThemeMode.dark:
        modeStr = 'dark';
        break;
      default:
        modeStr = 'system';
    }
    await StorageService.instance.setThemeMode(modeStr);
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    await StorageService.instance.setPrimaryColor(color.value);
    notifyListeners();
  }
}
