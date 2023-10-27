import 'package:asm/external_projects/tiger_in_car/models/tiger_in_car_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:asm/models/app_localizations.dart';

import '../../../db/database_tiger_in_car.dart';
import '../models/send_data_to_api.dart';
//import '../external_projects/tiger_in_car/models/participating_projects.dart';
import '../../../db/database_project.dart';
import '../../../ui/project_detail.dart';

enum ExperimentStatus { not_started, ongoing }

class TigerInCar extends StatefulWidget {
  @override
  _TigerInCarState createState() => _TigerInCarState();
}

class _TigerInCarState extends State<TigerInCar>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> listOfButtonsToDisplay = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text("Tiger in Car"),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: displayButtons(),
      ),
    );
  }

  Widget displayButtons() {
    updateExperimentStatus();

    return Container(
        color: Color(0xffE5E5E5),
        child: SingleChildScrollView(
            child: StaggeredGrid.count(
          crossAxisCount: 4,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          children: listOfButtonsToDisplay,
        )));
  }

  Widget displayCardBtn(String text, Color backgroundColor, IconData icon,
      int width, num height, int action) {
    return StaggeredGridTile.count(
      crossAxisCellCount: width,
      mainAxisCellCount: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: backgroundColor,
          elevation: 14.0,
          borderRadius: BorderRadius.circular(24.0),
          shadowColor: Color(0x802196F3),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: SizedBox(
              height: 250,
              child: TextButton(
                onPressed: () async {
                  addMosquitoState(action, true, await getAmountOfRows());
                },
                child: Column(
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    SizedBox(height: 8.0),
                    Icon(
                      icon,
                      size: 60.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateExperimentStatus() async {
    ExperimentStatus experimentStatus;

    int rows = await getAmountOfRows();
    final project = await ProjectDatabase.instance.readProject(GlobalProjectData.active_project_number ?? -1);
print('Project id : ${project.projectId}');
print('Project number : ${project.projectNumber}');
print('Project status : ${project.projectstatus}');


   if (project.projectId == -1) {
      print('it got to here : ${project.projectId}');
List<Widget> newList = [];

Widget card3 = displayCardBtn("cowboy",
          Color.fromARGB(255, 255, 255, 255), Icons.not_started, 4, 1.65, 0);
      newList.add(card3);


      TextButton(
  onPressed: () {
    Navigator.of(context).pushNamed('/participate_in_a_project');
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.red),  // Adjust the background color as needed
    elevation: MaterialStateProperty.all(2.0),  // Adjust the elevation as needed
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),  // Adjust the border radius as needed
    )),
  ),
  child: ListTile(
    leading: const Icon(Icons.edit),
    title: Text(
      AppLocalizations.of(context)?.translate("participate_in_a_project") ?? "",
    ),
  ),
);
    }
else {
        print('but not here : ${project.projectId}');

    if (rows == 0) {
      experimentStatus = ExperimentStatus.not_started;
    } else {
      TigerInCarState state = await TigerInCarDatabase.instance.readState(rows);
      if (state.isAlive) {
        experimentStatus = ExperimentStatus.ongoing;
      } else {
        experimentStatus = ExperimentStatus.not_started;
      }
    }

    List<Widget> newList = [];
if (project.projectId == -1) {
      print('it got to here : ${project.projectId}');

Widget card3 = displayCardBtn("cowboy",
          Color.fromARGB(255, 255, 255, 255), Icons.account_box_sharp, 4, 1.65, 0);
      newList.add(card3);
} else {
   print('nopes, got to here : ${project.projectId}');
    // Display buttons depending on the experiment status
    if (experimentStatus == ExperimentStatus.not_started) {
      Widget card = displayCardBtn("Initiate Experiment",
          Color.fromARGB(255, 255, 255, 255), Icons.not_started, 4, 1.65, 0);
      newList.add(card);
    } else {
      Widget card1 = displayCardBtn("Press if the mosquito is alive now",
          Color.fromARGB(255, 155, 255, 155), Icons.sync, 4, 1.65, 1);

      Widget card2 = displayCardBtn("Finish experiment",
          Color.fromARGB(255, 255, 155, 155), Icons.stop_circle, 4, 1.65, 2);
      newList.add(card1);
      newList.add(card2);
    }

    if (this.mounted) {
      setState(() {
        listOfButtonsToDisplay = newList;
      });
    }
    }
    }
  }

  Future<int> getAmountOfRows() async {
    int? count = await TigerInCarDatabase.instance.getAmountOfRows();
    if (count == null) throw Exception();

    return count;
  }

  void addMosquitoState(int btnIndex, bool isAlive, int amountOfRows) async {
    DateTime date = DateTime.now();
    final state = TigerInCarState(isAlive: isAlive, date: date);
    await TigerInCarDatabase.instance.createRecord(state);

    switch (btnIndex) {
      case 0:
        SendTigerInCarDataToAPI sendToAPI = SendTigerInCarDataToAPI();
        state.message = "Experiment started";
        sendToAPI.submitData(state);
        break;
      case 1:
        SendTigerInCarDataToAPI sendToAPI = SendTigerInCarDataToAPI();
        state.message = "Mosquito is alive";
        sendToAPI.submitData(state);
        break;
      case 2:
        Navigator.of(context)
            .pushNamed('/tiger_in_car_finish_experiment', arguments: state);
        break;
      default:
        throw Exception();
    }
  }
}
