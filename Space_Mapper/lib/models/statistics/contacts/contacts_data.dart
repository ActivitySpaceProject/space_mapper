// COMMENTING OUT BECAUSE NEED TO CHANGE CHART PACKAGE

/*

import 'package:asm/models/statistics/contacts/monthly_contacts.dart';
import 'package:flutter/material.dart';

class ContactsData {
  static Future<num> getAverageMonthlyContacts() async {
    List<MonthlyContactData> data = await MonthlyContactData.getData();
    num total = 0;
    num validMonths = 0;

    for (int i = 0; i < data.length; ++i) {
      if (data[i].value > 0) {
        //Only months with values that aren't empty are used for the statistics
        validMonths += 1;
        total += data[i].value;
      }
    }

    return total / validMonths;
  }

  static Future<num> getTotalContacts() async {
    List<MonthlyContactData> data = await MonthlyContactData.getData();
    num total = 0;

    for (int i = 0; i < data.length; ++i) {
      total += data[i].value;
    }

    return total;
  }

  static Widget displayText(
      String title, String subtitle, String subtitle2, num avgContacts) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            avgContacts.toString(),
                            style: TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                              Text(
                                subtitle2,
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
