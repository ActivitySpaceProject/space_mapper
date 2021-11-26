import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:geocoding/geocoding.dart';
import '../app_localizations.dart';

class CustomLocationsManager {
  static Future<List<CustomLocation>> getLocations(int maxElements) async {
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
      CustomLocation newLocation =
          await CustomLocationsManager.createCustomLocation(
              recordedLocations[i]);
      customLocations.add(newLocation);
    }
    return customLocations;
  }

  /// Makes timestamp readable by a human
  static String formatTimestamp(String timestamp) {
    //2021-10-25T21:25:08.210Z <- This is the original format
    //2021-10-25 | 21:25:08    <- This is the result
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

  static Future<CustomLocation> createCustomLocation(
      var recordedLocation) async {
    CustomLocation location = new CustomLocation();

    //Save data from flutter_background_geolocation library
    location.setUUID(recordedLocation['uuid']);
    location.setTimestamp(recordedLocation['timestamp']);
    location.setActivity(recordedLocation['activity']['type']);
    location.setSpeed(recordedLocation['coords']['speed'],
        recordedLocation['coords']['speed_accuracy']);
    location.setAltitude(recordedLocation['coords']['altitude'],
        recordedLocation['coords']['altitude_accuracy']);

    Placemark? placemark = await getLocationData(
        recordedLocation['coords']['latitude'],
        recordedLocation['coords']['longitude']);

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

  ///Get data such as city, province, postal code, street name, country...
  static Future<Placemark?> getLocationData(double lat, double long) async {
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
}

/// This class should be used to share your location history to other people
class ShareLocation {
  late final String _timestamp;
  final double _lat;
  final double _long;

  ShareLocation(this._timestamp, this._lat, this._long);

  Map<String, dynamic> toJson() => {
        'timestamp': _timestamp,
        'coords': {
          'latitude': _lat,
          'longitude': _long,
        }
      };
}

class CustomLocation {
  late final String _uuid;
  late String _locality = "";
  late String _subAdministrativeArea = "";
  late String _street = "";
  // ignore: non_constant_identifier_names
  late String _ISOCountry = ""; // 2 letter code
  late String _timestamp = "";
  late String _activity = "";
  late num _speed = -1; //in meters / second
  late num _speedAccuracy = -1; //in meters / second
  late num _altitude = -1; //in meters
  late num _altitudeAccuracy = -1; // in meters
  late bool _toDelete = false;

  /// Checks if data is valid and then displays 3 lines with: Activity, Speed and Altitude
  String displayCustomText(
      num maxSpeedAccuracy, num maxAltitudeAccuracy, BuildContext context) {
    String ret = "";

    String activity = AppLocalizations.of(context)!.translate("activity");
    String speed = AppLocalizations.of(context)!.translate("speed");
    String altitude = AppLocalizations.of(context)!.translate("altitude");

    ret += " \n$activity: $_activity";

    /// Speed has to be both valid and accurate
    if (_speed != -1 && _speedAccuracy != -1) {
      if (_speedAccuracy <= maxSpeedAccuracy)
        ret += " \n$speed: " + _speed.toString() + " m/s";
    }
    if (_altitudeAccuracy <= maxAltitudeAccuracy)
      ret += "\n$altitude: " + _altitude.toString() + " m";

    return ret;
  }

  Future<void> deleteThisLocation() async {
    if (_toDelete == false) {
      /// We need this checker to ensure that the user doesn't send the delete request twice, causing an exception
      _toDelete = true;
      await bg.BackgroundGeolocation.destroyLocation(this.getUUID());
      //CustomLocationsManager.customLocations
      //    .removeWhere((element) => element.getUUID() == this.getUUID());
    }
  }

  // Variable setters
  void setUUID(String uuid) {
    _uuid = uuid;
  }

  void setLocality(String locality) {
    _locality = locality;
  }

  void setSubAdministrativeArea(String subAdminArea) {
    _subAdministrativeArea = subAdminArea;
  }

  void setStreet(String street) {
    _street = street;
  }

  void setISOCountry(String iso) {
    _ISOCountry = iso;
  }

  void setTimestamp(String timestamp) {
    _timestamp = CustomLocationsManager.formatTimestamp(timestamp);
  }

  void setActivity(String activity) {
    _activity = activity;
  }

  void setSpeed(num speed, num speedAcc) {
    _speed = speed;
    _speedAccuracy = speedAcc;
  }

  void setAltitude(num altitude, num altitudeAcc) {
    _altitude = altitude;
    _altitudeAccuracy = altitudeAcc;
  }

  // Variable getters
  String getUUID() {
    return _uuid;
  }

  String getLocality() {
    return _locality;
  }

  String getSubAdministrativeArea() {
    return _subAdministrativeArea;
  }

  String getStreet() {
    return _street;
  }

  String getISOCountryCode() {
    return _ISOCountry;
  }

  String getTimestamp() {
    return _timestamp;
  }

  String getActivity() {
    return _activity;
  }

  num getSpeed() {
    return _speed;
  }

  num getSpeedAcc() {
    return _speedAccuracy;
  }

  num getAltitude() {
    return _altitude;
  }

  num getAltitudeAcc() {
    return _altitude;
  }
}
