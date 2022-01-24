import 'package:asm/db/database.dart';
import 'package:asm/models/contacts.dart';
import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:flutter/material.dart';

class ContactsByAgeData {
  final String ageGroup;
  int value;

  ContactsByAgeData(this.ageGroup, this.value);

  static Future<List<ContactsByAgeData>> getData() async {
    List<Contact> contacts = await StorageDatabase.instance.readAllContacts();
    List<ContactsByAgeData> _contactByAgeData = [];

    // Initialize data
    _contactByAgeData.add(ContactsByAgeData('0-9', 0));
    _contactByAgeData.add(ContactsByAgeData('10-19', 0));
    _contactByAgeData.add(ContactsByAgeData('20-29', 0));
    _contactByAgeData.add(ContactsByAgeData('30-39', 0));
    _contactByAgeData.add(ContactsByAgeData('40-49', 0));
    _contactByAgeData.add(ContactsByAgeData('50-59', 0));
    _contactByAgeData.add(ContactsByAgeData('60-69', 0));
    _contactByAgeData.add(ContactsByAgeData('70-79', 0));
    _contactByAgeData.add(ContactsByAgeData('80+', 0));

    // Fill data
    for (int i = 0; i < contacts.length; ++i) {
      for (int j = 0; j < _contactByAgeData.length; ++j) {
        if (_contactByAgeData[j].ageGroup == contacts[i].ageGroup) {
          _contactByAgeData[j].value++;
          continue;
        }
      }
    }
    return _contactByAgeData;
  }

  static Widget display(List<ContactsByAgeData> data, BuildContext context) {
    final List<Widget> widgets = <Widget>[];

    if (data.length > 0) {
      final List<Charts.Series<ContactsByAgeData, String>> seriesList = [
        Charts.Series<ContactsByAgeData, String>(
          id: 'ageChart',
          colorFn: (_, __) => Charts.MaterialPalette.blue.shadeDefault,
          domainFn: (ContactsByAgeData chartData, _) => chartData.ageGroup,
          measureFn: (ContactsByAgeData chartData, _) => chartData.value,
          data: data,
        ),
      ];
      final Charts.BarChart chart = Charts.BarChart(
        seriesList,
        animate: true,
        behaviors: [
          new Charts.ChartTitle('Contacts by age group',
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
    }
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Column(children: widgets),
    );
  }
}
