import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:asm/model/spacetime_observation.dart';
import 'package:sqflite/sqflite.dart';

const DB_NAME = "SpaceMapperDB.db";

const SPACETIME_OBSERVATION_TABLE_NAME = "SpacetimeObservation";

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE " + SPACETIME_OBSERVATION_TABLE_NAME + "("
              "id INTEGER PRIMARY KEY,"
              "time REAL,"
              "longitude REAL,"
              "latitude REAL,"
              "altitude REAL,"
              "accuracy REAL,"
              "source TEXT,"
              "moving INTEGER,"
              "travel_mode TEXT,"
              "nearest_cell_ID TEXT"
              ")");
        });
  }

  newSpacetimeObservation(SpacetimeObservation newSpacetimeObservation) async {
    final db = await database;
    var res = db.insert(SPACETIME_OBSERVATION_TABLE_NAME, newSpacetimeObservation.toMap());
    return res;
  }

  updateSpacetimeObservation(SpacetimeObservation newSpacetimeObservation) async {
    final db = await database;
    var res = await db.update(SPACETIME_OBSERVATION_TABLE_NAME, newSpacetimeObservation.toMap(),
        where: "id = ?", whereArgs: [newSpacetimeObservation.id]);
    return res;
  }

  getSpacetimeObservation(int id) async {
    final db = await database;
    var res = await db.query(SPACETIME_OBSERVATION_TABLE_NAME, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? SpacetimeObservation.fromMap(res.first) : null;
  }

  Future<List<SpacetimeObservation>> getAllSpacetimeObservations() async {
    final db = await database;
    var res = await db.query(SPACETIME_OBSERVATION_TABLE_NAME);
    List<SpacetimeObservation> list =
    res.isNotEmpty ? res.map((c) => SpacetimeObservation.fromMap(c)).toList() : [];
    return list;
  }

  deleteSpacetimeObservation(int id) async {
    final db = await database;
    return db.delete(SPACETIME_OBSERVATION_TABLE_NAME, where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from " + SPACETIME_OBSERVATION_TABLE_NAME);
  }
}