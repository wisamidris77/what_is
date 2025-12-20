import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/models.dart';
import 'ai_provider.dart';

class GeminiProvider implements AIProvider {
  GenerativeModel? _model;

  @override
  String get providerName => 'Google Gemini';

  @override
  Future<void> initialize(String apiKey) async {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
  }

  @override
  Future<bool> validateApiKey(String apiKey) async {
    try {
      final testModel = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );
      final response = await testModel.generateContent([Content.text('test')]);
      return response.text != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<String> generateResponse(String prompt, AppMode mode, String? targetLanguage, {String? responseStyle}) async* {
    if (_model == null) {
      throw Exception('Provider not initialized. Call initialize() first.');
    }

    final wrappedPrompt = _wrapPrompt(prompt, mode, targetLanguage, responseStyle);
    
    try {
      final response = _model!.generateContentStream([Content.text(wrappedPrompt)]);
      
      await for (final chunk in response) {
        final text = chunk.text;
        if (text != null) {
          yield text;
        }
      }
    } catch (e) {
      yield 'Error: ${e.toString()}';
    }
  }

  @override
  Stream<String> generate(String prompt) async* {
    if (_model == null) {
      throw Exception('Provider not initialized. Call initialize() first.');
    }

    try {
      // Direct raw prompt, no wrapping
      final response = _model!.generateContentStream([Content.text(prompt)]);
      
      await for (final chunk in response) {
        final text = chunk.text;
        if (text != null) {
          yield text;
        }
      }
    } catch (e) {
      // Log the error as requested
      print('GeminiProvider Generate Error: $e');
      yield 'Error: ${e.toString()}';
    }
  }

  String _wrapPrompt(String userInput, AppMode mode, String? targetLanguage, String? styleModifier) {
    final modifier = styleModifier ?? '';
    switch (mode) {
      case AppMode.code:
        return '''${modifier}You are an expert coding assistant. Explain the following code snippet clearly. If it contains an error, fix it. If it is complex, break it down step-by-step. Use Markdown for formatting.

$userInput''';

      case AppMode.translate:
        final language = targetLanguage ?? 'English';
        return '''${modifier}Translate the following text into $language. Provide only the translation, or a brief note on nuance if necessary.

$userInput''';

      case AppMode.explain:
        return '''${modifier}Explain the following concept or word. Provide a definition, a simple analogy, and examples. Keep it concise but detailed.

$userInput''';
    }
  }
}
