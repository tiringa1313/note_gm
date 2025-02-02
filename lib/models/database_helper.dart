import 'package:note_gm/models/placa_veiculo.dart';
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
      onUpgrade:
          _onUpgrade, // Adicionando método de upgrade para garantir alterações futuras
    );
  }

  Future _onCreate(Database db, int version) async {
    // Criação das tabelas
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

    await db.execute('''
      CREATE TABLE placas(
        placa TEXT PRIMARY KEY,
        condutor TEXT,
        cnh TEXT,
        cpf TEXT,
        observacao TEXT,
        fotoPath TEXT,
        dataCadastro TEXT
      )
    ''');
  }

  // Método de upgrade para gerenciar futuras alterações no banco
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Adicionando novos campos ou tabelas no futuro
    }
  }

  // Método para buscar os detalhes de uma placa específica
  Future<PlacaVeiculo> getPlacaDetails(String placa) async {
    Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'placas',
      where: 'placa = ?',
      whereArgs: [placa],
    );

    print(
        'Resultado da consulta: $result'); // Adicione este print para inspecionar os dados

    if (result.isNotEmpty) {
      return PlacaVeiculo(
        placa: result[0]['placa'],
        condutor: result[0]['condutor'],
        cnh: result[0]['cnh'],
        cpf: result[0]['cpf'],
        observacao: result[0]['observacao'],
        fotoPath: result[0]['fotoPath'],
        dataCadastro: DateTime.parse(result[0]['dataCadastro']),
      );
    } else {
      throw Exception('Placa não encontrada');
    }
  }

  // Método para inserir uma nova equipe
  Future<int> insertEquipe(Equipe equipe) async {
    Database db = await database;
    return await db.insert('equipe', equipe.toMap());
  }

  // Método para recuperar a lista de equipes
  Future<List<Equipe>> getEquipes() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('equipe');
    return List.generate(maps.length, (i) {
      return Equipe.fromMap(maps[i]);
    });
  }

  // Métodos para atualizar e deletar equipes
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

  Future<void> insertPlaca(PlacaVeiculo placa) async {
    final db = await database;
    await db.insert(
      'placas', // nome da tabela
      placa.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Substitui em caso de conflito
    );
    print(
        'Placa cadastrada: ${placa.placa}'); // Adicionando log para verificação
  }

  Future<List<String>> getPlacas() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('placas');
    return List.generate(maps.length, (i) {
      return maps[i]['placa'] as String;
    });
  }
}
