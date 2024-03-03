import 'package:asm/external_projects/tiger_in_car/models/tiger_in_car_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../db/database_tiger_in_car.dart';
import '../models/send_data_to_api.dart';
//import '../external_projects/tiger_in_car/models/participating_projects.dart';
import '../../../db/database_project.dart';

class FinishExperiment extends StatefulWidget {
  final TigerInCarState tigerInCarRoute;
  FinishExperiment(this.tigerInCarRoute);

  @override
  _FinishExperimentState createState() =>
      _FinishExperimentState(tigerInCarRoute);
}

class _FinishExperimentState extends State<FinishExperiment>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TigerInCarState tigerInCarRoute;
  _FinishExperimentState(this.tigerInCarRoute);

  @override
  void initState() {
    super.initState();
  }

  String getFinishCause(String cause) {
    return cause;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text("Why did the experiment finish?"),
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
    return Container(
        color: Color(0xffE5E5E5),
        child: SingleChildScrollView(
            child: StaggeredGrid.count(
          crossAxisCount: 4,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          children: <Widget>[
            // The following functions require 2 arguments: width and height
            // Width is an int that goes from 1 to 4 and it's relative to the screen's size => 1=25% of the screen's width, 2=50%, 3=75% and 4=100%
            // Height is a float
            displayCardBtn(
                "The mosquito died",
                Color.fromARGB(255, 255, 255, 255),
                Icons.cancel_outlined,
                4,
                1.65,
                0),
            displayCardBtn(
                "The mosquito escaped",
                Color.fromARGB(255, 255, 255, 255),
                Icons.airline_stops,
                4,
                1.65,
                1),
            displayCardBtn("Other", Color.fromARGB(255, 255, 255, 255),
                Icons.apps, 4, 1.65, 2),
          ],
        )));
  }

  Widget displayCardBtn(String message, Color backgroundColor, IconData icon,
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
                onPressed: () {
                  SendTigerInCarDataToAPI sendToAPI = SendTigerInCarDataToAPI();
                  tigerInCarRoute.message = message;
                  sendToAPI.submitData(tigerInCarRoute);
                  addMosquitoDeathToDatabase(message);
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Text(
                      message,
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

  void addMosquitoDeathToDatabase(String message) async {
    DateTime date = DateTime.now();
    final state = TigerInCarState(isAlive: false, date: date, message: message);
    await TigerInCarDatabase.instance.createRecord(state);
    await ProjectDatabase.instance.updateAllProjectStatusToFinish();
    Navigator.pop(context, true); // Pass true to indicate a refresh is needed
  }
}
