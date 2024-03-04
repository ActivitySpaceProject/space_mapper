import '../models/project.dart';
import '../db/database_project.dart';

mixin ParticpatingProjects implements Project {
  static List<Project> items = [];

  static Future<void> populateItemsFromDatabase() async {
    final projects = await ProjectDatabase.instance.getOngoingProjects(); // Assuming this function fetches data from your database

    items = projects.map((project) {
      return Project(
        project.projectId ?? -1, // Replace with the actual field name from your database
        project.projectName, // Replace with the actual field name from your database
        project.projectDescription ?? "", // Replace with the actual field name from your database
        project.externalLink, // Replace with the actual field name from your database
        project.internalLink, // Replace with the actual field name from your database
        project.projectImageLocation ?? "", // Replace with the actual field name from your database
        project.locationSharingMethod,
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
