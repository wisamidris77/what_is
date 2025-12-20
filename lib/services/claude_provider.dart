import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'ai_provider.dart';

class ClaudeProvider implements AIProvider {
  String? _apiKey;
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-3-5-sonnet-20240620';
  static const String _apiVersion = '2023-06-01';

  @override
  String get providerName => 'Claude (Anthropic)';

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
          'x-api-key': apiKey,
          'anthropic-version': _apiVersion,
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
      final request = http.Request('POST', Uri.parse(_baseUrl));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'x-api-key': _apiKey!,
        'anthropic-version': _apiVersion,
      });
      request.body = jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'user', 'content': wrappedPrompt}
        ],
        'max_tokens': 4096,
        'stream': true,
      });

      final response = await http.Client().send(request);

      if (response.statusCode != 200) {
        yield 'Error: API request failed with status ${response.statusCode}';
        return;
      }

      await for (final chunk in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
          if (chunk.trim().isEmpty) continue;
          
          if (chunk.startsWith('data: ')) {
            try {
               final jsonStr = chunk.substring(6);
               final data = jsonDecode(jsonStr) as Map<String, dynamic>;
               
               // Check for content_block_delta
               if (data['type'] == 'content_block_delta') {
                 final delta = data['delta'] as Map<String, dynamic>?;
                 if (delta != null && delta['type'] == 'text_delta') {
                   final text = delta['text'] as String?;
                   if (text != null) {
                     yield text;
                   }
                 }
               }
            } catch (_) {
              // Ignore parse errors or non-delta events
            }
          }
      }
    } catch (e) {
      yield 'Error: ${e.toString()}';
    }
  }

  @override
  Stream<String> generate(String prompt) async* {
     if (_apiKey == null) {
      throw Exception('Provider not initialized. Call initialize() first.');
    }

    try {
      final request = http.Request('POST', Uri.parse(_baseUrl));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'x-api-key': _apiKey!,
        'anthropic-version': _apiVersion,
      });
      request.body = jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'max_tokens': 4096,
        'stream': true,
      });

      final response = await http.Client().send(request);

      if (response.statusCode != 200) {
        yield 'Error: API request failed with status ${response.statusCode}';
        return;
      }

      await for (final chunk in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
          if (chunk.trim().isEmpty) continue;
          
          if (chunk.startsWith('data: ')) {
            try {
               final jsonStr = chunk.substring(6);
               final data = jsonDecode(jsonStr) as Map<String, dynamic>;
               
               if (data['type'] == 'content_block_delta') {
                 final delta = data['delta'] as Map<String, dynamic>?;
                 if (delta != null && delta['type'] == 'text_delta') {
                   final text = delta['text'] as String?;
                   if (text != null) {
                     yield text;
                   }
                 }
               }
            } catch (_) {}
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
