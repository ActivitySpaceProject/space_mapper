import 'package:asm/db/database.dart';
import 'package:asm/models/contacts.dart';
import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:flutter/material.dart';

class MyStatistics extends StatefulWidget {
  @override
  _MyStatisticsState createState() => _MyStatisticsState();
}

class MyChartData {
  final int id;
  int value;
  final DateTime date;

  MyChartData(this.id, this.value, this.date);
}

class _MyStatisticsState extends State<MyStatistics>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<MyChartData> _myData = [];

  @override
  void initState() {
    super.initState();
    getMyData();
  }

  void getMyData() async {
    List<Contact> contacts = await StorageDatabase.instance.readAllContacts();
    setState(() {
      // Initialize data
      for (int i = 0; i < 12; ++i) {
        _myData.add(
            MyChartData(i, 0, DateTime.now().subtract(Duration(days: 30 * i))));
      }
      // Fill data
      for (int i = 0; i < contacts.length; ++i) {
        for (int j = 0; j < _myData.length; ++j) {
          if (_myData[j].date.month == contacts[i].date.month) {
            if (_myData[j].date.year == contacts[i].date.year) {
              _myData[j].value++;
              continue;
            }
          }
        }
      }
    });
  }

  Widget getHomePage() {
    final List<Widget> widgets = <Widget>[];
    if (_myData.length > 0) {
      final List<Charts.Series<MyChartData, DateTime>> seriesList = [
        Charts.Series<MyChartData, DateTime>(
          id: 'chart000',
          domainFn: (MyChartData chartData, _) => chartData.date,
          measureFn: (MyChartData chartData, _) => chartData.value,
          colorFn: (MyChartData chartData, _) =>
              Charts.MaterialPalette.deepOrange.shadeDefault,
          data: _myData,
        ),
      ];
      final Charts.TimeSeriesChart chart = Charts.TimeSeriesChart(
        seriesList,
        animate: true,
      );
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: SizedBox(
          height: 250,
          child: chart,
        ),
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        // Home Page
        color: Theme.of(context).colorScheme.primary,
        padding: MediaQuery.of(context).padding,
        child: getHomePage(),
      ),
    );
  }
}
