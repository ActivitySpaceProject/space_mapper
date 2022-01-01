import 'package:asm/db/database.dart';
import 'package:asm/models/contacts.dart';
import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:flutter/material.dart';

class MyStatistics extends StatefulWidget {
  @override
  _MyStatisticsState createState() => _MyStatisticsState();
}

class MonthlyContactData {
  final int id;
  int value;
  final DateTime date;

  MonthlyContactData(this.id, this.value, this.date);
}

class ContactByGenderData {
  final int
      gender; //TODO: Change to string. Currently it's -> 0=male, 1=female, 2=other
  int value = 0;

  ContactByGenderData(this.gender, this.value);
}

class _MyStatisticsState extends State<MyStatistics>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<MonthlyContactData> _monthlyContactData = [];
  List<ContactByGenderData> _contactByGenderData = [];

  @override
  void initState() {
    super.initState();
    getMonthlyContactsData();
    getContactsByGenderData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 2,
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
            ListView(
              children: <Widget>[
                new Card(
                  margin: EdgeInsets.only(top: 20.0),
                  child: displayMonthlyContacts(),
                ),
              ],
            ),
            ListView(
              children: <Widget>[
                new Card(
                  margin: EdgeInsets.only(top: 20.0),
                  child: displayContactsByGender(),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  void getMonthlyContactsData() async {
    List<Contact> contacts = await StorageDatabase.instance.readAllContacts();
    setState(() {
      // Initialize data
      for (int i = 0; i < 12; ++i) {
        _monthlyContactData.add(MonthlyContactData(
            i, 0, DateTime.now().subtract(Duration(days: 30 * i))));
      }
      // Fill data
      for (int i = 0; i < contacts.length; ++i) {
        for (int j = 0; j < _monthlyContactData.length; ++j) {
          if (_monthlyContactData[j].date.month == contacts[i].date.month) {
            if (_monthlyContactData[j].date.year == contacts[i].date.year) {
              _monthlyContactData[j].value++;
              continue;
            }
          }
        }
      }
    });
  }

  void getContactsByGenderData() async {
    List<Contact> contacts = await StorageDatabase.instance.readAllContacts();
    setState(() {
      // Initialize data
      _contactByGenderData.add(ContactByGenderData(0, 0));
      _contactByGenderData.add(ContactByGenderData(1, 0));
      _contactByGenderData.add(ContactByGenderData(2, 0));

      // Fill data
      for (int i = 0; i < contacts.length; ++i) {
        int myGender = -1;
        if (contacts[i].gender == "male")
          myGender = 0;
        else if (contacts[i].gender == "female")
          myGender = 1;
        else if (contacts[i].gender == "other") myGender = 2;

        for (int j = 0; j < _contactByGenderData.length; ++j) {
          if (_contactByGenderData[j].gender == myGender) {
            _contactByGenderData[j].value++;
            continue;
          }
        }
      }
    });
  }

  Widget displayMonthlyContacts() {
    final List<Widget> widgets = <Widget>[];
    if (_monthlyContactData.length > 0) {
      final List<Charts.Series<MonthlyContactData, DateTime>> seriesList = [
        Charts.Series<MonthlyContactData, DateTime>(
          id: 'monthlyContactsChart',
          domainFn: (MonthlyContactData chartData, _) => chartData.date,
          measureFn: (MonthlyContactData chartData, _) => chartData.value,
          colorFn: (MonthlyContactData chartData, _) =>
              Charts.MaterialPalette.blue.shadeDefault,
          data: _monthlyContactData,
        ),
      ];
      final Charts.TimeSeriesChart chart = Charts.TimeSeriesChart(
        seriesList,
        animate: true,
        behaviors: [
          new Charts.ChartTitle('Date',
              behaviorPosition: Charts.BehaviorPosition.bottom,
              titleOutsideJustification:
                  Charts.OutsideJustification.middleDrawArea),
          new Charts.ChartTitle('# of contacts',
              behaviorPosition: Charts.BehaviorPosition.start,
              titleOutsideJustification:
                  Charts.OutsideJustification.middleDrawArea),
        ],
      );
      widgets.add(Text(
        "Contacts in the last 12 months",
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ));
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

  // Display gender as string
  String datas(int gender, int value) {
    if (gender == 0) {
      return value.toString() + ": Male";
    } else if (gender == 1) {
      return value.toString() + ": Female";
    } else if (gender == 2) {
      return value.toString() + ": Other";
    }
    return "error";
  }

  Widget displayContactsByGender() {
    final List<Widget> widgets = <Widget>[];

    if (_contactByGenderData.length > 0) {
      final List<Charts.Series<ContactByGenderData, int>> seriesList = [
        Charts.Series<ContactByGenderData, int>(
            id: 'genderChart',
            domainFn: (ContactByGenderData chartData, _) => chartData.gender,
            measureFn: (ContactByGenderData chartData, _) => chartData.value,
            //colorFn: (ContactByGenderData chartData, _) =>
            //    Charts.MaterialPalette.blue.shadeDefault,
            data: _contactByGenderData,
            labelAccessorFn: (ContactByGenderData row, _) =>
                datas(row.gender, row.value)),
      ];
      final Charts.PieChart chart = Charts.PieChart<int>(
        seriesList,
        animate: true,
        defaultRenderer: new Charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new Charts.ArcLabelDecorator()]),
      );
      widgets.add(Text(
        "Contacts by gender",
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ));
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: SizedBox(
          height: 250,
          //width: 100,
          child: chart,
        ),
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }
}
