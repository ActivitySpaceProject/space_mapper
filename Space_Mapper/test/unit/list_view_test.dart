import 'package:asm/models/list_view.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

void main() {
  group('Locations History Screen - Unit Tests', () {
    group('CustomLocation class', () {
      group('formatTimestamp function', () {
        test('formatTimestamp: input a correct timestamp', () {
          String timestamp = "2021-10-25T21:25:08.210Z";
          CustomLocation dL = new CustomLocation();
          dL.setTimestamp(timestamp);
          String ret =
              CustomLocationsManager.formatTimestamp(dL.getTimestamp());
          expect(ret, "2021-10-25 | 21:25:08");
        });
      });

      group('displayCustomText function', () {
        test('displayCustomText: Result when all data is valid', () {
          CustomLocation location = new CustomLocation();
          location.setActivity("walking");
          location.setSpeed(5, 1);
          location.setAltitude(315, 3);

          num maxSpeedAcc = 5;
          num maxAltitudeAcc = 5;

          String ret = location.displayCustomText(maxSpeedAcc, maxAltitudeAcc);
          expect(
              ret,
              equals(" \nActivity: " +
                  location.getActivity() +
                  " \nSpeed: " +
                  location.getSpeed().toString() +
                  " m/s" +
                  "\nAltitude: " +
                  location.getAltitude().toString() +
                  " m"));
        });
        test('displayCustomText: Result when altitude in not accurate', () {
          CustomLocation location = new CustomLocation();
          location.setActivity("walking");
          location.setSpeed(1, 1);
          location.setAltitude(5,
              50); //It'ss higher than max allowed altitude, so it should not print altitude

          num maxSpeedAcc = 5;
          num maxAltitudeAcc = 10;

          String ret = location.displayCustomText(maxSpeedAcc, maxAltitudeAcc);
          expect(
              ret,
              equals(" \nActivity: " +
                  location.getActivity() +
                  " \nSpeed: " +
                  location.getSpeed().toString() +
                  " m/s"));
        });
        test(
            'displayCustomText: Result when speed and speedAccuracy is -1 (gps not used)',
            () {
          CustomLocation location = new CustomLocation();
          location.setActivity("walking");
          location.setSpeed(-1, -1);
          location.setAltitude(5, 10);

          num maxSpeedAcc = 5;
          num maxAltitudeAcc = 10;

          String ret = location.displayCustomText(maxSpeedAcc, maxAltitudeAcc);
          expect(
              ret,
              equals(" \nActivity: " +
                  location.getActivity() +
                  "\nAltitude: " +
                  location.getAltitude().toString() +
                  " m"));
        });
        test(
            'displayCustomText: Result when both speed and altitude are invalid',
            () {
          CustomLocation location = new CustomLocation();
          location.setActivity("walking");
          location.setSpeed(-1, -1); //Invalid input, should not print speed
          location.setAltitude(5,
              50); //Accuracy is higher than max allowed altitude, so it should not print altitude

          num maxSpeedAcc = 5;
          num maxAltitudeAcc = 10;

          String ret = location.displayCustomText(maxSpeedAcc, maxAltitudeAcc);
          expect(ret, equals(" \nActivity: " + location.getActivity()));
        });
      });
    });
    group("CustomLocationsManager class", () {
      test("fetchAll and fetchByUUID", () async {
        //We create 50 fake locations to do the test
        for (int i = 0; i < 50; i++) {
          CustomLocation location = new CustomLocation();
          location.setUUID(faker.guid.guid());
          location.setActivity("walk");
          location.setAltitude(
              faker.randomGenerator
                  .numbers(8848, 1)[0], //8848 metres is Mount Everest height
              faker.randomGenerator.numbers(300, 1)[0]);
          location.setSpeed(faker.randomGenerator.numbers(600, 1)[0],
              faker.randomGenerator.numbers(300, 1)[0]);
          location.setISOCountry(faker.address.countryCode());
          location.setLocality(faker.address.city());
          location.setStreet(faker.address.streetAddress());
          location.setSubAdministrativeArea(faker.address.state());
          location.setTimestamp(faker.date.random.toString());
          CustomLocationsManager.customLocations.add(location);
        }

        List<CustomLocation> locations =
            CustomLocationsManager.fetchAll(sortByNewest: true);
        for (var location in locations) {
          expect(location.getUUID(), isNotEmpty);

          CustomLocation? fetchedLocation =
              CustomLocationsManager.fetchByUUID(location.getUUID());

          expect(fetchedLocation,
              isNotNull); // Not null because we get the UUID from the list, so it must exist

          if (fetchedLocation != null) {
            // Test that every fetched location is exactly equal as the current location
            expect(fetchedLocation.getUUID(), equals(location.getUUID()));
            expect(
                fetchedLocation.getActivity(), equals(location.getActivity()));
            expect(
                fetchedLocation.getAltitude(), equals(location.getAltitude()));
            expect(fetchedLocation.getAltitudeAcc(),
                equals(location.getAltitudeAcc()));
            expect(fetchedLocation.getISOCountryCode(),
                equals(location.getISOCountryCode()));
            expect(
                fetchedLocation.getLocality(), equals(location.getLocality()));
            expect(fetchedLocation.getSpeed(), equals(location.getSpeed()));
            expect(
                fetchedLocation.getSpeedAcc(), equals(location.getSpeedAcc()));
            expect(fetchedLocation.getStreet(), equals(location.getStreet()));
            expect(fetchedLocation.getSubAdministrativeArea(),
                equals(location.getSubAdministrativeArea()));
            expect(fetchedLocation.getTimestamp(),
                equals(location.getTimestamp()));
          }
        }
      });
    });
  });
}
