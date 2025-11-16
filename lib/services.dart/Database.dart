import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models.dart/utilisateur.dart';
import '../models.dart/tache.dart';

class DatabaseManager {
  static Database? _database;
  static const String _databaseName = 'todolist.db';
  static const int _databaseVersion = 1;

  // TABLE UTILISATEURS
  static const String tableUsers = 'utilisateurs';
  static const String userId = 'id';
  static const String userNom = 'nom';
  static const String userEmail = 'email';
  static const String userPassword = 'password';

  // TABLE TACHES
  static const String tableTaches = 'taches';
  static const String tacheId = 'id';
  static const String tacheTitre = 'titre';
  static const String tacheDescription = 'description';
  static const String tacheDate = 'date';
  static const String tacheStatus = 'status';
  static const String tacheUserId = 'user_id';

  // Singleton
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();

  // Getter Database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialisation
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Création des tables
  Future _onCreate(Database db, int version) async {
    // Table Utilisateurs
    await db.execute('''
      CREATE TABLE $tableUsers (
        $userId INTEGER PRIMARY KEY AUTOINCREMENT,
        $userNom TEXT NOT NULL,
        $userEmail TEXT NOT NULL UNIQUE,
        $userPassword TEXT NOT NULL
      )
    ''');

    // Table Tâches
    await db.execute('''
      CREATE TABLE $tableTaches (
        $tacheId INTEGER PRIMARY KEY AUTOINCREMENT,
        $tacheTitre TEXT NOT NULL,
        $tacheDescription TEXT,
        $tacheDate TEXT NOT NULL,
        $tacheUserId INTEGER NOT NULL,
        FOREIGN KEY ($tacheUserId) REFERENCES $tableUsers($userId)
      )
    ''');
  }

  
  // UTILISATEURS
  
  Future<int> insertUser(Utilisateur user) async {
    final db = await database;
    return await db.insert(tableUsers, user.toMap());
  }

  Future<Utilisateur?> loginUser(String email, String password) async {
    final db = await database;

    final result = await db.query(
      tableUsers,
      where: '$userEmail = ? AND $userPassword = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return Utilisateur.fromMap(result.first);
    }
    return null;
  }

  Future<List<Utilisateur>> getAllUsers() async {
    final db = await database;
    final result = await db.query(tableUsers);
    return result.map((e) => Utilisateur.fromMap(e)).toList();
  }

 
  // TACHES
  

  Future<int> insertTache(Tache tache) async {
    final db = await database;
    return await db.insert(tableTaches, tache.toMap());
  }

  Future<List<Tache>> getTachesByUser(int userId) async {
    final db = await database;
    final result = await db.query(
      tableTaches,
      where: '$tacheUserId = ?',
      whereArgs: [userId],
    );
    return result.map((e) => Tache.fromMap(e)).toList();
  }

  Future<int> updateTache(Tache tache) async {
    final db = await database;
    return await db.update(
      tableTaches,
      tache.toMap(),
      where: '$tacheId = ?',
      whereArgs: [tache.id],
    );
  }

  Future<int> deleteTache(int id) async {
    final db = await database;
    return await db.delete(tableTaches, where: '$tacheId = ?', whereArgs: [id]);
  }

  // Fermer la BDD
  Future close() async {
    final db = await database;
    db.close();
  }
}
