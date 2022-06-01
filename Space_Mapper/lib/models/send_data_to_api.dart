import 'dart:convert';
import 'package:http/http.dart' as http;

/*class Location {
  Location(){
    
  }

  String user_UUID = "";
  String user_code = "";
  String app_version = "";
  String os = "";
  String type_of_data = "";
  String encrypted_message = "";
  String encrypted_lon = "";
  String encrypted_lat = "";
  String encrypted_unix_time = "";
  String encrypted_speed = "";
  String encrypted_activity = "";
  String encrypted_altitude = "";
  String message = "";
  String lon = "";
  String lat = "";
  String unix_time = "";
  String speed = "";
  String activity = "";
  String altitude = "";
}*/

class SendDataToAPI {
  submitData() async {
    final uri = Uri.parse('https://testingserver.activityspaceproject.com/api/write');
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {'user_UUID': 21, 'user_code': 'b'};
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

    if(statusCode == 201)
    {
      print(responseBody);
    }else{
      print("request failed");
    }
  }
}
