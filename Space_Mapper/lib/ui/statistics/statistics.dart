import 'package:asm/ui/statistics/stat_contacts.dart';

import 'package:flutter/material.dart';

class MyStatistics extends StatefulWidget {
  @override
  _MyStatisticsState createState() => _MyStatisticsState();
}

class _MyStatisticsState extends State<MyStatistics>
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
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.bar_chart)),
                Tab(icon: Icon(Icons.pie_chart)),
              ],
            ),
            title: Text("Statistics"),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: TabBarView(
          children: [
            StatsContacts(),
            StatsContacts(),
          ],
        ),
      ),
    ));
  }
}
