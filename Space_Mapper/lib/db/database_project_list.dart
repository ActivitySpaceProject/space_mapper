/* Page to be deleted

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../external_projects/tiger_in_car/models/project_list.dart';

class ProjectDatabaseList {
  static final ProjectDatabaseList instance = ProjectDatabaseList._init();

  static Database? _database;

  ProjectDatabaseList._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('project_storage.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final stringType = 'TEXT NOT NULL';
    final nullStringType = 'TEXT';

    await db.execute('''
    CREATE TABLE $tableProjectList (
      ${ProjectListFields.projectId} $idType,
      ${ProjectListFields.projectName} $stringType,
      ${ProjectListFields.projectDescription} $stringType,
      ${ProjectListFields.externalLink} $nullStringType,
      ${ProjectListFields.internalLink} $nullStringType,
      ${ProjectListFields.projectImageLocation} $stringType,
      ${ProjectListFields.locationSharingMethod} INTEGER NOT NULL,
      ${ProjectListFields.surveyElementCode} $stringType,
      ${ProjectListFields.projectURL} $stringType
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // If old version is less than 2, create the 'project_list' table
      print("_onUpgrade old version is $oldVersion and new version is $newVersion");
      await _createDB(db, newVersion); // You can call _createDB directly if version 2 is where you introduce the 'project_list' table
    }
    // Add further schema upgrade logic here for future versions
  }

  Future<ProjectList> createProject(ProjectList project) async {
    final db = await instance.database;
    print("It made it into createProject");
    final id = await db.insert(tableProjectList, project.toJson());
    return project.copy(projectId: id);
  }

  Future<ProjectList> readProject(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableProjectList,
      columns: ProjectListFields.values,
      where: '${ProjectListFields.projectId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ProjectList.fromJson(maps.first);
    } else {
      throw Exception('Project ID $id not found');
    }
  }

  Future<List<ProjectList>> readAllProjects() async {
    final db = await instance.database;
    final result = await db.query(tableProjectList);
    return result.map((json) => ProjectList.fromJson(json)).toList();
  }

  Future<int> updateProject(ProjectList project) async {
    final db = await instance.database;
    return db.update(
      tableProjectList,
      project.toJson(),
      where: '${ProjectListFields.projectId} = ?',
      whereArgs: [project.projectId],
    );
  }

  Future<int> deleteProject(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableProjectList,
      where: '${ProjectListFields.projectId} = ?',
      whereArgs: [id],
    );
  }
  

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
*/