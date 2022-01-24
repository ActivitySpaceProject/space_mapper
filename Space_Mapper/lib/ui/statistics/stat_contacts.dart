import 'package:asm/models/statistics/contacts/contacts_by_age.dart';
import 'package:asm/models/statistics/contacts/contacts_by_gender.dart';
import 'package:asm/models/statistics/contacts/contacts_data.dart';
import 'package:asm/models/statistics/contacts/monthly_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StatsContacts extends StatefulWidget {
  const StatsContacts({Key? key}) : super(key: key);

  @override
  _StatsContactsState createState() => _StatsContactsState();
}

class _StatsContactsState extends State<StatsContacts> {
  List<MonthlyContactData> _monthlyContactData = [];
  List<ContactByGenderData> _contactByGenderData = [];
  List<ContactsByAgeData> _contactByAgeData = [];
  num _avgMonthlyContacts = 0;
  num _totalContacts = 0;

  @override
  void initState() {
    super.initState();
    getMonthlyContactsData();
    getContactsByGenderData();
    getAverageMonthlyContacts();
    getTotalContacts();
    getContactsByAge();
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
            // The following functions require 2 arguments: width and height
            // Width is an int that goes from 1 to 4 and it's relative to the screen's size => 1=25% of the screen's width, 2=50%, 3=75% and 4=100%
            // Height is a float
            displayNumberOfContacts(4, 3.3),
            displayContactsByGender(2, 3.3),
            displayAvgContacts(2, 1.65),
            displayTotalContacts(2, 1.65),
            displayContactsByAgeGroup(4, 2.5),
          ],
        ));
  }

  Widget displayNumberOfContacts(int width, num height) {
    return StaggeredGridTile.count(
      crossAxisCellCount: width,
      mainAxisCellCount: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MonthlyContactData.display(_monthlyContactData),
      ),
    );
  }

  Widget displayContactsByGender(int width, num height) {
    return StaggeredGridTile.count(
      crossAxisCellCount: width,
      mainAxisCellCount: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ContactByGenderData.display(_contactByGenderData, context),
      ),
    );
  }

  Widget displayAvgContacts(int width, num height) {
    return StaggeredGridTile.count(
      crossAxisCellCount: width,
      mainAxisCellCount: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ContactsData.displayText(
          "Avg Contacts",
          "people",
          "/month",
          _avgMonthlyContacts,
        ),
      ),
    );
  }

  Widget displayTotalContacts(int width, num height) {
    return StaggeredGridTile.count(
      crossAxisCellCount: width,
      mainAxisCellCount: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ContactsData.displayText(
          "Total Contacts",
          "contacts",
          "per year",
          _totalContacts,
        ),
      ),
    );
  }

  Widget displayContactsByAgeGroup(int width, num height) {
    return StaggeredGridTile.count(
      crossAxisCellCount: width,
      mainAxisCellCount: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ContactsByAgeData.display(_contactByAgeData, context),
      ),
    );
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

  void getContactsByAge() async {
    List<ContactsByAgeData> data = await ContactsByAgeData.getData();

    setState(() {
      _contactByAgeData = data;
    });
  }
}
