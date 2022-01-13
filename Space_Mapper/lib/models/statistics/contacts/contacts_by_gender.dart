import 'package:asm/db/database.dart';
import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:flutter/material.dart';

import '../../contacts.dart';

class ContactByGenderData {
  final int gender;
  int value;

  ContactByGenderData(this.gender, this.value);

  static Future<List<ContactByGenderData>> getData() async {
    List<Contact> contacts = await StorageDatabase.instance.readAllContacts();
    List<ContactByGenderData> _contactByGenderData = [];

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
    return _contactByGenderData;
  }

  static Widget display(List<ContactByGenderData> data) {
    final List<Widget> widgets = <Widget>[];

    if (data.length > 0) {
      final List<Charts.Series<ContactByGenderData, int>> seriesList = [
        Charts.Series<ContactByGenderData, int>(
            id: 'genderChart',
            domainFn: (ContactByGenderData chartData, _) => chartData.gender,
            measureFn: (ContactByGenderData chartData, _) => chartData.value,
            //colorFn: (ContactByGenderData chartData, _) =>
            //    Charts.MaterialPalette.blue.shadeDefault,
            data: data,
            labelAccessorFn: (ContactByGenderData row, _) =>
                datas(row.gender, row.value)),
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
        defaultRenderer: new Charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new Charts.ArcLabelDecorator()]),
      );
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: SizedBox(
          height: 250,
          //width: 100,
          child: chart,
        ),
      ));
    }
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Column(children: widgets),
    );
  }

  // Display gender as string
  static String datas(int gender, int value) {
    if (gender == 0) {
      return value.toString() + ": Male";
    } else if (gender == 1) {
      return value.toString() + ": Female";
    } else if (gender == 2) {
      return value.toString() + ": Other";
    }
    return "error";
  }
}
