import 'package:asm/models/statistics/contacts/contacts_by_gender.dart';
import 'package:asm/models/statistics/contacts/monthly_contacts.dart';
import 'package:flutter/material.dart';

class MyStatistics extends StatefulWidget {
  @override
  _MyStatisticsState createState() => _MyStatisticsState();
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
                  child: MonthlyContactData.display(_monthlyContactData),
                ),
              ],
            ),
            ListView(
              children: <Widget>[
                new Card(
                  margin: EdgeInsets.only(top: 20.0),
                  child: ContactByGenderData.display(_contactByGenderData),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  void getMonthlyContactsData() async {
    List<MonthlyContactData> data = await MonthlyContactData.getData();

    setState(() {
      _monthlyContactData = data;
    });    
  }

  void getContactsByGenderData() async {
    List<ContactByGenderData> data = await ContactByGenderData.getData();
    
    setState(() {
      _contactByGenderData = data;
    });
  }
}