import 'package:asm/external_projects/tiger_in_car/models/tiger_in_car_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
                "Initiate Experiment",
                Color.fromARGB(255, 255, 255, 255),
                Icons.not_started,
                4,
                1.65,
                0),
            displayCardBtn("Press if the mosquito is alive now",
                Color.fromARGB(255, 155, 255, 155), Icons.sync, 4, 1.65, 1),
            displayCardBtn(
                "Finish experiment",
                Color.fromARGB(255, 255, 155, 155),
                Icons.stop_circle,
                4,
                1.65,
                2),
          ],
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
                onPressed: () {
                  switch (action) {
                    case 0:
                      //tigerInCarRoute.setStartDate(DateTime.now());
                      break;
                    case 1:
                      //tigerInCarRoute.addMosquitoAlive(DateTime.now());
                      break;
                    case 2:
                      //tigerInCarRoute.finishExperiment(DateTime.now());
                      break;
                    default:
                      break;
                  }
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
}
