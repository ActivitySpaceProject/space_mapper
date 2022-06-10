import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:shared_preferences/shared_preferences.dart';

class SendDataToAPI {
  submitData(bg.Location location) async {
    final uri =
        Uri.parse('https://testingserver.activityspaceproject.com/api/write');
    final headers = {'Content-Type': 'application/json'};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: non_constant_identifier_names
    String? user_uuid = prefs.getString("user_uuid");

    String os = 'OS not detected';
    if (Platform.isAndroid)
      os = 'Android';
    else if (Platform.isIOS) os = 'iOS';

    Map<String, dynamic> body = {
      'user_UUID': user_uuid,
      'user_code': '00000000',
      'app_version': '0.0.0',
      'os': os,
      'type_of_data': '0000000000',
      'message': '',
      'lon': location.coords.longitude,
      'lat': location.coords.latitude,
      'unix_time': timestampInUTCFromStringToInt(location.timestamp),
      'speed': location.coords.speed,
      'activity': location.activity.type,
      'altitude': location.coords.altitude,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;

    if (statusCode == 201) {
      print(responseBody);
    } else {
      print("----- API request failed -----");
    }
  }

  int timestampInUTCFromStringToInt(String locationTimestamp) {
    String yearText = locationTimestamp[0] +
        locationTimestamp[1] +
        locationTimestamp[2] +
        locationTimestamp[3];
    String monthText = locationTimestamp[5] + locationTimestamp[6];
    String dayText = locationTimestamp[8] + locationTimestamp[9];
    String hourText = locationTimestamp[11] + locationTimestamp[12];
    String minuteText = locationTimestamp[14] + locationTimestamp[15];
    String secondText = locationTimestamp[17] + locationTimestamp[18];
    String millisecondText =
        locationTimestamp[20] + locationTimestamp[21] + locationTimestamp[22];

    int year = int.parse(yearText);
    int month = int.parse(monthText);
    int day = int.parse(dayText);
    int hour = int.parse(hourText);
    int minute = int.parse(minuteText);
    int second = int.parse(secondText);
    int millisecond = int.parse(millisecondText);

    DateTime timestamp =
        DateTime(year, month, day, hour, minute, second, millisecond);
    return timestamp.millisecondsSinceEpoch;
  }
}
