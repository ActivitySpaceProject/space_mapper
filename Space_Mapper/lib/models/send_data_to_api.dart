import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class SendDataToAPI {
  submitData(bg.Location location) async {
    final uri =
        Uri.parse('https://testingserver.activityspaceproject.com/api/write');
    final headers = {'Content-Type': 'application/json'};

    String os = 'os not detected';
    if(Platform.isAndroid) os = 'Android';
    else if(Platform.isIOS) os = 'iOS';

    Map<String, dynamic> body = {
      'user_UUID': '00000000-0000-0000-0000-000000000000',
      'user_code': '00000000',
      'app_version': '0.0.0',
      'os': os,
      'type_of_data': '0000000000',
      'message': '',      
      'lon': location.coords.longitude,
      'lat': location.coords.latitude,
      //'unix_time': 0 /*location.timestamp*/,
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
}
