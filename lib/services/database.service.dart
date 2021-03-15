import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database _database;
  Map<String, String> _migrations = {
    "Add refuelings table": """CREATE TABLE IF NOT EXISTS refuelings (
    refuelingId VARCHAR(255) PRIMARY KEY,
    amount REAL NOT NULL,
    price REAL NOT NULL,
    timestamp VARCHAR(255) NOT NULL,
    fuelType INTEGER NOT NULL
) WITHOUT ROWID;""",
    "Add traveledDistance column":
        "ALTER TABLE refuelings ADD COLUMN traveledDistance REAL"
  };

  Future<Database> getDatabaseAsync() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), "fueler.db"),
        onCreate: (db, version) async =>
            await performSchemaUpdate(db, _migrations.entries),
        onUpgrade: (db, oldVersion, newVersion) async {
          var updatesToPerform = _migrations.entries.skip(oldVersion);
          await performSchemaUpdate(db, updatesToPerform);
        },
        version: 2,
      );
    }
    return _database;
  }

  Future performSchemaUpdate(
      Database db, Iterable<MapEntry<String, String>> migrations) async {
    for (var migration in migrations) {
      print("Running migration ${migration.key}...");
      await db.execute(migration.value);
      print("Done.");
    }
  }

  Future<void> dispose() async {
    await _database?.close();
  }
}

DatabaseService databaseService = DatabaseService();
