import '../models/project.dart';
import '../db/database_project.dart';

mixin ParticpatingProjects implements Project {
  static List<Project> items = [];

  static Future<void> populateItemsFromDatabase() async {
    final projects = await ProjectDatabase.instance.getOngoingProjects(); 

    items = projects.map((project) {
      return Project(
        project.projectId ?? -1, 
        project.projectName, 
        project.projectDescription ?? "", 
        project.externalLink, 
        project.internalLink, 
        project.projectImageLocation ?? "", 
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

  static Project fetchByID(int index) {
    populateItemsFromDatabase();
    if (index >= 0 && index < items.length) {
      return items[index];
    }
    throw Exception('Invalid project index');
  }
}
