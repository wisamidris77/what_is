import 'package:drift/drift.dart';

class TopicsDrift extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get iconKey => text()();
  TextColumn get colorHex => text()();
  TextColumn get settings => text()(); // JSON string
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LearnedItemsDrift extends Table {
  TextColumn get id => text()();
  TextColumn get topicId => text().references(TopicsDrift, #id)();
  TextColumn get conceptTitle => text()();
  TextColumn get contentBody => text()();
  BoolColumn get isUnderstood => boolean().withDefault(const Constant(false))();
  DateTimeColumn get learnedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class DiscussionMessagesDrift extends Table {
  TextColumn get id => text()();
  TextColumn get learnedItemId => text().references(LearnedItemsDrift, #id)();
  TextColumn get role => text()(); // 'user' | 'assistant'
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class TriviaFactsDrift extends Table {
  TextColumn get id => text()();
  TextColumn get topicId => text().references(TopicsDrift, #id)();
  TextColumn get content => text()();
  BoolColumn get isShown => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
