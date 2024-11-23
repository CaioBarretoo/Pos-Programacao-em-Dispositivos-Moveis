import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';
class GeoData extends Table {
  TextColumn get ip => text()();
  TextColumn get city => text()();
  TextColumn get regionName => text()();
  TextColumn get country => text()();
  TextColumn get lat => text()();
  TextColumn get lon => text()();
}
@DriftDatabase(tables: [GeoData])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'geodatabase');
  }
}