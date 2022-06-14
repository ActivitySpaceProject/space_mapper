import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/locations_to_push.dart';

// Store the locations that have not been pushed to the API, to later try again to push them
// How to use
// 1. Try to submit the location to the API using the SendDataToAPI class. 
// 2. If it fails, the location is then stored on this local database
// 3. After a successful submit to the server API, the program will try again to send the locations stored locally 
class UnPushedLocationsDatabase {
  static final UnPushedLocationsDatabase instance = UnPushedLocationsDatabase._init();

  static Database? _database;

  UnPushedLocationsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('unpushedLocationsStorage.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final stringType = 'STRING';
    final doubleType = 'DOUBLE';

    await db.execute('''
      CREATE TABLE $tableName(
        "_id" $idType,
        "userUUID" $stringType,
        "user_code" $stringType,
        "app_version" $stringType,
        "operativeSystem" $stringType,
        "typeOfData" $stringType,
        "message" $stringType,
        "longitude" $doubleType,
        "latitude" $doubleType,
        "unixTime" $stringType,
        "speed" $stringType,
        "activity" $stringType,
        "altitude" $stringType
      )   
    ''');
  }

  Future<LocationToPush> createRecord(LocationToPush location) async {
    final db = await instance.database;

    final id = await db.insert(tableName, location.toJson());
    return location.copy(id: id);
  }

  Future<LocationToPush> readState(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableName,
      columns: LocationToPushFields.values,
      where: '${LocationToPushFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return LocationToPush.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<LocationToPush>> readAllRecords() async {
    final db = await instance.database;

    final result = await db.query(tableName);

    return result.map((json) => LocationToPush.fromJson(json)).toList();
  }

  Future<int> deleteRecord(String userUUID) async {
    final db = await instance.database;

    return await db.delete(tableName,
        where: '${LocationToPushFields.userUUID} = ?', whereArgs: [userUUID]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<int?> getAmountOfRows() async{
    final db = await instance.database;

    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));

    return count;
  }  
}
