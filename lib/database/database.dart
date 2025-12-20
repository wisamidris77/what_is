import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [TopicsDrift, LearnedItemsDrift, DiscussionMessagesDrift, TriviaFactsDrift])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'what_is_db', 'what_is_learn_it.sqlite'));
    
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    
    return NativeDatabase.createInBackground(file);
  });
}
