import 'package:asm/models/contacts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../external_projects/tiger_in_car/models/tiger_in_car_state.dart';

// Used to store the data submitted by the user, such as contacts, mosquito bites, etc.
class TigerInCarDatabase {
  static final TigerInCarDatabase instance = TigerInCarDatabase._init();

  static Database? _database;

  TigerInCarDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tigerInCarStorage.db');
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

    await db.execute('''
      CREATE TABLE $tableTigerInCar(
        ${TigerInCarFields.id} $idType,
        ${TigerInCarFields.millisecondsSinceEpoch} $stringType,
        ${TigerInCarFields.isAlive} $stringType,
      )   
    ''');
  }

  Future<TigerInCarState> create(TigerInCarState state) async {
    final db = await instance.database;

    final id = await db.insert(tableTigerInCar, state.toJson());
    return state.copy(id: id);
  }

  Future<Contact> readState(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableContacts,
      columns: ContactFields.values,
      where: '${ContactFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Contact.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Contact>> readAllContacts() async {
    final db = await instance.database;

    final result = await db.query(tableContacts);

    return result.map((json) => Contact.fromJson(json)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    final db = await instance.database;

    return db.update(
      tableContacts,
      contact.toJson(),
      where: '${ContactFields.id} = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await instance.database;

    return await db.delete(tableContacts,
        where: '${ContactFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
