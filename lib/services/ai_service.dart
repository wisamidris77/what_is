import '../models/models.dart';
import 'ai_provider.dart';
import 'gemini_provider.dart';
import 'openai_provider.dart';

class AIService {
  static final AIService instance = AIService._internal();
  factory AIService() => instance;
  AIService._internal();

  AIProvider? _currentProvider;
  
  AIProvider get currentProvider {
    if (_currentProvider == null) {
      throw Exception('No AI provider initialized');
    }
    return _currentProvider!;
  }

  Future<void> initializeProvider(String apiKey, {String providerType = 'gemini'}) async {
    switch (providerType.toLowerCase()) {
      case 'gemini':
        _currentProvider = GeminiProvider();
        break;
      case 'openai':
        _currentProvider = OpenAIProvider();
        break;
      default:
        throw Exception('Unsupported provider: $providerType');
    }
    
    await _currentProvider!.initialize(apiKey);
  }

  Future<bool> validateApiKey(String apiKey, {String providerType = 'gemini'}) async {
    AIProvider provider;
    switch (providerType.toLowerCase()) {
      case 'gemini':
        provider = GeminiProvider();
        break;
      case 'openai':
        provider = OpenAIProvider();
        break;
      default:
        return false;
    }
    
    return await provider.validateApiKey(apiKey);
  }

  Stream<String> getResponse(String input, AppMode mode, String? targetLanguage, {String? responseStyle}) {
    return currentProvider.generateResponse(input, mode, targetLanguage, responseStyle: responseStyle);
  }

  Stream<String> generate(String input) {
    return currentProvider.generate(input);
  }

  bool get isInitialized => _currentProvider != null;
  
  String get providerName => _currentProvider?.providerName ?? 'None';
}
