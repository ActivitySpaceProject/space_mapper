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
  late List<CustomLocation> customLocations =
      CustomLocationsManager.fetchAll(sortByNewest: true);

  Future<void> recalculateLocations() async {
    List recordedLocations = await bg.BackgroundGeolocation.locations;

    /// We check if there are new location entries that we haven't saved in our list
    if (recordedLocations.length != customLocations.length) {
      for (int i = recordedLocations.length - 1; i >= 0; --i) {
        for (int j = customLocations.length - 1; j >= 0; --j) {
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
            customLocations =
                CustomLocationsManager.fetchAll(sortByNewest: true);
            print("Loading positions: " +
                customLocations.length.toString() +
                " out of " +
                recordedLocations.length.toString());
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
        appBar: AppBar(
            title: Text(
                AppLocalizations.of(context)!.translate("locations_history"))),
        body: ListView.builder(
          itemCount: customLocations.length,
          itemBuilder: (context, index) {
            CustomLocation thisLocation = customLocations[index];
            return Dismissible(
              child: _tile(thisLocation, context),
              background: Container(
                child: Container(
                  margin: EdgeInsets.only(right: 10.0),
                  alignment: Alignment.centerRight,
                  child: new LayoutBuilder(builder: (context, constraint) {
                    return new Icon(Icons.delete_forever,
                        size: constraint.biggest.height * 0.5);
                  }),
                ),
                color: Colors.red,
              ),
              key: ValueKey<CustomLocation>(customLocations[index]),
              confirmDismiss: (DismissDirection direction) async {
                await thisLocation.deleteThisLocation();
                setState(() {
                  customLocations =
                      CustomLocationsManager.fetchAll(sortByNewest: true);
                  thisLocation = customLocations[index];
                });
                return true;
              },
            );
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
