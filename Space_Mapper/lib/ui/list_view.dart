import '../app_localizations.dart';
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

CustomLocation createCustomLocation(
    var recordedLocation, Placemark? placemark) {
  CustomLocation location = new CustomLocation();
  //Add location to list
  //CustomLocationsManager.customLocations.add(location);

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

  return location;
}

class STOListView extends StatefulWidget {
  const STOListView({Key? key}) : super(key: key);

  @override
  _STOListViewState createState() => _STOListViewState();
}

class _STOListViewState extends State<STOListView> {
  final int maxElements = 25; // Maximum amount of elements displayed on screen

  Future<List<CustomLocation>> recalculateLocations() async {
    List<CustomLocation> customLocations = [];

    // Make the current list to be empty. We want to fill it according to our custom parameters
    //CustomLocationsManager.removeAllCustomLocations();

    // Get a list of locations from the flutter_background_geolocation plugin database
    List recordedLocations = await bg.BackgroundGeolocation.locations;

    // n is the minimum value of either the specified maximum amount of elements (maxElements), or the current size of recordedLocations
    int n;
    if (maxElements <= recordedLocations.length)
      n = maxElements;
    else
      n = recordedLocations.length;

    // Fill the custom locations list, to display beautiful tiles instead of json data
    for (int i = 0; i < n; ++i) {
      // Check if there's already a location with the same UUID
      for (int j = customLocations.length - 1; j >= 0; --j) {
        if (recordedLocations[i]['uuid'] == customLocations[j].getUUID())
          continue; //CustomLocationsManager.customLocations[j].getUUID()) continue;
      }
      // Match not found, we add the location
      CustomLocation newLocation = createCustomLocation(
          recordedLocations[i],
          await getLocationData(recordedLocations[i]['coords']['latitude'],
              recordedLocations[i]['coords']['longitude']));
      customLocations.add(newLocation);
    }
    return customLocations;
  }

  @override
  void initState() {
    super.initState();
    //recalculateLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                AppLocalizations.of(context)!.translate("locations_history"))),
        body: FutureBuilder<List<CustomLocation>>(
          future: recalculateLocations(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Container();
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  CustomLocation thisLocation = snapshot.data![index];
                  return Dismissible(
                    child: _tile(thisLocation, context),
                    background: Container(
                      child: Container(
                        margin: EdgeInsets.only(right: 10.0),
                        alignment: Alignment.centerRight,
                        child:
                            new LayoutBuilder(builder: (context, constraint) {
                          return new Icon(Icons.delete_forever,
                              size: constraint.biggest.height * 0.5);
                        }),
                      ),
                      color: Colors.red,
                    ),
                    key: new UniqueKey(),
                    onDismissed: (direction) async => {
                      await thisLocation.deleteThisLocation(),
                      Scaffold.of(context).showSnackBar(
                          new SnackBar(content: new Text("Location removed")))
                    },
                    /*confirmDismiss: (DismissDirection direction) async {
                      //if(direction == DismissDirection.)
                      // if (direction == left)
                      await thisLocation.deleteThisLocation();
                      setState(() {
                        //recalculateLocations();
                        //thisLocation = snapshot.data![index];
                      });
                      return true;
                    },*/
                  );
                });
          },
        ));
  }

  ListTile _tile(CustomLocation thisLocation, BuildContext context) {
    String title = thisLocation.getLocality() +
        ", " +
        thisLocation.getSubAdministrativeArea() +
        ", " +
        thisLocation.getISOCountryCode();
    String subtitle =
        thisLocation.getTimestamp() + "\n" + thisLocation.getStreet();
    String text = thisLocation.displayCustomText(10.0, 10.0, context);
    return ListTile(
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
        Icons.gps_fixed,
        color: Colors.blue[500],
      ),
    );
  }
}
