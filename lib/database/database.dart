import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
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

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'what_is',
    native: DriftNativeOptions(
      databasePath: () async {
        final dir = await getApplicationSupportDirectory();
        final dbFolder = Directory(p.join(dir.path, 'what_is_db'));
        if (!await dbFolder.exists()) {
          await dbFolder.create(recursive: true);
        }
        return p.join(dbFolder.path, 'what_is_learn_it.sqlite');
      },
    ),
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
