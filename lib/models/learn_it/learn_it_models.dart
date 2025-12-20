import 'dart:convert';

class Topic {
  final String id;
  final String title;
  final String description;
  final String iconKey;
  final String colorHex;
  final TopicSettings settings;
  final DateTime createdAt;

  Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.colorHex,
    required this.settings,
    required this.createdAt,
  });
}

class TopicSettings {
  final String targetLanguage;
  final bool includeSummary;
  final bool includeExamples;

  TopicSettings({
    required this.targetLanguage,
    required this.includeSummary,
    required this.includeExamples,
  });

  Map<String, dynamic> toJson() {
    return {
      'targetLanguage': targetLanguage,
      'includeSummary': includeSummary,
      'includeExamples': includeExamples,
    };
  }

  factory TopicSettings.fromJson(Map<String, dynamic> json) {
    return TopicSettings(
      targetLanguage: json['targetLanguage'] ?? 'en',
      includeSummary: json['includeSummary'] ?? true,
      includeExamples: json['includeExamples'] ?? true,
    );
  }
}

class LearnedItem {
  final String id;
  final String topicId;
  final String conceptTitle;
  final String contentBody;
  final bool isUnderstood;
  final DateTime? learnedAt;

  LearnedItem({
    required this.id,
    required this.topicId,
    required this.conceptTitle,
    required this.contentBody,
    required this.isUnderstood,
    this.learnedAt,
  });
}

enum MessageRole { user, assistant }

class DiscussionMessage {
  final String id;
  final String learnedItemId;
  final MessageRole role;
  final String content;
  final DateTime timestamp;

  DiscussionMessage({
    required this.id,
    required this.learnedItemId,
    required this.role,
    required this.content,
    required this.timestamp,
  });
}

class TriviaFact {
  final String id;
  final String topicId;
  final String content;
  final bool isShown;
  final DateTime createdAt;

  TriviaFact({
    required this.id,
    required this.topicId,
    required this.content,
    required this.isShown,
    required this.createdAt,
  });
}
