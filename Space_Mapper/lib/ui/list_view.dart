import '../models/list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:geocoding/geocoding.dart';

Future<DisplayLocation?> getLocationData(double lat, double long) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      lat,
      long,
    );
    String? locality = placemarks[0].locality;
    String? subAdminArea = placemarks[0].subAdministrativeArea;
    // ignore: non_constant_identifier_names
    String? ISO = placemarks[0].isoCountryCode;
    DisplayLocation location = new DisplayLocation(
        locality: locality,
        subAdministrativeArea: subAdminArea,
        ISOCountry: ISO);
    return location;
  } catch (err) {
    return new DisplayLocation();
  }
}

Future<List<dynamic>>? buildLocationsList() async {
  List locations = await bg.BackgroundGeolocation.locations;
  List ret = [];

  for (int i = 0; i < locations.length; ++i) {
    DisplayLocation? location = await getLocationData(
        locations[i]['coords']['latitude'],
        locations[i]['coords']['longitude']);

    if (location != null) {
      location.timestamp = locations[i]['timestamp'];
      location.activity = locations[i]['activity']['type'];
      location.speed = locations[i]['coords']['speed'];
      location.speedAccuracy = locations[i]['coords']['speed_accuracy'];
      location.altitude = locations[i]['coords']['altitude'];
      location.altitudeAccuracy = locations[i]['coords']['altitude_accuracy'];
      ret.add(location);
    }
  }
  return ret;
}

class STOListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Locations History")),
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
              thisLocation.displayCustomText(10.0, 10.0),
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
