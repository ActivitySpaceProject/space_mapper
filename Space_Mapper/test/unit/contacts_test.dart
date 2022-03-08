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

  group('Contact.toJson', () {
    test('toJson works', () {
      DateTime date = DateTime.now();
      Contact contact =
          Contact(id: 3, gender: 'male', ageGroup: '0-19', date: date);

      Map<String, Object?> jsonResult = contact.toJson();

      expect(jsonResult['_id'], 3);
      expect(jsonResult['gender'], 'male');
      expect(jsonResult['ageGroup'], '0-19');
      expect(jsonResult['millisecondsSinceEpoch'],
          date.millisecondsSinceEpoch.toString());
    });
    test('toJson tests that should fail', () {
      DateTime date = DateTime.now();
      Contact contact =
          Contact(id: 3, gender: 'male', ageGroup: '0-19', date: date);

      Map<String, Object?> jsonResult = contact.toJson();

      // id different than 3 should be false
      expect(jsonResult['_id'] == 0, isFalse);
      expect(jsonResult['_id'] == 1, isFalse);
      expect(jsonResult['_id'] == 2, isFalse);
      expect(jsonResult['_id'] == 4, isFalse);
      expect(jsonResult['_id'] == 5, isFalse);
      // genders different than 'male' should be false
      expect(jsonResult['gender'] == 'female', isFalse);
      expect(jsonResult['gender'] == 'other', isFalse);
      // ageGroup different than '10-19' should be false
      expect(jsonResult['ageGroup'] == '0-9', isFalse);
      expect(jsonResult['ageGroup'] == '20-29', isFalse);
      expect(jsonResult['ageGroup'] == '30-39', isFalse);
      expect(jsonResult['ageGroup'] == '40-49', isFalse);
      expect(jsonResult['ageGroup'] == '50-59', isFalse);
      expect(jsonResult['ageGroup'] == '60-69', isFalse);
      expect(jsonResult['ageGroup'] == '70-79', isFalse);
      expect(jsonResult['ageGroup'] == '80+', isFalse);
      // datetimes different than the one defined in variable "date" should be false
      expect(
          jsonResult['millisecondsSinceEpoch'] ==
              (date.millisecondsSinceEpoch - 1).toString(),
          isFalse);
      expect(
          jsonResult['millisecondsSinceEpoch'] ==
              (date.millisecondsSinceEpoch + 1).toString(),
          isFalse);
    });
  });

  group('Contact.fromJson', () {
    test('fromJson works', () {
      Map<String, Object?> jsonOrigin = {};

      // Values that will be used
      int id = 0;
      String gender = 'female';
      String ageGroup = '0-9';
      DateTime date = DateTime.now();

      // Initialize json data
      jsonOrigin['_id'] = id;
      jsonOrigin['gender'] = gender;
      jsonOrigin['ageGroup'] = ageGroup;
      jsonOrigin['millisecondsSinceEpoch'] = date.millisecondsSinceEpoch;

      Contact contact = Contact.fromJson(jsonOrigin);

      expect(contact.id, id);
      expect(contact.gender, gender);
      expect(contact.ageGroup, ageGroup);
      // Date can experience some decimal variances, so "expect(contact.date, date)" would fail the test even if it's correct
      // For example, we would see: TestFailure
      // (Expected: DateTime:<2022-02-22 13:37:12.766257>
      // Actual: DateTime:<2022-02-22 13:37:12.766>
      // For this reason, the test will accept minimal discrepancies
      expect(contact.date.year, date.year);
      expect(contact.date.month, date.month);
      expect(contact.date.day, date.day);
      expect(contact.date.hour, date.hour);
      expect(contact.date.minute, date.minute);
      expect(contact.date.second, date.second);
    });
  });
}
