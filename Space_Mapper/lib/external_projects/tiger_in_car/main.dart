import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TigerInCar extends StatefulWidget {
  @override
  _TigerInCarState createState() => _TigerInCarState();
}

class _TigerInCarState extends State<TigerInCar>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final int numberOfScreens = 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: numberOfScreens,
        child: Scaffold(
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
            displayCard("Initiate Experiment",
                Color.fromARGB(255, 255, 255, 255), Icons.not_started, 4, 1.65),
            displayCard("Is the mosquito still alive?",
                Color.fromARGB(255, 155, 255, 155), Icons.sync, 4, 1.65),
            displayCard("Is the mosquito dead?",
                Color.fromARGB(255, 255, 155, 155), Icons.stop_circle, 4, 1.65),
          ],
        )));
  }

  Widget displayCard(String text, Color backgroundColor, IconData icon,
      int width, num height) {
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
                  child: Column(
                    children: [
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      Icon(
                        icon,
                        size: 60.0,
                      )
                    ],
                  )),
            ),
          )),
    );
  }
}
