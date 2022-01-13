import 'package:asm/db/database.dart';
import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:flutter/material.dart';

import '../../contacts.dart';

class MonthlyContactData {
  final int id;
  int value;
  final DateTime date;

  MonthlyContactData(this.id, this.value, this.date);

  static Future<List<MonthlyContactData>> getData() async {
    List<Contact> contacts = await StorageDatabase.instance.readAllContacts();
    List<MonthlyContactData> _monthlyContactData = [];

    // Initialize data at 0 values
    for (int i = 0; i < 12; ++i) {
      _monthlyContactData.add(MonthlyContactData(
          i, 0, DateTime.now().subtract(Duration(days: 30 * i))));
    }

    // Fill data from database
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
    return _monthlyContactData;
  }

  static Widget display(List<MonthlyContactData> data) {
    final List<Widget> widgets = <Widget>[];

    if (data.length > 0) {
      final List<Charts.Series<MonthlyContactData, DateTime>> seriesList = [
        Charts.Series<MonthlyContactData, DateTime>(
          id: 'monthlyContactsChart',
          domainFn: (MonthlyContactData chartData, _) => chartData.date,
          measureFn: (MonthlyContactData chartData, _) => chartData.value,
          colorFn: (MonthlyContactData chartData, _) =>
              Charts.MaterialPalette.blue.shadeDefault,
          data: data,
        ),
      ];
      final Charts.TimeSeriesChart chart = Charts.TimeSeriesChart(
        seriesList,
        animate: true,
        behaviors: [
          new Charts.ChartTitle('Contacts in the last 12 months',
              behaviorPosition: Charts.BehaviorPosition.top,
              titleOutsideJustification: Charts.OutsideJustification.start,
              innerPadding: 18),
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
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: SizedBox(
          height: 250,
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

  
}
