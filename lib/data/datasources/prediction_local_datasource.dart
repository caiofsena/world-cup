import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/prediction.dart';

class PredictionLocalDatasource {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'world_cup_predictions.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE predictions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT NOT NULL,
            matchId INTEGER NOT NULL,
            homeGoals INTEGER NOT NULL,
            awayGoals INTEGER NOT NULL,
            updatedAt TEXT NOT NULL,
            UNIQUE(userId, matchId)
          )
        ''');
      },
    );
  }

  Future<List<Prediction>> getPredictionsByUser(String userId) async {
    final db = await database;
    final maps = await db.query(
      'predictions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'updatedAt DESC',
    );
    return maps.map((m) => Prediction.fromJson(m)).toList();
  }

  Future<Prediction?> getPrediction(String userId, int matchId) async {
    final db = await database;
    final maps = await db.query(
      'predictions',
      where: 'userId = ? AND matchId = ?',
      whereArgs: [userId, matchId],
    );
    if (maps.isEmpty) return null;
    return Prediction.fromJson(maps.first);
  }

  Future<void> savePrediction(Prediction prediction) async {
    final db = await database;
    await db.insert(
      'predictions',
      {
        'userId': prediction.userId,
        'matchId': prediction.matchId,
        'homeGoals': prediction.homeGoals,
        'awayGoals': prediction.awayGoals,
        'updatedAt': prediction.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletePrediction(String userId, int matchId) async {
    final db = await database;
    await db.delete(
      'predictions',
      where: 'userId = ? AND matchId = ?',
      whereArgs: [userId, matchId],
    );
  }
}
