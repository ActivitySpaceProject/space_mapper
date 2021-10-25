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
    String? ISOCountry = await getLocationData(
        "ISOCountry",
        locations[i]['coords']['latitude'],
        locations[i]['coords']['longitude']);
    String timestamp = locations[i]['timestamp'];
    String activity = locations[i]['activity']['type'];
    num speed = locations[i]['coords']['speed'];
    num altitude = locations[i]['coords']['altitude'];
    var add = new displayLocation(locality!, administrativeArea!, ISOCountry!,
        timestamp, activity, speed, altitude);
    ret.add(add);
  }
  return ret;
}

class displayLocation {
  displayLocation(this.locality, this.subAdministrativeArea, this.ISOCountry,
      this.timestamp, this.activity, this.speed, this.altitude);
  late String locality;
  late String subAdministrativeArea;
  late String ISOCountry;
  late String timestamp;
  late String activity;
  late num speed;
  late num altitude;
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
            return CircularProgressIndicator();
          },
        ));
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          displayLocation thisLocation = data[index];
          return _tile(
              thisLocation.locality +
                  ", " +
                  thisLocation.subAdministrativeArea +
                  ", " +
                  thisLocation.ISOCountry,
              thisLocation.timestamp +
                  " Activity: " +
                  thisLocation.activity +
                  " Speed: " +
                  thisLocation.speed.toString() +
                  " Altitude: " +
                  thisLocation.altitude.toString(),
              Icons.gps_fixed);
        });
  }

  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(subtitle),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
      );
}
