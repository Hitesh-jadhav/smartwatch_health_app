import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HealthDataDB {
  static Database? _database;

  static Future<Database> getDatabase() async {
    _database ??= await openDatabase(
      join(await getDatabasesPath(), 'health_data.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE health(id INTEGER PRIMARY KEY, heartRate INTEGER, stepCount INTEGER, timestamp TEXT)",
        );
      },
      version: 1,
    );
    return _database!;
  }

  static Future<void> insertHealthData(Map<String, dynamic> healthData) async {
    final db = await getDatabase();
    await db.insert(
      'health',
      healthData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getHealthData() async {
    final db = await getDatabase();
    return db.query('health', orderBy: 'timestamp DESC');
  }

  static Future<void> clearHealthData() async {
    final db = await getDatabase();
    await db.delete('health');
  }
}
