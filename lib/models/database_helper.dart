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
      version: 2, // Atualizando a versão do banco de dados
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Adicionando o método de atualização
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

    // Criar tabela de placas
    await db.execute('''
      CREATE TABLE placas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        placa TEXT UNIQUE
      )
    ''');
  }

  // Método para atualizar o banco de dados (adicionar a tabela de placas)
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE placas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          placa TEXT UNIQUE
        )
      ''');
    }
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

  Future<int> deleteBoletim(String id) async {
    Database db = await database;
    return await db.delete(
      'boletim',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Boletim>> getUsedBoletins() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('boletim',
        where: 'used = ?',
        whereArgs: [1]); // Ajuste a lógica conforme sua necessidade
    return List.generate(maps.length, (i) {
      return Boletim.fromMap(maps[i]);
    });
  }

  // Métodos para gerenciar placas
  Future<bool> existsPlaca(String placa) async {
    Database db = await database;
    final result =
        await db.query('placas', where: 'placa = ?', whereArgs: [placa]);
    return result.isNotEmpty;
  }

  Future<int> insertPlaca(String placa) async {
    Database db = await database;
    return await db.insert('placas', {'placa': placa},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<String>> getPlacas() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('placas');
    return List.generate(maps.length, (i) {
      return maps[i]['placa'] as String;
    });
  }
}
