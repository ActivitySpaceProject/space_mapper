// COMMENTING OUT BECAUSE NEED TO CHANGE CHART PACKAGE

/*


import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:flutter/material.dart';

import '../../../db/database_contact.dart';
import '../../contacts.dart';

class ContactByGenderData {
  final int gender;
  int value;
  Color color;

  ContactByGenderData(this.gender, this.value, this.color);

  static Future<List<ContactByGenderData>> getData() async {
    List<Contact> contacts = await ContactDatabase.instance.readAllContacts();
    List<ContactByGenderData> _contactByGenderData = [];

    // Initialize data
    _contactByGenderData.add(ContactByGenderData(0, 0, Colors.blue.shade700));
    _contactByGenderData.add(ContactByGenderData(1, 0, Colors.blue.shade400));
    _contactByGenderData.add(ContactByGenderData(2, 0, Colors.blue.shade200));

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
    return _contactByGenderData;
  }

  static Widget display(List<ContactByGenderData> data, BuildContext context) {
    final List<Widget> widgets = <Widget>[];

    if (data.length > 0) {
      final List<Charts.Series<ContactByGenderData, int>> seriesList = [
        Charts.Series<ContactByGenderData, int>(
          id: 'genderChart',
          domainFn: (ContactByGenderData chartData, _) => chartData.gender,
          measureFn: (ContactByGenderData chartData, _) => chartData.value,
          colorFn: (ContactByGenderData chartData, _) =>
              Charts.ColorUtil.fromDartColor(chartData.color),
          data: data,
        ),
      ];
      final Charts.PieChart chart = Charts.PieChart<int>(
        seriesList,
        animate: true,
        behaviors: [
          new Charts.ChartTitle('By gender',
              behaviorPosition: Charts.BehaviorPosition.top,
              titleOutsideJustification: Charts.OutsideJustification.start,
              innerPadding: 18),
        ],
      );
      // Pie Chart added to widgets
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: SizedBox(
            height: MediaQuery.of(context).size.width * 0.5,
            //width: 100,
            child: chart,
          ),
        ),
      ); // Datum Legend is a separate widget than pie chart
      widgets.add(displaySortedLegend(data));
    }
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Column(children: widgets),
    );
  }

  static Widget displaySortedLegend(List<ContactByGenderData> data) {
    Widget drawCircle(Color color) {
      return Container(
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          height: 12.0,
          width: 12.0,
          child: Center(
              // Your Widget
              ),
        ),
      );
    }

    // Display gender as string
    String genderToString(int gender, int value) {
      if (gender == 0) {
        return " " + value.toString() + " Males";
      } else if (gender == 1) {
        return " " + value.toString() + " Females";
      } else if (gender == 2) {
        return " " + value.toString() + " Others";
      }
      return "error";
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      child: Column(
        children: [
          Row(
            children: [
              drawCircle(data[0].color),
              Text(genderToString(data[0].gender, data[0].value)),
            ],
          ),
          Row(
            children: [
              drawCircle(data[1].color),
              Text(genderToString(data[1].gender, data[1].value)),
            ],
          ),
          Row(
            children: [
              drawCircle(data[2].color),
              Text(genderToString(data[2].gender, data[2].value)),
            ],
          )
        ],
      ),
    );
  }
}
*/
