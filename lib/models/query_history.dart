import 'app_mode.dart';

class QueryHistory {
  final String prompt;
  final String response;
  final AppMode mode;
  final DateTime timestamp;

  QueryHistory({
    required this.prompt,
    required this.response,
    required this.mode,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'response': response,
        'mode': mode.name,
        'timestamp': timestamp.toIso8601String(),
      };

  factory QueryHistory.fromJson(Map<String, dynamic> json) => QueryHistory(
        prompt: json['prompt'] as String,
        response: json['response'] as String,
        mode: AppMode.values.firstWhere((e) => e.name == json['mode']),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

