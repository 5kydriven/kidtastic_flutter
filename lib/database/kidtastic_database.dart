import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import '../tables/tables.dart';

part 'kidtastic_database.g.dart';

@DriftDatabase(tables: [StudentTable])
class KidtasticDatabase extends _$KidtasticDatabase {
  KidtasticDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final customDir = Directory(p.join(Directory.current.path, 'db'));

    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }

    final dbPath = p.join(customDir.path, 'kidtasticdb.sqlite');

    return NativeDatabase.createInBackground(
      File(dbPath),
      logStatements: true,
    );
  });
}
