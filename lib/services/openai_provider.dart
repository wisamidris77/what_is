import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'ai_provider.dart';

class OpenAIProvider implements AIProvider {
  String? _apiKey;
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _model = 'gpt-4o-mini';

  @override
  String get providerName => 'OpenAI';

  @override
  Future<void> initialize(String apiKey) async {
    _apiKey = apiKey;
  }

  @override
  Future<bool> validateApiKey(String apiKey) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': 'test'}
          ],
          'max_tokens': 5,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<String> generateResponse(String prompt, AppMode mode, String? targetLanguage, {String? responseStyle}) async* {
    if (_apiKey == null) {
      throw Exception('Provider not initialized. Call initialize() first.');
    }

    final wrappedPrompt = _wrapPrompt(prompt, mode, targetLanguage, responseStyle);

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': wrappedPrompt}
          ],
          'stream': true,
        }),
      );

      if (response.statusCode != 200) {
        yield 'Error: API request failed with status ${response.statusCode}';
        return;
      }

      // Parse SSE stream
      final lines = response.body.split('\n');
      for (final line in lines) {
        if (line.startsWith('data: ') && !line.contains('[DONE]')) {
          try {
            final jsonStr = line.substring(6);
            if (jsonStr.trim().isEmpty) continue;
            final data = jsonDecode(jsonStr) as Map<String, dynamic>;
            final choices = data['choices'] as List?;
            if (choices != null && choices.isNotEmpty) {
              final delta = choices[0]['delta'] as Map<String, dynamic>?;
              final content = delta?['content'] as String?;
              if (content != null) {
                yield content;
              }
            }
          } catch (_) {
            // Skip malformed chunks
          }
        }
      }
    } catch (e) {
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
