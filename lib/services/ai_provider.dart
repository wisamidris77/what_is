import '../models/models.dart';

abstract class AIProvider {
  Future<void> initialize(String apiKey);
  Stream<String> generateResponse(String prompt, AppMode mode, String? targetLanguage, {String? responseStyle});
  Future<bool> validateApiKey(String apiKey);
  String get providerName;
}
