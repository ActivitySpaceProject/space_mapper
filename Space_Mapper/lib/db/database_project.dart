import '../external_projects/tiger_in_car/models/participating_projects.dart';
import '../external_projects/tiger_in_car/models/project_list.dart';

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

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
    //return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final intType = 'INTEGER NOT NULL';
    final stringType = 'STRING NOT NULL';
    final NullstringType = 'STRING';

    await db.execute('''
      CREATE TABLE $tableProject(
        ${ProjectFields.projectNumber} $idType,
        ${ProjectFields.projectId} $intType,
        ${ProjectFields.projectName} $stringType,
        ${ProjectFields.projectDescription} $stringType,
        ${ProjectFields.externalLink} $NullstringType,
        ${ProjectFields.internalLink} $NullstringType,
        ${ProjectFields.projectImageLocation} $stringType,
        ${ProjectFields.duration} $stringType,
        ${ProjectFields.startDate} $stringType,
        ${ProjectFields.endDate} $stringType,
        ${ProjectFields.projectStatus} $stringType,
        ${ProjectFields.locationSharingMethod} $intType,
        ${ProjectFields.surveyElementCode} $stringType
      )   
    ''');

        await db.execute('''
    CREATE TABLE $tableProjectList (
      ${ProjectListFields.projectId} $idType,
      ${ProjectListFields.projectName} $stringType,
      ${ProjectListFields.projectDescription} $stringType,
      ${ProjectListFields.externalLink} $NullstringType,
      ${ProjectListFields.internalLink} $NullstringType,
      ${ProjectListFields.projectImageLocation} $stringType,
      ${ProjectListFields.locationSharingMethod} INTEGER NOT NULL,
      ${ProjectListFields.surveyElementCode} $stringType,
      ${ProjectListFields.projectURL} $stringType
    )
    ''');
  }

Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    
    final NullstringType = 'STRING'; 
    await db.execute('''
      CREATE TABLE $tableProjectList (
        ${ProjectListFields.projectId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ProjectListFields.projectName} STRING NOT NULL,
        ${ProjectListFields.projectDescription} STRING NOT NULL,
        ${ProjectListFields.externalLink} $NullstringType,
        ${ProjectListFields.internalLink} $NullstringType,
        ${ProjectListFields.projectImageLocation} STRING NOT NULL,
        ${ProjectListFields.locationSharingMethod} INTEGER NOT NULL,
        ${ProjectListFields.surveyElementCode} STRING NOT NULL,
        ${ProjectListFields.projectURL} STRING NOT NULL
      )
    ''');
  }
  
}
//Procedures for projects user has joined
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
      where: '${ProjectFields.projectNumber} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Particpating_Project.fromJson(maps.first);
    } else {
      return Particpating_Project(
      projectId: -1,
      projectName: '-1',
      projectDescription: '-1',
      externalLink: '-1',
      internalLink: '-1',
      projectImageLocation: '-1',
      duration: -1,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      projectStatus: '-1',
      locationSharingMethod: -1,
      surveyElementCode: '-1',
    );
    }
  }



  Future<List<Particpating_Project>> getOngoingProjects() async {
    final db = await instance.database;
    
    final maps = await db.query(
      tableProject,
      where: '${ProjectFields.projectStatus} = ?',
      whereArgs: ['ongoing'],
    );

    return maps.map((json) => Particpating_Project.fromJson(json)).toList();

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

  Future<void> updateAllProjectStatusToFinish() async {
    final db = await instance.database;

    // Update all records to have projectstatus as "finish"
    await db.update(
      tableProject,
      {ProjectFields.projectStatus: 'ending'},
    );
  }


  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<void> updateProjectStatusBasedOnEndDate() async {
  final db = await instance.database;
  final currentTime = DateTime.now();

  final projects = await db.query(tableProject);

  for (var project in projects) {
    print('Project end date pre : ${project[ProjectFields.endDate]}');
    final endDate = project[ProjectFields.endDate];
    print('Project current time : ${currentTime}');
    print('Project end date post : ${DateTime.parse(endDate.toString())}');
    
    // Check if today's date and time is greater than the end date
    if (currentTime.isAfter(DateTime.parse(endDate.toString()))) {
      await db.update(
        tableProject,
        {ProjectFields.projectStatus: 'ending'},
        where: '${ProjectFields.projectNumber} = ?',
        whereArgs: [project[ProjectFields.projectNumber]],
      );
    }
  }
}

Future<void> updateProjectStatusBasedOnProjectNUmber(int? id, String status) async {
final db = await instance.database;

    await db.update(
      tableProject,
      {ProjectFields.projectStatus: status},
      where: '${ProjectFields.projectNumber} = ?', 
      whereArgs: [id]);
  }


//List of projects user has loaded onto their phone

  Future<ProjectList> createNewProject(ProjectList project) async {
    final db = await instance.database;
    print("It made it into createProject");
    final id = await db.insert(tableProjectList, project.toJson());
    return project.copy(projectId: id);
  }

  Future<ProjectList> RetrieveProject(int id) async {
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

  Future<ProjectList> RetrieveProjectbyURL(String URL) async {
    final db = await instance.database;
    final maps = await db.query(
      tableProjectList,
      columns: ProjectListFields.values,
      where: '${ProjectListFields.projectURL} = ?',
      whereArgs: [URL],
    );

    if (maps.isNotEmpty) {
      return ProjectList.fromJson(maps.first);
    } else {
      return ProjectList(
      projectId: -1,
      projectName: '-1',
      projectDescription: '-1',
      externalLink: '-1',
      internalLink: '-1',
      projectImageLocation: '-1',
      locationSharingMethod: -1,
      surveyElementCode: '-1',
    );
    }
  }

  Future<List<ProjectList>> FetchAllProjects() async {
    final db = await instance.database;
    final result = await db.query(tableProjectList);
    return result.map((json) => ProjectList.fromJson(json)).toList();
  }

  Future<int> updateProjectList(ProjectList project) async {
    final db = await instance.database;
    return db.update(
      tableProjectList,
      project.toJson(),
      where: '${ProjectListFields.projectId} = ?',
      whereArgs: [project.projectId],
    );
  }

  Future<int> deleteProjectList(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableProjectList,
      where: '${ProjectListFields.projectId} = ?',
      whereArgs: [id],
    );
  }



}

