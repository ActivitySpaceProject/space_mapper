import 'dart:convert';
import 'dart:io';
import 'package:asm/models/locations_to_push.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendDataToAPI {
  submitData(bg.Location location) async {
    final uri =
        Uri.parse('https://testingserver.activityspaceproject.com/api/write');
    final headers = {'Content-Type': 'application/json'};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUUID = prefs.getString("user_uuid");

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String os = 'OS not detected';
    if (Platform.isAndroid)
      os = 'Android';
    else if (Platform.isIOS) os = 'iOS';

    LocationToPush locationToPush = LocationToPush(
        userUUID: userUUID,
        userCode: '00000000',
        appVersion: "${packageInfo.version}+${packageInfo.buildNumber}",
        operativeSystem: os,
        typeOfData: 'location',
        message: '',
        longitude: location.coords.longitude,
        latitude: location.coords.latitude,
        unixTime: timestampInUTCFromStringToInt(location.timestamp).toString(),
        activity: location.activity.type,
        altitude: location.coords.altitude.toString());

    String jsonBody = json.encode(locationToPush.toJsonWithoutId());
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
      sendStoredLocations();
    } else {
      // TODO: The data could not be sent to the API, so it stored and will try again to re-send it
    }
  }

  void sendStoredLocations() {}

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
