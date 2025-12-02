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
    return _prefs.getString('target_language') ?? 'Arabic';
  }

  Future<void> setTargetLanguage(String language) async {
    await _prefs.setString('target_language', language);
  }

  bool isDarkMode() {
    return _prefs.getBool('dark_mode') ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool('dark_mode', isDark);
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
}
