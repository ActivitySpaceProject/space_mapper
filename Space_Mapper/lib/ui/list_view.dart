import '../models/list_view.dart';
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
    num speedAccuracy = locations[i]['coords']['speed_accuracy'];
    num altitude = locations[i]['coords']['altitude'];
    num altitudeAccuracy = locations[i]['coords']['altitude_accuracy'];
    var add = new DisplayLocation(locality!, administrativeArea!, ISOCountry!,
        timestamp, activity, speed, speedAccuracy, altitude, altitudeAccuracy);
    ret.add(add);
  }
  return ret;
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
              thisLocation.displayCustomText(),
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
