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
) WITHOUT ROWID;"""
  };

  Future<Database> getDatabaseAsync() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), "fueler.db"),
        onCreate: (db, version) async {
          for (var migration in _migrations.entries) {
            print("Running migration ${migration.key}...");
            await db.execute(migration.value);
            print("Done.");
          }
        },
        version: 1,
      );
    }
    return _database;
  }

  Future<void> dispose() async {
    await _database?.close();
  }
}

DatabaseService databaseService = DatabaseService();
