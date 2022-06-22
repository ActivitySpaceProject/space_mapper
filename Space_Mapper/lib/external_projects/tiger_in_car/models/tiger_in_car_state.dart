final String tableTigerInCar = 'tigerInCar'; // Name of table in the database

// Class used to store data in the database
class TigerInCarFields {
  static final List<String> values = [
    // Add all fields
    id, millisecondsSinceEpoch, isAlive, message
  ];

  // Titles for the database columns
  static final String id = '_id';
  static final String millisecondsSinceEpoch = "millisecondsSinceEpoch";
  static final String isAlive = "isAlive";
  static final String message = "message";
}

// State of the mosquito tiger at a given moment in time
class TigerInCarState {
  final int? id;
  final DateTime date;
  final bool isAlive;  
  late String? message;

  TigerInCarState({this.id, required this.date, required this.isAlive, this.message});

  static TigerInCarState fromJson(Map<String, Object?> json) => TigerInCarState(
      id: json[TigerInCarFields.id] as int?,      
      date: DateTime.fromMillisecondsSinceEpoch(
          json[TigerInCarFields.millisecondsSinceEpoch] as int),
      isAlive: json[TigerInCarFields.isAlive] == 1,
      message: json[TigerInCarFields.message] as String?);

  Map<String, Object?> toJson() => {
        TigerInCarFields.id: id,        
        TigerInCarFields.millisecondsSinceEpoch: date.millisecondsSinceEpoch.toString(),
        TigerInCarFields.isAlive: isAlive,
        TigerInCarFields.message: message,
      };

  // Create a new instance of the class using the values passed as parameters. 
  // When there are no values passed, the values from the current instance are copied into the new instance  
  TigerInCarState copy({
    int? id,
    DateTime? date,
    bool? isAlive,
    String? message,
  }) =>
      TigerInCarState(
          id: id,          
          date: date ?? this.date,
          isAlive: isAlive ?? this.isAlive,
          message: message
          );
}
