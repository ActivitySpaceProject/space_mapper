import 'package:asm/external_projects/tiger_in_car/models/tiger_in_car_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../db/database_tiger_in_car.dart';

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
                  switch (action) {
                    case 0:
                      addMosquitoState(action, true, await getAmountOfRows());
                      break;
                    case 1:
                      addMosquitoState(action, true, await getAmountOfRows());
                      break;
                    case 2:
                      addMosquitoState(action, false, await getAmountOfRows());
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

  void updateExperimentStatus() async {
    ExperimentStatus experimentStatus;

    int rows = await getAmountOfRows();

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

    setState(() {
      listOfButtonsToDisplay = newList;
    });
  }

  Future<int> getAmountOfRows() async {
    int? count = await TigerInCarDatabase.instance.getAmountOfRows();
    if (count == null) throw Exception();

    return count;
  }

  void getElementFromDatabase(int id) {}

  void addMosquitoState(int btnIndex, bool isAlive, int amountOfRows) async {
    DateTime date = DateTime.now();
    final state = TigerInCarState(isAlive: isAlive, date: date);
    await TigerInCarDatabase.instance.createRecord(state);

    switch (btnIndex) {
      case 0:
        // TODO
        break;
      case 1:
        // TODO
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
