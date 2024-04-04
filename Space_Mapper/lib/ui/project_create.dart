import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../external_projects/tiger_in_car/models/project_list.dart';
import '../db/database_project_list.dart';

class ProjectCreation extends StatefulWidget {
  @override
  _ProjectCreationState createState() => _ProjectCreationState();
}

class _ProjectCreationState extends State<ProjectCreation> {
  final TextEditingController _controller = TextEditingController();
  String finalUrl = '';
  Map<String, dynamic> fetchedData = {};
  bool isDataFetched = false; // To check if the data is fetched and ready for display

  Future<void> fetchProjectData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          fetchedData = json.decode(response.body);
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
      await ProjectDatabaseList.instance.createProject(project);
      print("Project inserted successfully.");
      // Optionally, show a success message or navigate away
    } catch (e) {
      print(e);
      // Handle errors, perhaps show an alert or a Snackbar
    }
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
            ElevatedButton(
              onPressed: () {
                String projectName = _controller.text.trim();
                finalUrl = "https://stuffjoy.github.io/space-mapper-projects/$projectName.json";
                fetchProjectData(finalUrl);
              },
              child: Text('Fetch Project'),
            ),
            if (isDataFetched) ...[
              Text('Name: ${fetchedData['projectName']}'),
              Text('Description: ${fetchedData['projectDescription']}'),
              ElevatedButton(
                onPressed: insertProjectIntoDB,
                child: Text('Confirm and Save Project'),
              ),
            ] else if (!isDataFetched && finalUrl.isNotEmpty) ...[
              Text('No project data found or failed to fetch project.'),
            ],
          ],
        ),
      ),
    );
  }
}
