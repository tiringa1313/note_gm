import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'equipe.dart';
import 'boletim.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'boletim_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE equipe(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        viatura TEXT,
        nomenclaturaVtr TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE boletim(
        id TEXT PRIMARY KEY,
        tituloAtendimento TEXT,
        descricao TEXT,
        data TEXT
      )
    ''');
  }

  Future<int> insertEquipe(Equipe equipe) async {
    Database db = await database;
    return await db.insert('equipe', equipe.toMap());
  }

  Future<List<Equipe>> getEquipes() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('equipe');
    return List.generate(maps.length, (i) {
      return Equipe.fromMap(maps[i]);
    });
  }

  Future<int> updateEquipe(Equipe equipe) async {
    Database db = await database;
    return await db.update(
      'equipe',
      equipe.toMap(),
      where: 'id = ?',
      whereArgs: [equipe.id],
    );
  }

  Future<int> deleteEquipe(int id) async {
    Database db = await database;
    return await db.delete(
      'equipe',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para Boletim
  Future<int> insertBoletim(Boletim boletim) async {
    Database db = await database;
    return await db.insert('boletim', boletim.toMap());
  }

  Future<List<Boletim>> getBoletins() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('boletim');
    return List.generate(maps.length, (i) {
      return Boletim.fromMap(maps[i]);
    });
  }

  Future<int> updateBoletim(Boletim boletim) async {
    Database db = await database;
    return await db.update(
      'boletim',
      boletim.toMap(),
      where: 'id = ?',
      whereArgs: [boletim.id],
    );
  }

  Future<int> deleteBoletim(int id) async {
    Database db = await database;
    return await db.delete(
      'boletim',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
