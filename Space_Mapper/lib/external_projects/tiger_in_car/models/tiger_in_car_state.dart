final String tableTigerInCar = 'tigerInCar'; // Name of table in the database

// Class used to store data in the database
class TigerInCarFields {
  static final List<String> values = [
    // Add all fields
    id, millisecondsSinceEpoch, isAlive, comment
  ];

  // Titles for the database columns
  static final String id = '_id';
  static final String millisecondsSinceEpoch = "millisecondsSinceEpoch";
  static final String isAlive = "isAlive";
  static final String comment = "comment";
}

// State of the mosquito tiger at a given moment in time
class TigerInCarState {
  final int? id;
  final DateTime date;
  final bool isAlive;  
  final String? comment;

  const TigerInCarState({this.id, required this.date, required this.isAlive, this.comment});

  static TigerInCarState fromJson(Map<String, Object?> json) => TigerInCarState(
      id: json[TigerInCarFields.id] as int?,      
      date: DateTime.fromMillisecondsSinceEpoch(
          json[TigerInCarFields.millisecondsSinceEpoch] as int),
      isAlive: json[TigerInCarFields.isAlive] == 1,
      comment: json[TigerInCarFields.comment] as String?);

  Map<String, Object?> toJson() => {
        TigerInCarFields.id: id,        
        TigerInCarFields.millisecondsSinceEpoch: date.millisecondsSinceEpoch.toString(),
        TigerInCarFields.isAlive: isAlive,
        TigerInCarFields.comment: comment,
      };

  // Create a new instance of the class using the values passed as parameters. 
  // When there are no values passed, the values from the current instance are copied into the new instance  
  TigerInCarState copy({
    int? id,
    DateTime? date,
    bool? isAlive,
    String? comment,
  }) =>
      TigerInCarState(
          id: id,          
          date: date ?? this.date,
          isAlive: isAlive ?? this.isAlive,
          comment: comment
          );
}
