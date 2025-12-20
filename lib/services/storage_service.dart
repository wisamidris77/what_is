import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/models.dart';

class StorageService {
  static final StorageService instance = StorageService._internal();
  factory StorageService() => instance;
  StorageService._internal();

  late SharedPreferences _prefs;
  final _secureStorage = const FlutterSecureStorage();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String?> getApiKey() async {
    return await _secureStorage.read(key: 'api_key');
  }

  Future<void> saveApiKey(String apiKey) async {
    await _secureStorage.write(key: 'api_key', value: apiKey);
  }

  Future<void> deleteApiKey() async {
    await _secureStorage.delete(key: 'api_key');
  }

  String getTargetLanguage() {
    return _prefs.getString('target_language') ?? 'English';
  }

  Future<void> setTargetLanguage(String language) async {
    await _prefs.setString('target_language', language);
  }

  String getTranslateTargetLanguage() {
    return _prefs.getString('translate_target_language') ?? 'English';
  }

  Future<void> setTranslateTargetLanguage(String language) async {
    await _prefs.setString('translate_target_language', language);
  }

  // Theme Settings
  String getThemeMode() {
    return _prefs.getString('theme_mode') ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString('theme_mode', mode);
  }

  int getPrimaryColor() {
    return _prefs.getInt('primary_color') ?? 0xFF000000; // Default Black
  }

  Future<void> setPrimaryColor(int color) async {
    await _prefs.setInt('primary_color', color);
  }

  List<QueryHistory> getHistory() {
    final historyJson = _prefs.getStringList('history') ?? [];
    return historyJson
        .map((json) => QueryHistory.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  Future<void> addToHistory(QueryHistory item) async {
    final history = getHistory();
    history.insert(0, item);
    
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }
    
    final historyJson = history.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs.setStringList('history', historyJson);
  }

  Future<void> clearHistory() async {
    await _prefs.remove('history');
  }

  String getProviderType() {
    return _prefs.getString('provider_type') ?? 'gemini';
  }

  Future<void> setProviderType(String providerType) async {
    await _prefs.setString('provider_type', providerType);
  }

  String getResponseStyle() {
    return _prefs.getString('response_style') ?? 'normal';
  }

  Future<void> setResponseStyle(String style) async {
    await _prefs.setString('response_style', style);
  }

  bool isOnboardingComplete() {
    return _prefs.getBool('onboarding_complete') ?? false;
  }

  Future<void> setOnboardingComplete(bool complete) async {
    await _prefs.setBool('onboarding_complete', complete);
  }
  // Hotkey Management
  Map<String, dynamic>? getHotkeyConfig(String actionId) {
    final jsonString = _prefs.getString('hotkey_$actionId');
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> setHotkeyConfig(String actionId, Map<String, dynamic> config) async {
    await _prefs.setString('hotkey_$actionId', jsonEncode(config));
  }
}
