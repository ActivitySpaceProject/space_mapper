import 'dart:convert';
import 'dart:io';
import 'package:asm/models/locations_to_push.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/database_unpushed_locations.dart';
import 'package:fast_rsa/fast_rsa.dart' as fastRsa;

final String publicKey = 'asdad';
// TODO load this from embedded unique to each project

class GlobalSendDatatoAPI {
  static int? unix;
}

class SendDataToAPI {
  submitData(bg.Location location, String typeOfData, [String? message]) async {
    LocationToPush locationToPush = await generateLocationToPush(location, typeOfData, message);
    bool isOnline = await hasNetwork();

    if (!isOnline) {
      await UnPushedLocationsDatabase.instance.createRecord(locationToPush);
    } else {
      int statusCode = await submitLocation(locationToPush);

      if (statusCode == 201) {
        // The current call returned successfully, therefore it tries again to send calls that failed previously
        await sendStoredLocations();
      } else {
        // The data could not be sent to the API, so the current location is stored and will later try again to send it
        await UnPushedLocationsDatabase.instance.createRecord(locationToPush);
      }
    }
  }

  Future<String> encryptRSA({required payload}) async => await fastRsa.RSA
      .encryptOAEP(payload, '', fastRsa.Hash.SHA256, publicKey);

  Future<int> submitLocation(LocationToPush location, [bool encrypt = false]) async {
    final uri =
        Uri.parse('https://testingserver.activityspaceproject.com/api/write');
    final headers = {'Content-Type': 'application/json'};

    String jsonBody = json.encode(location.toJsonWithoutId());

    if (encrypt){
      jsonBody = await fastRsa.RSA
          .encryptOAEP(jsonBody, '', fastRsa.Hash.SHA256, publicKey);
    }

    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    return response.statusCode;
  }

  Future<void> sendStoredLocations() async {
    int numOfStoredLocations =
        await UnPushedLocationsDatabase.instance.getAmountOfRows();

    if (numOfStoredLocations == 0) return;

    List<LocationToPush> allLocationsToPush =
        await UnPushedLocationsDatabase.instance.readAllRecords();

    for (int i = numOfStoredLocations - 1; i >= 0; i--) {
      allLocationsToPush[i].message = "Call failed initially";
      int statusCode = await submitLocation(allLocationsToPush[i]);

      if (statusCode == 201) {
        // Stored location was uploaded successfully, delete instance from the local database
        await UnPushedLocationsDatabase.instance
            .deleteRecord(allLocationsToPush[i].userUUID);
      } else {
        // The call failed, so the calls stop and will resume at a later moment
        break;
      }
    }
  }

  Future<LocationToPush> generateLocationToPush(bg.Location location, String typeOfData, [String? message]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userUUID = prefs.getString("user_uuid") ?? "null UUID";
    String userCode =
        userUUID[0] + userUUID[1] + userUUID[2] + userUUID[3] + userUUID[4];

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String os = 'OS not detected';
    if (Platform.isAndroid)
      os = 'Android';
    else if (Platform.isIOS) os = 'iOS';

    GlobalSendDatatoAPI.unix = timestampInUTCFromStringToInt(location.timestamp);

    LocationToPush locationToPush = LocationToPush(
        userUUID: userUUID,
        userCode: userCode,
        appVersion: "${packageInfo.version}+${packageInfo.buildNumber}",
        operativeSystem: os,
        typeOfData: typeOfData,
        message: message,
        longitude: location.coords.longitude,
        latitude: location.coords.latitude,
        //unixTime: timestampInUTCFromStringToInt(location.timestamp).toString(),
        unixTime: GlobalSendDatatoAPI.unix.toString(),
        speed: location.coords.speed,
        activity: location.activity.type,
        altitude: location.coords.altitude.toString());

    return locationToPush;
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

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
