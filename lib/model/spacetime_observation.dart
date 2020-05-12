// To parse this JSON data, do
//
//     final spacetimeObservation = spacetimeObservationFromJson(jsonString);

import 'dart:convert';

SpacetimeObservation spacetimeObservationFromJson(String str) => SpacetimeObservation.fromMap(json.decode(str));

String spacetimeObservationToJson(SpacetimeObservation data) => json.encode(data.toMap());

class SpacetimeObservation {
  int id;
  double time;
  double longitude;
  double latitude;
  double altitude;
  double accuracy;
  String source;
  bool moving;
  String travelMode;
  String nearestCellId;

  SpacetimeObservation({
    this.id,
    this.time,
    this.longitude,
    this.latitude,
    this.altitude,
    this.accuracy,
    this.source,
    this.moving,
    this.travelMode,
    this.nearestCellId,
  });

  factory SpacetimeObservation.fromMap(Map<String, dynamic> json) => SpacetimeObservation(
    id: json["id"],
    time: json["time"].toDouble(),
    longitude: json["longitude"].toDouble(),
    latitude: json["latitude"].toDouble(),
    altitude: json["altitude"].toDouble(),
    accuracy: json["accuracy"].toDouble(),
    source: json["source"],
    moving: json["moving"],
    travelMode: json["travel_mode"],
    nearestCellId: json["nearest_cell_ID"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "time": time,
    "longitude": longitude,
    "latitude": latitude,
    "altitude": altitude,
    "accuracy": accuracy,
    "source": source,
    "moving": moving,
    "travel_mode": travelMode,
    "nearest_cell_ID": nearestCellId,
  };
}
