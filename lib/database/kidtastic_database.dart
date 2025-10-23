import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../tables/tables.dart';

part 'kidtastic_database.g.dart';

@DriftDatabase(
  tables: [
    GameQuestionTable,
    GameSessionTable,
    GameTable,
    SessionQuestionTable,
    StudentInsightTable,
    StudentTable,
    TeacherTable,
    PronunciationAttemptTable,
  ],
)
class KidtasticDatabase extends _$KidtasticDatabase {
  KidtasticDatabase(super.e);

  factory KidtasticDatabase.withPath(String path) {
    return KidtasticDatabase(NativeDatabase(File(path)));
  }

  @override
  int get schemaVersion => 1;
}

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final customDir = Directory(p.join(Directory.current.path, 'db'));

//     if (!await customDir.exists()) {
//       await customDir.create(recursive: true);
//     }

//     final dbPath = p.join(customDir.path, 'kidtasticdb.sqlite');

//     return NativeDatabase.createInBackground(
//       File(dbPath),
//       logStatements: true,
//     );
//   });
// }
