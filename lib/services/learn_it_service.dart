import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../database/database.dart';
import '../repositories/i_learn_it_repository.dart';
import '../repositories/drift_learn_it_repository.dart';
import '../models/learn_it/learn_it_models.dart';
import '../models/models.dart';
import 'ai_service.dart';

class LearnItService {
  static final LearnItService instance = LearnItService._internal();
  factory LearnItService() => instance;
  LearnItService._internal();

  ILearnItRepository? _repository;
  AppDatabase? _database;

  ILearnItRepository get repository {
    if (_repository == null) {
      throw Exception('LearnItService not initialized');
    }
    return _repository!;
  }

  Future<void> initialize() async {
    if (_repository != null) return;
    
    _database = AppDatabase();
    _repository = DriftLearnItRepository(_database!);
  }

  // --- Core Logic ---

  Future<LearnedItem> generateNextConcept(Topic topic) async {
    // 1. Get Skip List
    final skipList = await repository.getLearnedConceptTitles(topic.id);
    
    // 2. Construct Prompt
    final skipString = skipList.isEmpty 
        ? "None" 
        : skipList.map((t) => "- $t").join("\n");
        
    final prompt = """
You are an expert tutor. Teach me a single new concept about "${topic.title}".
Context: ${topic.description}

Already learned concepts (DO NOT REPEAT THESE):
$skipString

Requirements:
1. Pick a specific, bite-sized concept.
2. Provide a clear Title.
3. Provide a detailed explanation (Body) in Markdown.
4. STRICTLY use this format:
# [Title]
[Body]
""";

    // 3. Call AI
    final stream = AIService.instance.getResponse(
      prompt, 
      AppMode.explain,
      topic.settings.targetLanguage
    );
    
    final fullResponse = await stream.join();

    // 4. Parse Response
    // Simple parser assuming # Title \n Body
    final lines = fullResponse.trim().split('\n');
    String title = "New Concept";
    String body = fullResponse;

    if (lines.isNotEmpty && lines.first.startsWith('#')) {
      title = lines.first.substring(1).trim();
      body = lines.skip(1).join('\n').trim();
    } else {
      // Fallback: try to find the first header
      final headerIdx = lines.indexWhere((l) => l.startsWith('#'));
      if (headerIdx != -1) {
        title = lines[headerIdx].substring(1).trim();
        body = lines.skip(headerIdx + 1).join('\n').trim();
      }
    }

    // 5. Save to Repo
    final item = LearnedItem(
      id: const Uuid().v4(),
      topicId: topic.id,
      conceptTitle: title,
      contentBody: body,
      isUnderstood: false,
    );
    
    await repository.createLearnedItem(item);
    
    return item;
  }

  Future<Stream<String>> discussConcept(LearnedItem item, String userMessage) async {
    // 1. Save User Message
    final userMsgObj = DiscussionMessage(
      id: const Uuid().v4(),
      learnedItemId: item.id,
      role: MessageRole.user,
      content: userMessage,
      timestamp: DateTime.now(),
    );
    await repository.addMessage(userMsgObj);

    // 2. Build Context
    final history = await repository.getMessagesForItem(item.id);
    // Note: History includes the message we just added
    
    final historyString = history.map((m) {
      final role = m.role == MessageRole.user ? "User" : "Assistant";
      return "$role: ${m.content}";
    }).join("\n\n");

    final prompt = """
Context: I am learning about "${item.conceptTitle}".
The core content provided was:
${item.contentBody}

Discussion History:
$historyString

User's New Question: $userMessage

Answer the user's question based on the context. Be helpful and concise.
""";

    // 3. Call AI and Stream
    final stream = AIService.instance.getResponse(
      prompt, 
      AppMode.explain,
      null // Use default language or infer from context
    );
    
    // We need to capture the full response to save it, but we also want to return the stream to the UI.
    // We can use a StreamController or just listen to the stream.
    // Since we can't consume the stream twice, we'll return the stream and let the UI consume it.
    // BUT we need to save the result.
    // Solution: Broadcast stream or intercept it.
    
    final controller = StreamController<String>();
    final buffer = StringBuffer();
    
    stream.listen(
      (chunk) {
        buffer.write(chunk);
        controller.add(chunk);
      },
      onError: (e) => controller.addError(e),
      onDone: () async {
        // Save Assistant Message
        final assistantMsgObj = DiscussionMessage(
          id: const Uuid().v4(),
          learnedItemId: item.id,
          role: MessageRole.assistant,
          content: buffer.toString(),
          timestamp: DateTime.now(),
        );
        await repository.addMessage(assistantMsgObj);
        controller.close();
      },
    );
    
    return controller.stream;
  }

  Future<Map<String, dynamic>> generateTopicFromPrompt(String userPrompt) async {
    final prompt = """
Generate a JSON object for a learning topic based on this request: "$userPrompt".

Strictly follow this JSON schema:
{
  "title": "string (short, catchy title)",
  "description": "string (concise description of what will be learned)",
  "iconKey": "string (one of: school, code, lightbulb, science, history, language, business, music_note)",
  "colorHex": "string (one of: 0xFF2196F3, 0xFFF44336, 0xFF4CAF50, 0xFFFF9800, 0xFF9C27B0, 0xFF009688, 0xFFE91E63, 0xFF3F51B5)"
}

Do not include any markdown formatting (like ```json), just the raw JSON string.
""";

    final stream = AIService.instance.generate(prompt);
    final jsonString = await stream.join();
    
    // Clean up response if it contains markdown code blocks
    String cleanJson = jsonString.trim();
    if (cleanJson.startsWith('```json')) {
      cleanJson = cleanJson.substring(7);
    } else if (cleanJson.startsWith('```')) {
      cleanJson = cleanJson.substring(3);
    }
    
    if (cleanJson.endsWith('```')) {
      cleanJson = cleanJson.substring(0, cleanJson.length - 3);
    }

    try {
      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Failed to parse AI response: $cleanJson");
    }
  }

  /// Returns a stream/list of trivia to show immediately.
  /// If DB has enough, returns from DB.
  /// If DB empty, fetches small batch (3) from AI, returns, and triggers background fetch (30).
  Future<List<TriviaFact>> getLoadingTrivia(String topicId) async {
    // 1. Check DB
    final cached = await repository.getUnshownTriviaFacts(topicId, 10);
    
    if (cached.isNotEmpty) {
      // Trigger replenishment if low
      if (cached.length < 5) {
        replenishTrivia(topicId); // Fire and forget
      }
      return cached;
    }

    // 2. DB Empty -> Fast Fetch (3 items)
    try {
      final facts = await _fetchFromAI(topicId, 3);
      await repository.addTriviaFacts(facts);
      
      // Trigger massive replenishment
      replenishTrivia(topicId);
      
      return facts;
    } catch (e) {
      // Fallback
      return [
        TriviaFact(
          id: const Uuid().v4(),
          topicId: topicId,
          content: "Did you know? Learning keeps your brain young!",
          isShown: false,
          createdAt: DateTime.now(),
        )
      ];
    }
  }

  /// Background job to add more facts
  Future<void> replenishTrivia(String topicId) async {
    // Double check count to avoid over-fetching
    final count = await repository.countUnshownTrivia(topicId);
    if (count > 10) return; // Buffer is fine

    try {
      final facts = await _fetchFromAI(topicId, 30);
      await repository.addTriviaFacts(facts);
    } catch (e) {
      print("Replenish failed: $e");
    }
  }

  Future<List<TriviaFact>> _fetchFromAI(String topicId, int count) async {
    // We need the topic title. We only have ID here.
    // Ideally we pass title or fetch it. For now let's fetch it.
    final topic = await repository.getTopic(topicId);
    final title = topic?.title ?? "General Knowledge";

    final prompt = "Generate $count short, witty, one-sentence fun facts or jokes about '$title'. Return them as a raw list separated by a pipe character '|'. No markdown, no numbering, no intro.";
    
    final stream = AIService.instance.generate(prompt);
    final response = await stream.join();
    
    final contents = response.split('|')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return contents.map((c) => TriviaFact(
      id: const Uuid().v4(),
      topicId: topicId,
      content: c,
      isShown: false,
      createdAt: DateTime.now(),
    )).toList();
  }

  Future<void> markTriviaShown(String factId) async {
    await repository.markTriviaAsShown(factId);
  }
}
