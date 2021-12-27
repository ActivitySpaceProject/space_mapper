import 'package:asm/models/contacts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Used to store the data submitted by the user, such as contacts, mosquito bites, etc.
class StorageDatabase {
  static final StorageDatabase instance = StorageDatabase._init();

  static Database? _database;

  StorageDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('storage.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final stringType = 'STRING NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tableContacts(
        ${ContactFields.id} $idType,
        ${ContactFields.gender} $stringType,
        ${ContactFields.ageGroup} $integerType,
      )   
    ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
