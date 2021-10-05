import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'ENV.dart';

void _onHttp(bg.HttpEvent event) async {

  switch (event.status) {
    case 403:
    case 406:
      print("[TransistorAuth] onHttp status ${event.status}");
      await bg.TransistorAuthorizationToken.destroy(ENV.TRACKER_HOST);
      bool success = await TransistorAuth.register();
      if (success) {
        bg.BackgroundGeolocation.sync().catchError((error) {
          print("[sync] error: $error");
        });
      }
      break;
    case 410:
      print('[TransistorAuth] It seems this device has been destroyed from the server.  The authentication token is no longer valid.');
      // For now in this case we will do nothing. Consider alternatives
      break;
  }
}

class TransistorAuth {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<bool> register() async {
    try {
      SharedPreferences prefs = await _prefs;
      // Request a JWT from server
      String sample_id = prefs.getString("sample_id");
      String user_uuid = prefs.getString("user_uuid");
      if (sample_id == null || user_uuid == null) {
        // TODO throw an Error instead.
        return false;
      }

      bg.TransistorAuthorizationToken jwt = await bg.TransistorAuthorizationToken.findOrCreate(sample_id, user_uuid, ENV.TRACKER_HOST);

      await bg.BackgroundGeolocation.setConfig(bg.Config(
          transistorAuthorizationToken: jwt
      ));
      return true;
    } catch (error) {
      print("[ERROR] $error");
      // TODO throw an Error instead.
      return false;
    }
  }

  static Future<void> registerErrorHandler() async {
    bg.State state = await bg.BackgroundGeolocation.state;
    if ((state.params != null) && (state.params['device'] != null)) {
      _migrateConfig();
    }
    bg.BackgroundGeolocation.removeListener(_onHttp);
    bg.BackgroundGeolocation.onHttp(_onHttp);
  }

  static void _migrateConfig() async {
    print("[TransistorAuth] migrateConfig");
    await bg.TransistorAuthorizationToken.destroy(ENV.TRACKER_HOST);
    bg.BackgroundGeolocation.reset(bg.Config(
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        url: "${ENV.TRACKER_HOST}/api/locations",
        params: {}
    ));
  }
}