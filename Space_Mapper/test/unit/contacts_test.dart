import 'package:asm/models/contacts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Contact.blank', () {
    Contact contact = Contact.blank();

    expect(contact.id, 0);
    expect(contact.gender, ' ');
    expect(contact.ageGroup, ' ');
    expect(contact.date, DateTime.fromMillisecondsSinceEpoch(0));
  });

  group('Contact.copy', () {
    test('Contact.copy without arguments', () {
      Contact contact = Contact(
          id: 3, gender: 'male', ageGroup: '0-19', date: DateTime.now());
      Contact copiedContact = contact.copy(); //Copy without arguments

      // All the variables are copied except the id that is null
      //expect(copiedContact.id, contact.id);
      expect(copiedContact.gender, contact.gender);
      expect(copiedContact.ageGroup, contact.ageGroup);
      expect(copiedContact.date, contact.date);
    });

    test('Contact.copy with id as only argument', () {
      Contact contact = Contact(
          id: 93, gender: 'male', ageGroup: '0-19', date: DateTime.now());
      Contact copiedContact =
          contact.copy(id: contact.id); //id passed as the only argument

      expect(copiedContact.id, contact.id);
      expect(copiedContact.gender, contact.gender);
      expect(copiedContact.ageGroup, contact.ageGroup);
      expect(copiedContact.date, contact.date);
    });

    test('Contact.copy with all arguments passed', () {
      Contact contact = Contact(
          id: 67, gender: 'male', ageGroup: '10-19', date: DateTime.now());
      Contact copiedContact = contact.copy(
          id: contact.id,
          gender: contact.gender,
          ageGroup: contact.ageGroup,
          date: contact.date);

      expect(copiedContact.id, contact.id);
      expect(copiedContact.gender, contact.gender);
      expect(copiedContact.ageGroup, contact.ageGroup);
      expect(copiedContact.date, contact.date);
    });

    test('Contact.copy with an incorrect value', () {
      Contact contact = Contact(
          id: 7282, gender: 'male', ageGroup: '10-19', date: DateTime.now());
      Contact copiedContact = contact.copy(
          id: 3, //Incorrect id
          gender: 'female', //Incorrect gender
          ageGroup: '20-29', //Incorrect age group
          date: DateTime(1997)); //Incorrect date

      expect(copiedContact.id, isNot(contact.id));
      expect(copiedContact.gender, isNot(contact.gender));
      expect(copiedContact.ageGroup, isNot(contact.ageGroup));
      expect(copiedContact.date, isNot(contact.date));
    });
  });
}
