
import 'package:flutter/material.dart';

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
        ),
      ),
    );
  }
}
