class DisplayLocation {
  DisplayLocation(
      {String? locality,
      String? subAdministrativeArea,
      // ignore: non_constant_identifier_names
      String? ISOCountry,
      String? timestamp,
      String? activity,
      num? speed,
      num? speedAccuracy,
      num? altitude,
      num? altitudeAccuracy}) {
    if (locality != null) this.locality = locality;
    if (subAdministrativeArea != null)
      this.subAdministrativeArea = subAdministrativeArea;
    if (ISOCountry != null) this.ISOCountry = ISOCountry;
    if (timestamp != null) this.timestamp = formatTimestamp(timestamp);
    if (activity != null) this.activity = activity;
    if (speed != null) this.speed = speed;
    if (speedAccuracy != null) this.speedAccuracy = speedAccuracy;
    if (altitude != null) this.altitude = altitude;
    if (altitudeAccuracy != null) this.altitudeAccuracy = altitudeAccuracy;
  }
  late String locality;
  late String subAdministrativeArea;
  // ignore: non_constant_identifier_names
  late String ISOCountry; // 2 letter code
  late String timestamp; // ex: 2021-10-25T21:25:08.210Z
  late String activity;
  late num speed; //in meters / second
  late num speedAccuracy; //in meters / second
  late num altitude; //in meters
  late num altitudeAccuracy; // in meters

  /// Makes timestamp readable by a human
  String formatTimestamp(String timestamp) {
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

  /// Checks if data is valid and then displays 3 lines with: Activity, Speed and Altitude
  String displayCustomText(num maxSpeedAccuracy, num maxAltitudeAccuracy) {
    String ret = "";

    ret += " \nActivity: " + activity;

    /// Speed has to be both valid and accurate
    if (speed != -1 && speedAccuracy != -1) {
      if (speedAccuracy <= maxSpeedAccuracy)
        ret += " \nSpeed: " + speed.toString() + " m/s";
    }
    if (altitudeAccuracy <= maxAltitudeAccuracy)
      ret += "\nAltitude: " + altitude.toString() + " m";

    return ret;
  }
}
