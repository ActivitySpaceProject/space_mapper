import 'package:asm/models/project.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:asm/main.dart';
import '../external_projects/tiger_in_car/models/project_list.dart';
//import '../db/database_project_list.dart';
import '../db/database_project.dart';
import '../components/banner_image.dart';
import '../components/project_tile.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ProjectCreation extends StatefulWidget {
  @override
  _ProjectCreationState createState() => _ProjectCreationState();
}

class _ProjectCreationState extends State<ProjectCreation> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _repoNameController =
      TextEditingController(text: 'space-mapper-projects');
  String? finalUrl;
  Map<String, dynamic> fetchedData = {};
  bool isDataFetched =
      false; // To check if the data is fetched and ready for display
  bool projectExists = false; // To check if the project already exists
  bool fetchAttempted = false;
  String? existingprojectImageLocation;
  Project? existingProject;
  Project? project; // This will hold the Project instance for the fetched data

  void _scanQRCode() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QRView(
              key: GlobalKey(debugLabel: 'QR'),
              onQRViewCreated: (QRViewController controller) {
                controller.scannedDataStream.listen((scanData) {
                  controller.pauseCamera();
                  Navigator.of(context).pop(); // Close the QR scan page
                  print("scan data ${scanData.code}");
                  _handleFetchProject(scanData.code);
                  finalUrl = scanData.code;
                  // You may want to parse `finalUrl` or directly use it
                });
              },
            )));
  }

  void _handleFetchProject([String? finalUrl]) async {
    this.fetchAttempted = true;
    ProjectList? project_exists =
        await ProjectDatabase.instance.RetrieveProjectbyURL(finalUrl!);
    if (project_exists.projectId != -1) {
      // Project exists
      print(
          "Project already exists: project_exists.projectId ${project_exists.projectId}");
      print("it does exist: $finalUrl");
      setState(() {
        this.projectExists = true;
        existingprojectImageLocation = project_exists.projectImageLocation;
        existingProject = project_exists.toProject();
      });
    } else {
      setState(() {
        this.projectExists = false;
        print(
            "Project does not exists: project_exists.projectId ${project_exists.projectId}");
        print("it does NOT exist: $finalUrl");
        //finalUrl = constructedUrl; // Update finalUrl for subsequent actions
        fetchProjectData(finalUrl);
      });
    }
  }

  Future<void> fetchProjectData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          fetchedData = json.decode(response.body);
          // Create a Project instance from fetchedData here
          project = Project(
            0, // dummy ID
            fetchedData['projectName'] ?? '',
            fetchedData['projectDescription'] ?? '',
            fetchedData['externalLink'], // Nullable
            fetchedData['internalLink'],
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
    print(
        "exisiting record: $projectExists, fetch attempted: $fetchAttempted, was data fetched: $isDataFetched");
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
      ProjectList createdProject =
          await ProjectDatabase.instance.createNewProject(project);
      GlobalData.user_available_projects = true;
      setState(() {});
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Create Project"),
      ),
      body: SingleChildScrollView(
        child: Container(
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
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Project Account Name',
                  hintText: 'Enter Project account name here',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _repoNameController,
                decoration: InputDecoration(
                  labelText: 'Project Repository Name',
                  hintText: 'Enter repository name here',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String projectName = _controller.text.trim().toLowerCase();
                  String userName =
                      _usernameController.text.trim().toLowerCase();
                  String repoName =
                      _repoNameController.text.trim().toLowerCase();
                  projectName = cleanAndReplaceSpaces(projectName);
                  userName = cleanAndReplaceSpaces(userName);
                  //repoName = cleanAndReplaceSpaces(repoName);
                  finalUrl =
                      "https://$userName.github.io/$repoName/$projectName.json";
                  print("finalurl $finalUrl");
                  _handleFetchProject(finalUrl);
                },
                child: Text('Fetch Project'),
              ),
              // The button to scan a QR code
              ElevatedButton(
                onPressed: _scanQRCode,
                child: Text('Scan URL QR Code'),
              ),
              if (isDataFetched) ...[
                BannerImage(
                    url: fetchedData['projectImageLocation'], height: 200.0),
                ProjectTile(project: project!, darkTheme: false),
                ElevatedButton(
                  onPressed: insertProjectIntoDB,
                  child: Text('Save and View Project'),
                ),
              ] else if (!isDataFetched && projectExists) ...[
                BannerImage(
                    url: existingprojectImageLocation ?? "", height: 200.0),
                ProjectTile(project: existingProject!, darkTheme: false),
                ElevatedButton(
                  onPressed: () {
                    //_navigationToProjectDetail(context, existingProject!.id); Commented out before it would sometimes create a duplicate project entry
                    Navigator.of(context)
                        .pushNamed('/participate_in_a_project');
                  },
                  child: Text('View Project'),
                ),
              ] else if (!isDataFetched &&
                  !projectExists &&
                  fetchAttempted) ...[
                Text('No project data found or failed to fetch project.')
              ],
            ],
          ),
        ),
      ),
    );
  }
}
