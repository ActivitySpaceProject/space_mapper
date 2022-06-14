final String tableName = 'unpushedLocations';

// Class used to store data in the database
class LocationToPushFields {
  static final List<String> values = [
    // Add all fields
    id, userUUID, userCode, appVersion, operativeSystem, typeOfData, message,
    longitude, latitude, unixTime, speed, activity, altitude
  ];

  // Titles for the database columns
  static final String id = '_id';
  static final String userUUID = 'userUUID';
  static final String userCode = 'userCode';
  static final String appVersion = 'appVersion';
  static final String operativeSystem = 'operativeSystem';
  static final String typeOfData = 'typeOfData';
  static final String message = 'message';
  static final String longitude = 'longitude';
  static final String latitude = 'latitude';
  static final String unixTime = 'unixTime';
  static final String speed = 'speed';
  static final String activity = 'activity';
  static final String altitude = 'altitude';
}

class LocationToPush {
  final int? id;
  final String? userUUID;
  final String? userCode;
  final String? appVersion;
  final String? operativeSystem;
  final String? typeOfData;
  final String? message;
  final double? longitude;
  final double? latitude;
  final String? unixTime;
  final double? speed;
  final String? activity;
  final String? altitude;

  const LocationToPush(
      {this.id,
      this.userUUID,
      this.userCode,
      this.appVersion,
      this.operativeSystem,
      this.typeOfData,
      this.message,
      this.longitude,
      this.latitude,
      this.unixTime,
      this.speed,
      this.activity,
      this.altitude});

  static LocationToPush fromJson(Map<String, Object?> json) => LocationToPush(
        id: json[LocationToPushFields.id] as int?,
        userUUID: json[LocationToPushFields.userUUID] as String,
        userCode: json[LocationToPushFields.userCode] as String,
        appVersion: json[LocationToPushFields.appVersion] as String,
        operativeSystem: json[LocationToPushFields.operativeSystem] as String,
        typeOfData: json[LocationToPushFields.typeOfData] as String,
        message: json[LocationToPushFields.message] as String,
        longitude: json[LocationToPushFields.longitude] as double,
        latitude: json[LocationToPushFields.latitude] as double,
        unixTime: json[LocationToPushFields.unixTime] as String,
        speed: json[LocationToPushFields.speed] as double,
        activity: json[LocationToPushFields.activity] as String,
        altitude: json[LocationToPushFields.altitude] as String,
      );

  Map<String, Object?> toJson() => {
        LocationToPushFields.id: id,
        LocationToPushFields.userUUID: userUUID,
        LocationToPushFields.userCode: userCode,
        LocationToPushFields.appVersion: appVersion,
        LocationToPushFields.operativeSystem: operativeSystem,
        LocationToPushFields.typeOfData: typeOfData,
        LocationToPushFields.message: message,
        LocationToPushFields.longitude: longitude,
        LocationToPushFields.latitude: latitude,
        LocationToPushFields.unixTime: unixTime,
        LocationToPushFields.speed: speed,
        LocationToPushFields.activity: activity,
        LocationToPushFields.altitude: altitude,
      };

  // Create a new instance of the class using the values passed as parameters.
  // When there are no values passed, the values from the current instance are copied into the new instance
  LocationToPush copy({
    int? id,
    String? userUUID,
    String? userCode,
    String? appVersion,
    String? operativeSystem,
    String? typeOfData,
    String? message,
    double? longitude,
    double? latitude,
    String? unixTime,
    double? speed,
    String? activity,
    String? altitude,
  }) =>
      LocationToPush(
        id: id,
        userUUID: userUUID ?? this.userUUID,
        userCode: userCode ?? this.userCode,
        appVersion: appVersion ?? this.appVersion,
        operativeSystem: operativeSystem ?? this.operativeSystem,
        typeOfData: typeOfData ?? this.typeOfData,
        message: message ?? this.message,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        unixTime: unixTime ?? this.unixTime,
        speed: speed ?? this.speed,
        activity: activity ?? this.activity,
        altitude: altitude ?? this.altitude,
      );
}
