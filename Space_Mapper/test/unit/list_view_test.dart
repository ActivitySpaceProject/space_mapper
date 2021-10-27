//import 'package:asm/models/list_view.dart';
import 'package:test/test.dart';

void main() {
  group('Locations History Screen - Unit Tests', () {
    /*group('DisplayLocation class', () {
      group('formatTimestamp function', () {
        test('formatTimestamp: input a correct timestamp', () {
          String timestamp = "2021-10-25T21:25:08.210Z";
          DisplayLocation dL =
              new DisplayLocation("", "", "", timestamp, "", 0, 0, 0, 0);
          String ret = dL.formatTimestamp(dL.timestamp);
          expect(ret, "2021-10-25 | 21:25:08");
        });
      });

      group('displayCustomText function', () {
        test('displayCustomText: Result when all data is valid', () {
          String activity = "walking";
          num speed = 5;
          num speedAccuracy = 1;
          num altitude = 315;
          num altitudeAccuracy = 3;

          num maxSpeedAcc = 5;
          num maxAltitudeAcc = 5;

          DisplayLocation dL = new DisplayLocation("", "", "", "", activity,
              speed, speedAccuracy, altitude, altitudeAccuracy);

          String ret = dL.displayCustomText(maxSpeedAcc, maxAltitudeAcc);
          expect(
              ret,
              equals(" \nActivity: " +
                  activity +
                  " \nSpeed: " +
                  speed.toString() +
                  " m/s" +
                  "\nAltitude: " +
                  altitude.toString() +
                  " m"));
        });
        test('displayCustomText: Result when altitude in not accurate', () {
          String activity = "walking";
          num speed = 1;
          num speedAccuracy = 1;
          num altitude = 5;
          num altitudeAccuracy =
              50; //Is higher than max allowed altitude, so it should not print altitude

          num maxSpeedAcc = 5;
          num maxAltitudeAcc = 10;

          DisplayLocation dL = new DisplayLocation("", "", "", "", activity,
              speed, speedAccuracy, altitude, altitudeAccuracy);

          String ret = dL.displayCustomText(maxSpeedAcc, maxAltitudeAcc);
          expect(
              ret,
              equals(" \nActivity: " +
                  activity +
                  " \nSpeed: " +
                  speed.toString() +
                  " m/s"));
        });
        test(
            'displayCustomText: Result when speed and speedAccuracy is -1 (gps not used)',
            () {
          String activity = "walking";
          num speed = -1;
          num speedAccuracy = -1;
          num altitude = 5;
          num altitudeAccuracy = 10;

          num maxSpeedAcc = 5;
          num maxAltitudeAcc = 10;

          DisplayLocation dL = new DisplayLocation("", "", "", "", activity,
              speed, speedAccuracy, altitude, altitudeAccuracy);

          String ret = dL.displayCustomText(maxSpeedAcc, maxAltitudeAcc);
          expect(
              ret,
              equals(" \nActivity: " +
                  activity +
                  "\nAltitude: " +
                  altitude.toString() +
                  " m"));
        });
        test(
            'displayCustomText: Result when both speed and altitude are invalid',
            () {
          String activity = "walking";
          num speed = -1; //Invalid input, should not print speed
          num speedAccuracy =
              -1; //Invalid input. But anyway this numbers doesn't matter, because speed is already invalid
          num altitude = 5;
          num altitudeAccuracy =
              50; //Is higher than max allowed altitude, so it should not print altitude

          num maxSpeedAcc = 5;
          num maxAltitudeAcc = 10;

          DisplayLocation dL = new DisplayLocation("", "", "", "", activity,
              speed, speedAccuracy, altitude, altitudeAccuracy);

          String ret = dL.displayCustomText(maxSpeedAcc, maxAltitudeAcc);
          expect(ret, equals(" \nActivity: " + activity));
        });
      });
    });*/
  });
}
