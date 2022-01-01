final String tableContacts = 'contacts'; // Name of table in the database

// Class used to store data in the database
class ContactFields {
  static final List<String> values = [
    // Add all fields
    id, gender, ageGroup, millisecondsSinceEpoch
  ];

  // Titles for the database columns
  static final String id = '_id';
  static final String gender = 'gender';
  static final String ageGroup = 'ageGroup';
  static final String millisecondsSinceEpoch = "millisecondsSinceEpoch";
}

// Class used inside the app
class Contact {
  final int? id;
  final String gender;
  final String ageGroup;
  final DateTime date;

  const Contact(
      {this.id,
      required this.gender,
      required this.ageGroup,
      required this.date});

  static Contact fromJson(Map<String, Object?> json) => Contact(
      id: json[ContactFields.id] as int?,
      gender: json[ContactFields.gender] as String,
      ageGroup: json[ContactFields.ageGroup] as String,
      date: DateTime.fromMillisecondsSinceEpoch(
          json[ContactFields.millisecondsSinceEpoch] as int));

  Map<String, Object?> toJson() => {
        ContactFields.id: id,
        ContactFields.gender: gender,
        ContactFields.ageGroup: ageGroup,
        ContactFields.millisecondsSinceEpoch:
            date.millisecondsSinceEpoch.toString(),
      };

  Contact copy({
    int? id,
    String? gender,
    String? ageGroup,
    DateTime? date,
  }) =>
      Contact(
          id: id,
          gender: gender ?? this.gender,
          ageGroup: ageGroup ?? this.ageGroup,
          date: date ?? this.date);
}
