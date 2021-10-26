import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:geocoding/geocoding.dart';

Future<String?> getLocationData(
    String dataType, double lat, double long) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      lat,
      long,
    );
    switch (dataType) {
      case "locality":
        return placemarks[0].locality;
      case "subAdministrativeArea":
        return placemarks[0].subAdministrativeArea;
      case "ISOCountry":
        return placemarks[0].isoCountryCode;
      default:
        return "";
    }
  } catch (err) {}
}

Future<List<dynamic>>? buildLocationsList() async {
  List locations = await bg.BackgroundGeolocation.locations;
  List ret = [];

  for (int i = 0; i < locations.length; ++i) {
    String? locality = await getLocationData(
        "locality",
        locations[i]['coords']['latitude'],
        locations[i]['coords']['longitude']);
    String? administrativeArea = await getLocationData(
        "subAdministrativeArea",
        locations[i]['coords']['latitude'],
        locations[i]['coords']['longitude']);
    // ignore: non_constant_identifier_names
    String? ISOCountry = await getLocationData(
        "ISOCountry",
        locations[i]['coords']['latitude'],
        locations[i]['coords']['longitude']);
    String timestamp = locations[i]['timestamp'];
    String activity = locations[i]['activity']['type'];
    num speed = locations[i]['coords']['speed'];
    num altitude = locations[i]['coords']['altitude'];
    var add = new DisplayLocation(locality!, administrativeArea!, ISOCountry!,
        timestamp, activity, speed, altitude);
    ret.add(add);
  }
  return ret;
}

class DisplayLocation {
  DisplayLocation(this.locality, this.subAdministrativeArea, this.ISOCountry,
      timestamp, this.activity, this.speed, this.altitude) {
    this.timestamp = formatTimestamp(timestamp);
  }
  late String locality;
  late String subAdministrativeArea;
  // ignore: non_constant_identifier_names
  late String ISOCountry;
  late String timestamp;
  late String activity;
  late num speed;
  late num altitude;

  String formatTimestamp(String timestamp) {
    //2021-10-25T21:25:08.210Z <- This is the original format
    //2021-10-25 | 21:25:08       <- This is the result
    String result = "";
    for (int i = 0; i < timestamp.length; ++i) {
      if (timestamp[i] != "T" && timestamp[i] != ".")
        result += timestamp[i];
      else if (timestamp[i] == "T")
        result += " | ";
      else if (timestamp[i] == ".") break;
    }
    return result;
  }
}

class STOListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Location History")),
        body: FutureBuilder<List>(
          future: buildLocationsList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List? data = snapshot.data;
              return _jobsListView(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          DisplayLocation thisLocation = data[index];
          return _tile(
              thisLocation.locality +
                  ", " +
                  thisLocation.subAdministrativeArea +
                  ", " +
                  thisLocation.ISOCountry,
              thisLocation.timestamp,
              " \nActivity: " +
                  thisLocation.activity +
                  " \nSpeed: " +
                  thisLocation.speed.toString() +
                  " \nAltitude: " +
                  thisLocation.altitude.toString(),
              Icons.gps_fixed);
        });
  }

  ListTile _tile(String title, String subtitle, String text, IconData icon) =>
      ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: new RichText(
          text: new TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              new TextSpan(
                  text: subtitle,
                  style: new TextStyle(fontWeight: FontWeight.bold)),
              new TextSpan(text: text),
            ],
          ),
        ),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
      );
}
