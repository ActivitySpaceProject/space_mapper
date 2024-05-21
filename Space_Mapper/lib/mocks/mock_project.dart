import '../models/project.dart';
import '../db/database_project.dart';

mixin MockProject implements Project {
  static List<Project> items = [];

  static Future<void> populateItemsFromDatabase() async {
    final projects = await ProjectDatabase.instance.FetchAllProjects();

    items = projects.map((project) {
      return Project(
        project.projectId ??
            -1, // Replace with the actual field name from your database
        project
            .projectName, // Replace with the actual field name from your database
        project.projectDescription ??
            "", // Replace with the actual field name from your database
        project
            .externalLink, // Replace with the actual field name from your database
        project
            .internalLink, // Replace with the actual field name from your database
        project.projectImageLocation ??
            "", // Replace with the actual field name from your database
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

  static Future<List<Project>> fetchAll() async {
    await populateItemsFromDatabase();
    return items;
  }

  static Future<Project> fetchByID(int projectId) async {
    await populateItemsFromDatabase();

    try {
      // Find the project by ID instead of by index
      final project = items.firstWhere((project) => project.id == projectId);
      return project;
    } catch (e) {
      throw Exception('Project with ID $projectId not found');
    }
  }
}
