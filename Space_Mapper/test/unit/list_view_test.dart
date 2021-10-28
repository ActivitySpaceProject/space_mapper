import '../../lib/models/list_view.dart';
import 'package:test/test.dart';

void main() {
  group('Locations History Screen - Unit Tests', () {
    group('DisplayLocation class', () {
      group('formatTimestamp function', () {
        test('formatTimestamp: input a correct timestamp', () {
          String timestamp = "2021-10-25T21:25:08.210Z";
          CustomLocation dL = new CustomLocation();
          dL.setTimestamp(timestamp);
          String ret = dL.formatTimestamp(dL.getTimestamp());
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
  });
}
