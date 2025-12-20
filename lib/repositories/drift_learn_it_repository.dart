import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/database.dart' as db;
import '../models/learn_it/learn_it_models.dart' as domain;
import 'i_learn_it_repository.dart';

class DriftLearnItRepository implements ILearnItRepository {
  final db.AppDatabase _db;

  DriftLearnItRepository(this._db);

  // --- Mappers ---

  domain.Topic _mapTopic(db.TopicsDriftData item) {
    return domain.Topic(
      id: item.id,
      title: item.title,
      description: item.description,
      iconKey: item.iconKey,
      colorHex: item.colorHex,
      settings: domain.TopicSettings.fromJson(jsonDecode(item.settings)),
      createdAt: item.createdAt,
    );
  }

  domain.LearnedItem _mapLearnedItem(db.LearnedItemsDriftData item) {
    return domain.LearnedItem(
      id: item.id,
      topicId: item.topicId,
      conceptTitle: item.conceptTitle,
      contentBody: item.contentBody,
      isUnderstood: item.isUnderstood,
      learnedAt: item.learnedAt,
    );
  }

  domain.DiscussionMessage _mapMessage(db.DiscussionMessagesDriftData item) {
    return domain.DiscussionMessage(
      id: item.id,
      learnedItemId: item.learnedItemId,
      role: item.role == 'user' ? domain.MessageRole.user : domain.MessageRole.assistant,
      content: item.content,
      timestamp: item.timestamp,
    );
  }

  domain.TriviaFact _mapTrivia(db.TriviaFactsDriftData item) {
    return domain.TriviaFact(
      id: item.id,
      topicId: item.topicId,
      content: item.content,
      isShown: item.isShown,
      createdAt: item.createdAt,
    );
  }

  // --- Implementation ---

  @override
  Future<void> createTopic(domain.Topic topic) async {
    await _db.into(_db.topicsDrift).insert(db.TopicsDriftCompanion(
      id: Value(topic.id),
      title: Value(topic.title),
      description: Value(topic.description),
      iconKey: Value(topic.iconKey),
      colorHex: Value(topic.colorHex),
      settings: Value(jsonEncode(topic.settings.toJson())),
      createdAt: Value(topic.createdAt),
    ));
  }

  @override
  Future<List<domain.Topic>> getAllTopics() async {
    final results = await _db.select(_db.topicsDrift).get();
    return results.map(_mapTopic).toList();
  }

  @override
  Future<domain.Topic?> getTopic(String id) async {
    final result = await (_db.select(_db.topicsDrift)..where((t) => t.id.equals(id))).getSingleOrNull();
    return result != null ? _mapTopic(result) : null;
  }

  @override
  Future<void> deleteTopic(String id) async {
    await (_db.delete(_db.topicsDrift)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> createLearnedItem(domain.LearnedItem item) async {
    await _db.into(_db.learnedItemsDrift).insert(db.LearnedItemsDriftCompanion(
      id: Value(item.id),
      topicId: Value(item.topicId),
      conceptTitle: Value(item.conceptTitle),
      contentBody: Value(item.contentBody),
      isUnderstood: Value(item.isUnderstood),
      learnedAt: Value(item.learnedAt),
    ));
  }

  @override
  Future<List<domain.LearnedItem>> getLearnedItemsForTopic(String topicId) async {
    final results = await (_db.select(_db.learnedItemsDrift)..where((t) => t.topicId.equals(topicId))).get();
    return results.map(_mapLearnedItem).toList();
  }

  @override
  Future<List<String>> getLearnedConceptTitles(String topicId) async {
    final query = _db.selectOnly(_db.learnedItemsDrift)
      ..addColumns([_db.learnedItemsDrift.conceptTitle])
      ..where(_db.learnedItemsDrift.topicId.equals(topicId));
    
    final results = await query.map((row) => row.read(_db.learnedItemsDrift.conceptTitle)).get();
    return results.whereType<String>().toList();
  }

  @override
  Future<void> markItemAsUnderstood(String itemId) async {
    await (_db.update(_db.learnedItemsDrift)..where((t) => t.id.equals(itemId))).write(
      db.LearnedItemsDriftCompanion(
        isUnderstood: const Value(true),
        learnedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<List<domain.LearnedItem>> getUnderstoodItems() async {
    final results = await (_db.select(_db.learnedItemsDrift)
      ..where((t) => t.isUnderstood.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.learnedAt, mode: OrderingMode.desc)]))
      .get();
    return results.map(_mapLearnedItem).toList();
  }

  @override
  Future<List<domain.LearnedItem>> getPendingItemsForTopic(String topicId) async {
    final results = await (_db.select(_db.learnedItemsDrift)
      ..where((t) => t.topicId.equals(topicId) & t.isUnderstood.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.id)])) // created order roughly
      .get();
    return results.map(_mapLearnedItem).toList();
  }

  @override
  Future<void> addMessage(domain.DiscussionMessage message) async {
    await _db.into(_db.discussionMessagesDrift).insert(db.DiscussionMessagesDriftCompanion(
      id: Value(message.id),
      learnedItemId: Value(message.learnedItemId),
      role: Value(message.role == domain.MessageRole.user ? 'user' : 'assistant'),
      content: Value(message.content),
      timestamp: Value(message.timestamp),
    ));
  }

  @override
  Future<List<domain.DiscussionMessage>> getMessagesForItem(String itemId) async {
    final results = await (_db.select(_db.discussionMessagesDrift)
      ..where((t) => t.learnedItemId.equals(itemId))
      ..orderBy([(t) => OrderingTerm(expression: t.timestamp)]))
      .get();
    return results.map(_mapMessage).toList();
  }

  @override
  Future<int> getTotalLearnedConceptsCount() async {
    final countExp = _db.learnedItemsDrift.id.count();
    final query = _db.selectOnly(_db.learnedItemsDrift)
      ..addColumns([countExp])
      ..where(_db.learnedItemsDrift.isUnderstood.equals(true));
    
    return await query.map((row) => row.read(countExp)).getSingle() ?? 0;
  }
  
  @override
  Future<int> getLearnedConceptsCountForTopic(String topicId) async {
    final countExp = _db.learnedItemsDrift.id.count();
    final query = _db.selectOnly(_db.learnedItemsDrift)
      ..addColumns([countExp])
      ..where(_db.learnedItemsDrift.isUnderstood.equals(true) & _db.learnedItemsDrift.topicId.equals(topicId));
      
    return await query.map((row) => row.read(countExp)).getSingle() ?? 0;
  }

  @override
  Future<void> addTriviaFacts(List<domain.TriviaFact> facts) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.triviaFactsDrift,
        facts.map((f) => db.TriviaFactsDriftCompanion(
          id: Value(f.id),
          topicId: Value(f.topicId),
          content: Value(f.content),
          isShown: Value(f.isShown),
          createdAt: Value(f.createdAt),
        )),
      );
    });
  }

  @override
  Future<List<domain.TriviaFact>> getUnshownTriviaFacts(String topicId, int limit) async {
    final results = await (_db.select(_db.triviaFactsDrift)
      ..where((t) => t.topicId.equals(topicId) & t.isShown.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt)])
      ..limit(limit))
      .get();
    return results.map(_mapTrivia).toList();
  }

  @override
  Future<void> markTriviaAsShown(String factId) async {
    await (_db.update(_db.triviaFactsDrift)..where((t) => t.id.equals(factId))).write(
      const db.TriviaFactsDriftCompanion(isShown: Value(true)),
    );
  }

  @override
  Future<int> countUnshownTrivia(String topicId) async {
    final countExp = _db.triviaFactsDrift.id.count();
    final query = _db.selectOnly(_db.triviaFactsDrift)
      ..addColumns([countExp])
      ..where(_db.triviaFactsDrift.topicId.equals(topicId) & _db.triviaFactsDrift.isShown.equals(false));
      
    return await query.map((row) => row.read(countExp)).getSingle() ?? 0;
  }
}