final String tableTigerInCar = 'tigerInCar'; // Name of table in the database

// Class used to store data in the database
class TigerInCarFields {
  static final List<String> values = [
    // Add all fields
    id, millisecondsSinceEpoch, isAlive
  ];

  // Titles for the database columns
  static final String id = '_id';
  static final String millisecondsSinceEpoch = "millisecondsSinceEpoch";
  static final String isAlive = "isAlive";
}

// State of the mosquito tiger at a given moment in time
class TigerInCarState {
  final int? id;
  final DateTime date;
  final bool isAlive;  

  const TigerInCarState({this.id, required this.date, required this.isAlive});

  static TigerInCarState fromJson(Map<String, Object?> json) => TigerInCarState(
      id: json[TigerInCarFields.id] as int?,
      isAlive: json[TigerInCarFields.isAlive] == 1,
      date: DateTime.fromMillisecondsSinceEpoch(
          json[TigerInCarFields.millisecondsSinceEpoch] as int));

  Map<String, Object?> toJson() => {
        TigerInCarFields.id: id,
        TigerInCarFields.isAlive: isAlive,
        TigerInCarFields.millisecondsSinceEpoch: date.millisecondsSinceEpoch.toString(),
      };

  TigerInCarState copy({
    int? id,
    String? gender,
    String? ageGroup,
    DateTime? date,
  }) =>
      TigerInCarState(
          id: id,
          isAlive: isAlive,
          date: date ?? this.date);

  Future<void> sendReport() async {
    // Get all locations from history

    // Filter to save only the locations recorded in_vehicle

    // Send the json with car positions
  }
}
