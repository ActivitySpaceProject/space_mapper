import '../external_projects/tiger_in_car/models/participating_projects.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Used to store the data related to projects
class ProjectDatabase {
  static final ProjectDatabase instance = ProjectDatabase._init();

  static Database? _database;

  ProjectDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('project_storage.db');
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
      CREATE TABLE $tableProject(
        ${ProjectFields.projectId} $idType,
        ${ProjectFields.projectName} $stringType,
        ${ProjectFields.duration} $stringType,
        ${ProjectFields.startDate} $stringType,
        ${ProjectFields.endDate} $stringType
      )   
    ''');
  }

  Future<Particpating_Project> createProject(Particpating_Project project) async {
    final db = await instance.database;

    final id = await db.insert(tableProject, project.toJson());
    return project.copy(projectId: id);
  }

  Future<Particpating_Project> readProject(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableProject,
      columns: ProjectFields.values,
      where: '${ProjectFields.projectId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Particpating_Project.fromJson(maps.first);
    } else {
      return Particpating_Project(
      projectId: -1,
      projectName: '-1',
      duration: -1,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );
    }
  }

  Future<List<Particpating_Project>> readAllProjects() async {
    final db = await instance.database;

    final result = await db.query(tableProject);

    return result.map((json) => Particpating_Project.fromJson(json)).toList();
  }

  Future<int> updateProject(Particpating_Project project) async {
    final db = await instance.database;

    return db.update(
      tableProject,
      project.toJson(),
      where: '${ProjectFields.projectId} = ?',
      whereArgs: [project.projectId],
    );
  }

  Future<int> deleteProject(int id) async {
    final db = await instance.database;

    return await db.delete(tableProject,
        where: '${ProjectFields.projectId} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
