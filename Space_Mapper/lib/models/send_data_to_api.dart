import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class SendDataToAPI {
  submitData(bg.Location location) async {
    final uri =
        Uri.parse('https://testingserver.activityspaceproject.com/api/write');
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'user_UUID': '00000000-0000-0000-0000-000000000000',
      'user_code': '00000000',
      'lon': location.coords.longitude,
      'lat': location.coords.latitude
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
      print("request failed");
    }
  }
}
