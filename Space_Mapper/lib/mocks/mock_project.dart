/*
import '../models/project.dart';

mixin MockProject implements Project {
  static final List<Project> items = [
    Project(
      0,
      "Human Mobility Project Test",
      "The Human Mobility Project is aimed at better understanding how patterns of human movement and activities are changing in the context of climate change.",
      "https://ee.kobotoolbox.org/single/O5DDmZ06",
      null,
      "https://activityspaceproject.com/images/BuffSim3D_sampleof10.png",
      1,
      'aMz7EhF3ZpzMvNUMwtR4eN' // location sharing only through form
    ),
    Project(
      1,
      "Public Space Observer",
      "This project is for sociologists carrying out systematic observations of public spaces.",
      "https://ee.kobotoolbox.org/single/1FUvZ7RD",
      null,
      "https://upload.wikimedia.org/wikipedia/commons/e/e8/Barcelona_2016-307.jpg",
      1,
      'aC4pD9cVr5NSZaFCFWyg4Z' // location sharing only through form
    ),
      Project(
      2,
      "Mosquito On Board",
      "'Mosquito On Board' is a closed project being carried out by scientists in Spain to study the survival of tiger mosquitoes in cars. You must be registered to participate.",
      "https://ee.kobotoolbox.org/single/aCVvkv5V",
      null,//'/project_tiger_in_car',
      "https://www.periodismociudadano.com/wp-content/uploads/2020/11/mosquito-49141_640.jpg",      
      1, // location sharing only through form
      'aKNGJqKdqjLMfJEtYk7f5U'
    )
  ];

  static Project fetchFirst() {
    return items[0];
  }

  static fetchAll() {
    return items;
  }

  static Project fetchByID(int index) {
    return items[index];
  }
}
*/

import '../models/project.dart';
import '../db/database_project.dart';

mixin MockProject implements Project {
  static List<Project> items = [];

  static Future<void> populateItemsFromDatabase() async {
    final projects = await ProjectDatabase.instance.readAllProjects(); 

    items = projects.map((project) {
      return Project(
        project.projectId ?? -1, // Replace with the actual field name from your database
        project.projectName, // Replace with the actual field name from your database
        project.projectDescription ?? "", // Replace with the actual field name from your database
        project.externalLink, // Replace with the actual field name from your database
        project.internalLink, // Replace with the actual field name from your database
        project.projectImageLocation ?? "", // Replace with the actual field name from your database
        project.locationSharingMethod,
        project.surveyElementCode,
      );
    }).toList();
  }

  static Project fetchFirst() {
    populateItemsFromDatabase();
    if (items.isNotEmpty) {
      return items[0];
    }
    throw Exception('No projects available');
  }

  //static List<Project> fetchAll() {
    static Future <List<Project>> fetchAll() async {
    await populateItemsFromDatabase();
    return items;
  }
/*
  static Project fetchByID(int index) {
    populateItemsFromDatabase();
    print("index test $index and item length is ${items.length} and items are $items");
    //if (index >= 0 && index < items.length) {
    if (index >= 0) {
      return items[index];
    }
    throw Exception('Invalid project index');
  }*/
/*
  static Future<Project> fetchByID(int index) async {
  await populateItemsFromDatabase();
  print("index test $index and item length is ${items.length} and items are $items");
  if (index >= 0 && index < items.length) {
    return items[index];
  } else {
    throw Exception('Invalid project index');
  }
}
*/
static Future<Project> fetchByID(int projectId) async {
  await populateItemsFromDatabase();
  
  try {
    // Find the project by ID instead of by index
    final project = items.firstWhere((project) => project.id == projectId);
    return project;
  } catch (e) {
    // If no project is found with the given ID, throw an exception
    throw Exception('Project with ID $projectId not found');
  }
}
}
