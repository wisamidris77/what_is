import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'ai_provider.dart';

class BedrockProvider implements AIProvider {
  String? _accessKey;
  String? _secretKey;
  String? _region;
  
  // Format: accessKey:secretKey:region
  
  static const String _service = 'bedrock';
  static const String _defaultModel = 'anthropic.claude-3-5-sonnet-20240620-v1:0';

  @override
  String get providerName => 'AWS Bedrock';

  @override
  Future<void> initialize(String apiKey) async {
    final parts = apiKey.split(':');
    if (parts.length >= 3) {
      _accessKey = parts[0];
      _secretKey = parts[1];
      _region = parts[2];
    }
  }

  @override
  Future<bool> validateApiKey(String apiKey) async {
    final parts = apiKey.split(':');
    if (parts.length != 3) return false;
    
    final ak = parts[0];
    final sk = parts[1];
    final rg = parts[2];

    try {
      final response = await _invokeModel(
        ak, sk, rg, 
        'test', 
        maxTokens: 1
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Bedrock validate error: $e');
      return false;
    }
  }

  @override
  Stream<String> generateResponse(String prompt, AppMode mode, String? targetLanguage, {String? responseStyle}) async* {
     if (_accessKey == null || _secretKey == null || _region == null) {
      throw Exception('Provider not initialized or invalid format. Use ACCESS_KEY:SECRET_KEY:REGION');
    }

    final wrappedPrompt = _wrapPrompt(prompt, mode, targetLanguage, responseStyle);

    try {
      final response = await _invokeModel(_accessKey!, _secretKey!, _region!, wrappedPrompt);
      
      if (response.statusCode != 200) {
        yield 'Error: Bedrock request failed with status ${response.statusCode}\nBody: ${response.body}';
        return;
      }

      final data = jsonDecode(response.body);
      final content = data['content'] as List?;
      if (content != null && content.isNotEmpty) {
        final text = content[0]['text'] as String?;
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
    if (_accessKey == null || _secretKey == null || _region == null) {
      throw Exception('Provider not initialized or invalid format. Use ACCESS_KEY:SECRET_KEY:REGION');
    }

    try {
      final response = await _invokeModel(_accessKey!, _secretKey!, _region!, prompt);
      
      if (response.statusCode != 200) {
        yield 'Error: Bedrock request failed with status ${response.statusCode}\nBody: ${response.body}';
        return;
      }

      final data = jsonDecode(response.body);
      final content = data['content'] as List?;
      if (content != null && content.isNotEmpty) {
        final text = content[0]['text'] as String?;
        if (text != null) {
          yield text;
        }
      }
    } catch (e) {
      yield 'Error: ${e.toString()}';
    }
  }
  
  Future<http.Response> _invokeModel(String accessKey, String secretKey, String region, String prompt, {int maxTokens = 1000}) async {
    final host = 'bedrock-runtime.$region.amazonaws.com';
    final endpoint = Uri.https(host, '/model/$_defaultModel/invoke');
    
    final payload = jsonEncode({
      "anthropic_version": "bedrock-2023-05-31",
      "max_tokens": maxTokens,
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": prompt
            }
          ]
        }
      ]
    });

    final request = http.Request('POST', endpoint);
    request.body = payload;
    request.headers['content-type'] = 'application/json';
    
    _signRequest(request, accessKey, secretKey, region, _service);
    
    return await http.Client().send(request).then(http.Response.fromStream);
  }

  void _signRequest(http.Request request, String accessKey, String secretKey, String region, String serviceName) {
    final dateTime = DateTime.now().toUtc();
    final amzDate = _formatAmzDate(dateTime);
    final dateStamp = amzDate.substring(0, 8);

    request.headers['x-amz-date'] = amzDate;
    request.headers['host'] = request.url.host;

    final method = request.method;
    final uri = request.url.path;
    final query = request.url.query;
    
    final headers = request.headers.keys.map((k) => k.toLowerCase()).toList()..sort();
    final signedHeaders = headers.join(';');
    
    final canonicalHeaders = headers.map((k) => '$k:${request.headers[k]!.trim()}\n').join();
    
    final payloadHash = sha256.convert(utf8.encode(request.body)).toString();
    
    final canonicalRequest = '$method\n$uri\n$query\n$canonicalHeaders\n$signedHeaders\n$payloadHash';
    
    const algorithm = 'AWS4-HMAC-SHA256';
    final credentialScope = '$dateStamp/$region/$serviceName/aws4_request';
    final stringToSign = '$algorithm\n$amzDate\n$credentialScope\n${sha256.convert(utf8.encode(canonicalRequest))}';
    
    final kDate = Hmac(sha256, utf8.encode('AWS4$secretKey')).convert(utf8.encode(dateStamp)).bytes;
    final kRegion = Hmac(sha256, kDate).convert(utf8.encode(region)).bytes;
    final kService = Hmac(sha256, kRegion).convert(utf8.encode(serviceName)).bytes;
    final kSigning = Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
    
    final signature = Hmac(sha256, kSigning).convert(utf8.encode(stringToSign)).toString();
    
    final authHeader = '$algorithm Credential=$accessKey/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signature';
    request.headers['Authorization'] = authHeader;
  }

  String _formatAmzDate(DateTime date) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${date.year}${pad(date.month)}${pad(date.day)}T${pad(date.hour)}${pad(date.minute)}${pad(date.second)}Z';
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
