import 'package:asm/models/project.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../external_projects/tiger_in_car/models/project_list.dart';
//import '../db/database_project_list.dart';
import '../db/database_project.dart';
import '../components/banner_image.dart';
import '../components/project_tile.dart';

class ProjectCreation extends StatefulWidget {
  @override
  _ProjectCreationState createState() => _ProjectCreationState();
}

class _ProjectCreationState extends State<ProjectCreation> {
  final TextEditingController _controller = TextEditingController();
  String finalUrl = '';
  Map<String, dynamic> fetchedData = {};
  bool isDataFetched = false; // To check if the data is fetched and ready for display
  bool projectExists = false; // To check if the project already exists
  bool fetchAttempted = false;
  String? existingprojectImageLocation;
  Project? existingProject; 
  Project? project; // This will hold the Project instance for the fetched data

  Future<void> fetchProjectData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          fetchedData = json.decode(response.body);
          // Create a Project instance from fetchedData here
          project = Project(
            0, // Assuming a dummy ID as the fetched data may not contain an ID
            fetchedData['projectName'] ?? '',
            fetchedData['projectDescription'] ?? '',
            fetchedData['externalLink'], // Nullable
            fetchedData['internalLink'], // Nullable, assuming this is the projectScreen
            fetchedData['projectImageLocation'] ?? '',
            fetchedData['locationSharingMethod'] ?? 0,
            fetchedData['surveyElementCode'] ?? '',
          );
          isDataFetched = true;
        });
      } else {
        setState(() {
          isDataFetched = false;
        });
        throw Exception('Failed to load project');
      }
    } catch (e) {
      print(e);
      setState(() {
        isDataFetched = false;
      });
      // Optionally, show an alert dialog with the error
    }
    print("exisiting record: $projectExists, fetch attempted: $fetchAttempted, was data fetched: $isDataFetched");
  }

  Future<void> insertProjectIntoDB() async {
    try {
      // Create a ProjectList instance using the fetched data
      ProjectList project = ProjectList(
        projectName: fetchedData['projectName'],
        projectDescription: fetchedData['projectDescription'],
        externalLink: fetchedData['externalLink'],
        internalLink: fetchedData['internalLink'],
        projectImageLocation: fetchedData['projectImageLocation'],
        locationSharingMethod: fetchedData['locationSharingMethod'],
        surveyElementCode: fetchedData['surveyElementCode'],
        projectURL: finalUrl,
      );

      // Insert the project into the database
      ProjectList createdProject = await ProjectDatabase.instance.createNewProject(project);
      print("Project inserted successfully.");
      _navigationToProjectDetail(context, createdProject.projectId!);
      // Optionally, show a success message or navigate away
      //Navigator.of(context).pushNamed('/participate_in_a_project');
    } catch (e) {
      print(e);
      // Handle errors, perhaps show an alert or a Snackbar
    }
  }

  String cleanAndReplaceSpaces(String input) {
    // First, replace spaces with underscores
    String withUnderscores = input.replaceAll(' ', '_');
    // Then, remove all characters except letters, digits, and underscores
    final pattern = RegExp('[^a-zA-Z0-9_]');
    return withUnderscores.replaceAll(pattern, '');
  }

  void _navigationToProjectDetail(BuildContext context, int projectID) {
    Navigator.of(context).pushNamed('/project_detail', arguments: projectID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Project"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Project Name',
                hintText: 'Enter your project name here',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton (
              onPressed: () async {
                String projectName = _controller.text.trim().toLowerCase();
                projectName = cleanAndReplaceSpaces(projectName);
                finalUrl = "https://stuffjoy.github.io/space-mapper-projects/$projectName.json";
                this.fetchAttempted = true;
                ProjectList? project_exists = await ProjectDatabase.instance.RetrieveProjectbyURL(finalUrl);
                  if (project_exists.projectId != -1) {
                    // Project exists
                    // Handle the case, e.g., show a message to the user
                    print("Project already exists.");
                    print("Project already exists. ${project_exists.projectImageLocation}");
                    print("Project already exists. ${project_exists.toProject()}");
                    setState(() {
                      this.projectExists = true;
                      existingprojectImageLocation = project_exists.projectImageLocation;
                      existingProject = project_exists.toProject();
                      //BannerImage(url: project_exists.projectImageLocation ?? "", height: 200.0);
                      //ProjectTile(project: project_exists.toProject(), darkTheme: false);
                    });
                  } else {
                    setState(() {
                    this.projectExists = false;
                    fetchProjectData(finalUrl);
                    print("Project does not exists.");
                        print("exisiting record: $projectExists, fetch attempted: $fetchAttempted, was data fetched: $isDataFetched");
});
                  }
              },
              child: Text('Fetch Project'),
            ),
            if (isDataFetched) ...[
              BannerImage(url: fetchedData['projectImageLocation'], height: 200.0),
              ProjectTile(project: project!, darkTheme: false), 
              ElevatedButton(
                onPressed: insertProjectIntoDB,
                child: Text('Save and View Project'),
              ),
            ] else if (!isDataFetched && projectExists) ...[
                      BannerImage(url: existingprojectImageLocation ?? "", height: 200.0),
                      ProjectTile(project: existingProject!, darkTheme: false),
                      ElevatedButton(
                onPressed: () {
                      _navigationToProjectDetail(context, existingProject!.id);
                  },
                child: Text('View Project'),
                      ),
            ] else if (!isDataFetched && !projectExists && fetchAttempted) ...[
                      Text('No project data found or failed to fetch project.')
            ],
          ],
        ),
      ),
    );
  }
}
