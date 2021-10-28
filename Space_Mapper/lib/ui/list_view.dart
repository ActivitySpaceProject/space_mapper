import '../models/list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:geocoding/geocoding.dart';

///Get data such as city, province, postal code, street name, country...
Future<Placemark?> getLocationData(double lat, double long) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      lat,
      long,
    );
    return placemarks[0];
  } catch (err) {
    return null;
  }
}

void createCustomLocation(var recordedLocation, Placemark? placemark) {
  CustomLocation location = new CustomLocation();
  //Add location to list
  CustomLocationsManager.customLocations.add(location);

  //Save data from flutter_background_geolocation library
  location.setUUID(recordedLocation['uuid']);
  location.setTimestamp(recordedLocation['timestamp']);
  location.setActivity(recordedLocation['activity']['type']);
  location.setSpeed(recordedLocation['coords']['speed'],
      recordedLocation['coords']['speed_accuracy']);
  location.setAltitude(recordedLocation['coords']['altitude'],
      recordedLocation['coords']['altitude_accuracy']);

  //Add our custom data
  if (placemark != null) {
    String? locality = placemark.locality;
    String? subAdminArea = placemark.subAdministrativeArea;
    String? street = placemark.street;
    if (street != null) street += ", ${placemark.name}";
    // ignore: non_constant_identifier_names
    String? ISO = placemark.isoCountryCode;

    location.setLocality(locality!);
    location.setSubAdministrativeArea(subAdminArea!);
    location.setStreet(street!);
    location.setISOCountry(ISO!);
  }
}

class STOListView extends StatefulWidget {
  const STOListView({Key? key}) : super(key: key);

  @override
  _STOListViewState createState() => _STOListViewState();
}

class _STOListViewState extends State<STOListView> {
  late List<CustomLocation> items = CustomLocationsManager.fetchAll();

  /*Future<void> _recalculateLocations() async {
    await recalculateLocations();
    setState(() {
      items = CustomLocationsManager.fetchAll();
    });
  }*/

  Future<void> recalculateLocations() async {
    List recordedLocations = await bg.BackgroundGeolocation.locations;
    int recordedLocationsSize = recordedLocations.length;
    List<CustomLocation> customLocations = CustomLocationsManager.fetchAll();

    /// We check if there are new location entries that we haven't saved in our list
    if (recordedLocationsSize != customLocations.length) {
      for (int i = 0; i < recordedLocationsSize; ++i) {
        //for (int i = 0; i < 10; ++i) {
        //TODO: This is a mock to delete
        // TODO: This nested 'for' has a complexity of O(n^2), we could make it more efficient
        for (int j = 0; j < customLocations.length; ++j) {
          if (recordedLocations[i]['uuid'] ==
              CustomLocationsManager.customLocations[j].getUUID()) continue;
        }
        //Match not found, we add the location
        createCustomLocation(
            recordedLocations[i],
            await getLocationData(recordedLocations[i]['coords']['latitude'],
                recordedLocations[i]['coords']['longitude']));

        //We update the state to display the new locations
        if (this
            .mounted) // We check if this screen is active. If we do 'setState' while it's not active, it'll crash (throw exception)
        {
          setState(() {
            items = CustomLocationsManager.fetchAll();
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    recalculateLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Locations History")),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            CustomLocation thisLocation = items[index];
            return _tile(
                thisLocation.getLocality() +
                    ", " +
                    thisLocation.getSubAdministrativeArea() +
                    ", " +
                    thisLocation.getISOCountryCode(),
                thisLocation.getTimestamp() + "\n" + thisLocation.getStreet(),
                thisLocation.displayCustomText(10.0, 10.0),
                Icons.gps_fixed);
          },
        ));
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

/*class STOListView extends StatelessWidget {
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
          CustomLocation thisLocation = data[index];
          return _tile(
              thisLocation.getUUID().toString() +
                  thisLocation.getLocality() +
                  ", " +
                  thisLocation.getSubAdministrativeArea() +
                  ", " +
                  thisLocation.getISOCountryCode(),
              thisLocation.getTimestamp(),
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
}*/
