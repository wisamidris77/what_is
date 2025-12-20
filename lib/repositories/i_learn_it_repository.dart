import '../models/learn_it/learn_it_models.dart';

abstract class ILearnItRepository {
  // Topics
  Future<void> createTopic(Topic topic);
  Future<List<Topic>> getAllTopics();
  Future<Topic?> getTopic(String id);
  Future<void> deleteTopic(String id);

  // Learned Items
  Future<void> createLearnedItem(LearnedItem item);
  Future<List<LearnedItem>> getLearnedItemsForTopic(String topicId);
  Future<List<String>> getLearnedConceptTitles(String topicId);
  Future<void> markItemAsUnderstood(String itemId);
  Future<List<LearnedItem>> getUnderstoodItems(); // For History
  Future<List<LearnedItem>> getPendingItemsForTopic(String topicId);

  // Discussion
  Future<void> addMessage(DiscussionMessage message);
  Future<List<DiscussionMessage>> getMessagesForItem(String itemId);

  // Stats
  Future<int> getTotalLearnedConceptsCount();
  Future<int> getLearnedConceptsCountForTopic(String topicId);

  // Trivia
  Future<void> addTriviaFacts(List<TriviaFact> facts);
  Future<List<TriviaFact>> getUnshownTriviaFacts(String topicId, int limit);
  Future<void> markTriviaAsShown(String factId);
  Future<int> countUnshownTrivia(String topicId);
}
