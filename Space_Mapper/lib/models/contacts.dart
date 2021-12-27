final String tableContacts = 'contacts'; // Name of table in the database

// This file is used to store data in the database
class ContactFields {
  // Titles for the database columns
  static final int id = 0;
  static final String gender = '_gender';
  static final int ageGroup = -1;
}

class Contact {
  final String gender;
  final int ageGroup; //TODO: Should I do an enum for this?

  const Contact(this.gender, this.ageGroup);
}
