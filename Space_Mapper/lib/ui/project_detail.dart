import 'dart:convert';

import 'package:asm/main.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter/material.dart';
import '../models/send_data_to_api.dart';
import '../models/app_localizations.dart';
import '../components/banner_image.dart';
import '../components/project_tile.dart';
import '../mocks/mock_project.dart';
import '../models/project.dart';
import '../models/custom_locations.dart';
import '../styles.dart';
import '../external_projects/tiger_in_car/models/participating_projects.dart';
import '../db/database_project.dart';
//import '../../main.dart';
import 'package:asm/external_projects/tiger_in_car/models/tiger_in_car_state.dart';
import 'package:asm/external_projects/tiger_in_car/models/send_data_to_api.dart';

const BannerImageHeight = 300.0;
const BodyVerticalPadding = 20.0;
const FooterHeight = 100.0;

class GlobalProjectData {
  static int? active_project_number;
  static String active_project_status = "";
  static String generatedUrl = "";
}

class ProjectDetail extends StatefulWidget {
  final int projectID;

  ProjectDetail(this.projectID);

  @override
  _ProjectDetailState createState() => _ProjectDetailState(projectID);
}

class _ProjectDetailState extends State<ProjectDetail> {
  final int projectID;
  Project project = Project.blank();
  bool consent = false;
  int dropdownValue = 7;
  bool createNewRecord = true;
  String statusToSet = 'ongoing';
  String surveyType = 'starting';
  //int? active_project_number;
  String active_project_url = "";
  bool endButtonPressed = false;

  _ProjectDetailState(this.projectID);

  @override
  void initState() {
    super.initState();
    loadData();
    checkParticipationStatus().then((status) {
      setState(() {
        if(status == 'empty'){ // If empty, the user has never participated, so we need a new record in the DB. Survey is starting and status will be set as ongoing for next time.
          createNewRecord = true;
          surveyType = 'starting';
          statusToSet = 'ongoing';
        } else if(status == 'ongoing'){
          createNewRecord = false;
          surveyType = 'ongoing';
          statusToSet = 'ongoing';
        } else if(status == 'ending'){ //In this case the user pressed end the last time so status was set to ending. User is now starting again, so survey type is starting the status will be saved as ongoing
          createNewRecord = false;
          surveyType = 'starting';
          statusToSet = 'ongoing';
        }
      });
    });

    // Call the function to update project status based on end date
    ProjectDatabase.instance.updateProjectStatusBasedOnEndDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              AppLocalizations.of(context)?.translate("about_the_project") ??
                  "")),
      body: Stack(
        children: [
          _renderBody(context, project),
          _renderFooter(context),
        ],
      ),
    );
  }

  loadData() {
    final project = MockProject.fetchByID(this.projectID);

    if (mounted) {
      setState(() {
        this.project = project;
        print('Fetched project details: ${project.name}');
      });
    }
  }

/*
  Widget _renderBody(BuildContext context, Project project) {
    var result = <Widget>[];
    result.add(BannerImage(url: project.imageUrl, height: BannerImageHeight));
    result.add(_renderHeader());
    result.add(_renderConsentForm());
    if (consent) result.add(_renderFrequencyChooser());
    result.add(_renderBottomSpacer());
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: result));
  }
*/
Widget _renderBody(BuildContext context, Project project) {
  var result = <Widget>[];
  result.add(BannerImage(url: project.imageUrl, height: BannerImageHeight));
  result.add(_renderHeader());

  // Check if the user is already participating
  if (surveyType != 'starting') {
    result.add(_renderAlreadyParticipatingMessage());
  } else {
    result.add(_renderConsentForm());
    // NOTE TEMPORARILY TAKING THIS OUT:
    // result.add(_renderFrequencyChooser());
  }


  result.add(_renderBottomSpacer());
  return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: result));
}

Widget _renderAlreadyParticipatingMessage() {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        Text(
          "You are already participating in a project. You can go to your active project by clicking the button below.",
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 20.0),
      ],
    ),
  );
}

  Widget _renderHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: BodyVerticalPadding,
          horizontal: Styles.horizontalPaddingDefault),
      child: ProjectTile(project: project, darkTheme: false),
    );
  }

  Widget _renderFooter(BuildContext contexty) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
          height: FooterHeight,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: _renderParticipateInProjectButton(),
          ),
        )
      ],
    );
  }

  Widget _renderConsentForm() {
    print('Project name in _renderConsentForm: ${project.name}');
    String title =
        AppLocalizations.of(context)?.translate("consent_form") ?? "";
  /*  String text = AppLocalizations.of(context)
            ?.translate("do_you_agree_to_share_your_anonymous_location_with") ??
        "" + "${project.name}?";*/
String text = (AppLocalizations.of(context)
        ?.translate("do_you_agree_to_share_your_anonymous_location_with") ??
    "") + "${project.name}?";

    return Container(
      height: ProjectTileHeight,
      padding: EdgeInsets.symmetric(
          //vertical: BodyVerticalPadding,
          horizontal: Styles.horizontalPaddingDefault),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Styles.projectTileTitleLight),
          Row(
            children: [
              Checkbox(
                value: consent,
                onChanged: (bool? newValue) {
                  setState(() {
                    consent = newValue!;
                  });
                },
              ),
              Expanded(
                child: Text('$text',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: Styles.projectTileCaption),
              )
            ],
          ),
        ],
      ),
    );
  }

// COMMENTING THIS OUT UNTIL WE START USING IT
/*   Widget _renderFrequencyChooser() {
    String title = "Days to share";

    return Container(
      height: ProjectTileHeight,
      padding: EdgeInsets.symmetric(
          //vertical: BodyVerticalPadding,
          horizontal: Styles.horizontalPaddingDefault),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Styles.projectTileTitleLight),
          DropdownButton(
            value: dropdownValue,
            onChanged: (int? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <int>[1, 7, 30, 365].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text("$value"),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
 */
  Widget _renderParticipateInProjectButton() {

  // Hide the button if already participating
  if (!createNewRecord) {
    //return SizedBox.shrink();
  }

    print('is person already paticipating in project : ${!createNewRecord}');

    return Row (children: [
      /*if (alreadyParticipating)
        Expanded(
          child: TextButton(*/
          Expanded(
        child: TextButton(
          //color: Styles.accentColor,
          //textColor: Styles.textColorBright,
          style: ButtonStyle(
            //backgroundColor: MaterialStateProperty.all(Colors.red),
            //foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: (consent || surveyType == 'ongoing')
                ? MaterialStateProperty.all(Colors.blue)
                : MaterialStateProperty.all(Colors.grey),  // Use grey color when consent is false
            foregroundColor: (consent || surveyType == 'ongoing')
                ? MaterialStateProperty.all(Colors.white)
                : MaterialStateProperty.all(Colors.black),
          ),
          /*onPressed: () {
            endButtonPressed = true; // Set the flag when the "End" button is pressed
            _navigationToProject(context);
          },*/
          onPressed: (consent || surveyType == 'ongoing') ? () =>
             _navigationToProject(context) : null,
          child: Text(
            //'End'.toUpperCase(),
            (surveyType == 'ongoing')
                ? 'Annotate'.toUpperCase()
                : 'Start'.toUpperCase(),
            style: Styles.textCTAButton,
          ),
       /* ),
        ),
        Expanded(
          child: TextButton(
      //color: Styles.accentColor,
      //textColor: Styles.textColorBright,
      style: ButtonStyle(
                          backgroundColor: (consent || alreadyParticipating)
                            ? MaterialStateProperty.all(Colors.blue)
                            : MaterialStateProperty.all(Colors.grey),  // Use grey color when consent is false
                          foregroundColor: (consent || alreadyParticipating)
                            ? MaterialStateProperty.all(Colors.white)
                            : MaterialStateProperty.all(Colors.black),  // Use appropriate text color based on consent
                        ),      
      onPressed: (consent || alreadyParticipating) ? () => 
        _navigationToProject(context) : null,
      
      child: Text(
        'Participate'.toUpperCase(),
        style: Styles.textCTAButton,
      ),*/
      /*onPressed: () {
      if (!alreadyParticipating) {
        _navigationToProject(context);
      } else {
        Navigator.of(context).pushNamed('/active_projects');
      }
    },
    child: Text(
      alreadyParticipating
          ? AppLocalizations.of(context)?.translate("active_projects") ?? ""
          : 'Participate'.toUpperCase(),
      style: Styles.textCTAButton,
    ),*/
    //),
        ),
         ),
      if (surveyType == 'ongoing')
        Expanded(
          child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            endButtonPressed = true; // Set the flag when the "End" button is pressed
            _navigationToProject(context);
          },
          child: Text(
            'End'.toUpperCase(),
            style: Styles.textCTAButton,
          ),
        ),
        ),
    ],
    );
  }


Future<String> checkParticipationStatus() async {
  
  String status = 'empty';
  // Fetch the participating projects
  final List<Particpating_Project> projects = await ProjectDatabase.instance.readAllProjects();

  print('Project count : ${projects.length}');

  for (final project in projects) {
    print('Project id : ${project.projectId}');
    print('Project Number : ${project.projectNumber}');
    print('Project status : ${project.projectStatus}');

    if (project.projectId == projectID) {
      print('match Project id : ${project.projectId}');
      print('match Project status : ${project.projectStatus}');
      print('match Project number : ${project.projectNumber}');
      GlobalProjectData.active_project_number = project.projectNumber;
      status = project.projectStatus; // If projectId matches p_id and status is ongoing, return true.
      print("Check project status returning: $status");
} 
  }

  return status;
}


  Future<String> getLocationsToShare(int maxDays) async {
      String ret = "";
      DateTime now = DateTime.now();

      /// var difference = berlinWallFell.difference(moonLanding);
      /// assert(difference.inDays == 7416);
      List allLocations = await bg.BackgroundGeolocation.locations;
      List<ShareLocation> customLocation = [];

      for (var thisLocation in allLocations) {
        ShareLocation _loc = new ShareLocation(
            bg.Location(thisLocation).timestamp,
            bg.Location(thisLocation).coords.latitude,
            bg.Location(thisLocation).coords.longitude);

        // Filter locations to share based on the dates provided by the user
        var difference =
            now.difference(_loc.timestampToDateTime(_loc.getTimestamp()));
        if (difference.inDays <= maxDays)
          customLocation.add(_loc);
        else
          break;
      }

      ret = jsonEncode(customLocation);
      ret = ret.replaceAll("\"",
          "'"); //We replace " into ' to avoid a javascript exception when we post it in the webview's form

      return ret;
    
  }

/*
  Future<void> _navigationToProject(BuildContext context) async {
    String locationHistoryJSON = await getLocationsToShare(dropdownValue);

    project.participate(context, locationHistoryJSON);
  }
*/

  Future<void> _navigationToProject(BuildContext context) async {

  String locationHistoryJSON = '';

   if(project.locationSharingMethod == 1 || project.locationSharingMethod == 3){
      locationHistoryJSON = await getLocationsToShare(dropdownValue);
   }

    // Calculate enddate based on startdate and duration
    DateTime startDate = DateTime.now();
    DateTime endDate = startDate.add(Duration(days: dropdownValue));

    if(endButtonPressed)
    {
      statusToSet = "ending";
      surveyType = "ending";
      print('This project is set to finish. Project number : ${GlobalProjectData.active_project_number}');
      //Navigator.pop(context, true);
    }

      await ProjectDatabase.instance.updateProjectStatusBasedOnProjectNUmber(GlobalProjectData.active_project_number, statusToSet);


    // Special for Tiger on Board project (make sure this projectID number matches)
    if(projectID == 2)
    {
      DateTime date = DateTime.now();
      final state = TigerInCarState(isAlive: true, date: date);
      SendTigerInCarDataToAPI sendToAPI = SendTigerInCarDataToAPI();
      sendToAPI.submitData(state);
    }
      active_project_url = project.webUrl ?? "";
      GlobalProjectData.generatedUrl = active_project_url + "?&d[user_id]=" + GlobalData.userUUID + "&d[experiment_status]=" + surveyType + "&d[unix_time]=" + GlobalSendDatatoAPI.unix.toString();
   
    print('Project full url : ${GlobalProjectData.generatedUrl}');
    print('Project web URL : ${project.webUrl}');
    // Create a Project instance with the provided data
    Particpating_Project projectRecord = Particpating_Project(
      projectId: projectID,
      projectName: project.name,
      projectDescription: project.summary,
      externalLink: project.webUrl,
      internalLink: project.projectScreen,
      projectImageLocation: project.imageUrl,
      duration: dropdownValue,
      startDate: startDate,
      endDate: endDate,
      projectStatus: statusToSet,
      locationSharingMethod: project.locationSharingMethod,
    );

  // Insert the record into the database
  if (createNewRecord) {
    await ProjectDatabase.instance.createProject(projectRecord);
    print('Project inserted');
  }
  
  Navigator.pop(context, true);
  
  project.participate(context, locationHistoryJSON);

  }

  Widget _renderBottomSpacer() {
    return Container(height: FooterHeight);
  }
}
