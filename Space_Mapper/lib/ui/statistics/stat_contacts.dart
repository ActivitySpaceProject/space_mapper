import 'package:asm/models/statistics/contacts/contacts_by_gender.dart';
import 'package:asm/models/statistics/contacts/contacts_data.dart';
import 'package:asm/models/statistics/contacts/monthly_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StatsContacts extends StatefulWidget {
  const StatsContacts({ Key? key }) : super(key: key);

  @override
  _StatsContactsState createState() => _StatsContactsState();
}

class _StatsContactsState extends State<StatsContacts> {
  List<MonthlyContactData> _monthlyContactData = [];
  List<ContactByGenderData> _contactByGenderData = [];
  num _avgMonthlyContacts = 0;
  num _totalContacts = 0;
  
  @override
  void initState() {
    super.initState();
    getMonthlyContactsData();
    getContactsByGenderData();
    getAverageMonthlyContacts();
    getTotalContacts();
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(
              children: <Widget>[
                displayContactsStatistics(),
              ],
            );
  }

  Widget displayContactsStatistics() {
    return Container(
        color: Color(0xffE5E5E5),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          children: <Widget>[
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 3.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MonthlyContactData.display(_monthlyContactData),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 3.3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ContactByGenderData.display(_contactByGenderData, context),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1.65,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ContactsData.displayText(
                  "Avg Contacts",
                  "people",
                  "/month",
                  _avgMonthlyContacts,
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1.65,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ContactsData.displayText(
                  "Total Contacts",
                  "contacts",
                  "per year",
                  _totalContacts,
                ),
              ),
            ),
          ],
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

  void getAverageMonthlyContacts() async {
    num data = await ContactsData.getAverageMonthlyContacts();

    setState(() {
      _avgMonthlyContacts = data;
    });
  }

  void getTotalContacts() async {
    num data = await ContactsData.getTotalContacts();

    setState(() {
      _totalContacts = data;
    });
  }
}