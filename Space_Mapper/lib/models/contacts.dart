final String tableContacts = 'contacts'; // Name of table in the database

// This file is used to store data in the database
class ContactFields {
  static final List<String> values = [
    // Add all fields
    id, gender, ageGroup
  ];

  // Titles for the database columns
  static final String id = '_id';
  static final String gender = 'gender';
  static final String ageGroup = 'ageGroup';
}

class Contact {
  final int? id;
  final String gender;
  final String ageGroup; //TODO: Should I do an enum for this?

  const Contact({this.id, required this.gender, required this.ageGroup});

  static Contact fromJson(Map<String, Object?> json) => Contact(
      id: json[ContactFields.id] as int?,
      gender: json[ContactFields.gender] as String,
      ageGroup: json[ContactFields.ageGroup] as String);

  Map<String, Object?> toJson() => {
        ContactFields.id: id,
        ContactFields.gender: gender,
        ContactFields.ageGroup: ageGroup,
      };

  Contact copy({
    int? id,
    String? gender,
    String? ageGroup,
  }) =>
      Contact(
          id: id,
          gender: gender ?? this.gender,
          ageGroup: ageGroup ?? this.ageGroup);
}
