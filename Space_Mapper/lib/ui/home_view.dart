import 'package:asm/ui/side_drawer.dart';
import 'package:asm/util/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:background_fetch/background_fetch.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'map_view.dart';

import '../util/dialog.dart' as util;
import '../external_projects/tiger_in_car/models/participating_projects.dart';
import '../db/database_project.dart';


// For pretty-printing location JSON
JsonEncoder encoder = new JsonEncoder.withIndent("     ");

/// The main home-screen of the AdvancedApp.  Builds the Scaffold of the App.
///
class HomeView extends StatefulWidget {
  HomeView(this.appName);
  final String appName;

  @override
  State createState() => HomeViewState(appName);
}

class HomeViewState extends State<HomeView>
    with TickerProviderStateMixin<HomeView>, WidgetsBindingObserver {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //late TabController _tabController;

  late String appName;
  //late bool _isMoving;
  late bool _enabled;
  //late String _motionActivity;
  //late String _odometer;

  HomeViewState(this.appName);

  List<Particpating_Project> projects = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    //_isMoving = false;
    _enabled = true;
    //_motionActivity = 'UNKNOWN';
    //_odometer = '0';

    initPlatformState();
    fetchProjects();
  }

  // Fetch the projects from the database
  void fetchProjects() async {
    try {
      List<Particpating_Project> fetchedProjects = await await ProjectDatabase.instance.readAllProjects();
      setState(() {
        projects = fetchedProjects;
      });
    } catch (e) {
      // Handle errors, if any
      print('Error fetching projects: $e');
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("[home_view didChangeAppLifecycleState] : $state");
    //TODO: The interior of these 'if statements' is empty
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {}
  }

  void initPlatformState() async {
    SharedPreferences prefs = await _prefs;
    String? sampleId = prefs.getString("sample_id");
    String? userUUID = prefs.getString("user_uuid");

    if (sampleId == null || userUUID == null) {
      prefs.setString("user_uuid", Uuid().v4());
      prefs.setString("sample_id", ENV.DEFAULT_SAMPLE_ID);
    }

    _configureBackgroundGeolocation(userUUID, sampleId);
    _configureBackgroundFetch();
  }

  // ignore: non_constant_identifier_names
  void _configureBackgroundGeolocation(user_uuid, sample_id) async {
    // 1.  Listen to events (See docs for all 13 available events).
    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
//    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    bg.BackgroundGeolocation.onHttp(_onHttp);
    bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);
    bg.BackgroundGeolocation.onHeartbeat(_onHeartbeat);
    bg.BackgroundGeolocation.onGeofence(_onGeofence);
    bg.BackgroundGeolocation.onSchedule(_onSchedule);
    bg.BackgroundGeolocation.onPowerSaveChange(_onPowerSaveChange);
    bg.BackgroundGeolocation.onEnabledChange(_onEnabledChange);
    bg.BackgroundGeolocation.onNotificationAction(_onNotificationAction);

    // 2.  Configure the plugin
    bg.BackgroundGeolocation.ready(bg.Config(
            // Convenience option to automatically configure the SDK to post to Transistor Demo server.
            // Logging & Debug
            reset: false,
            debug: false,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE,
            // Geolocation options
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
            distanceFilter: 10.0,
            stopTimeout: 1,
            // HTTP & Persistence
            autoSync: false,
            persistMode: bg.Config.PERSIST_MODE_ALL,
            maxDaysToPersist: 30,
            maxRecordsToPersist: -1,
            // Application options
            stopOnTerminate: false,
            startOnBoot: true,
            enableHeadless: true,
            heartbeatInterval: 60))
        .then((bg.State state) {
      print('[ready] ${state.toMap()}');

      if (state.schedule!.isNotEmpty) {
        bg.BackgroundGeolocation.startSchedule();
      }
      setState(() {
        _enabled = state.enabled;
        //_isMoving = state.isMoving!;
      });
    }).catchError((error) {
      print('[ready] ERROR: $error');
    });
  }

  // Configure BackgroundFetch (not required by BackgroundGeolocation).
  void _configureBackgroundFetch() async {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            startOnBoot: true,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresStorageNotLow: false,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      print("[BackgroundFetch] received event $taskId");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int count = 0;
      if (prefs.get("fetch-count") != null) {
        count = prefs.getInt("fetch-count")!;
      }
      prefs.setInt("fetch-count", ++count);
      print('[BackgroundFetch] count: $count');

      // Test scheduling a custom-task in fetch event.

      if (taskId == 'flutter_background_fetch') {
        BackgroundFetch.scheduleTask(TaskConfig(
            taskId: "com.transistorsoft.customtask",
            delay: 5000,
            periodic: false,
            forceAlarmManager: true,
            stopOnTerminate: false,
            enableHeadless: true));
      }
      BackgroundFetch.finish(taskId);
    });

    // Test scheduling a custom-task.
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "com.transistorsoft.customtask",
        delay: 10000,
        periodic: false,
        forceAlarmManager: true,
        stopOnTerminate: false,
        enableHeadless: true));
  }

  void _onClickEnable(enabled) async {
    if (enabled) {
      dynamic callback = (bg.State state) {
        print('[start] success: $state');
        setState(() {
          _enabled = state.enabled;
          //_isMoving = state.isMoving!;
        });
      };
      bg.State state = await bg.BackgroundGeolocation.state;
      if (state.trackingMode == 1) {
        bg.BackgroundGeolocation.start().then(callback);
      } else {
        bg.BackgroundGeolocation.startGeofences().then(callback);
      }
    } else {
      dynamic callback = (bg.State state) {
        print('[stop] success: $state');
        setState(() {
          _enabled = state.enabled;
          //_isMoving = state.isMoving!;
        });
      };
      bg.BackgroundGeolocation.stop().then(callback);
    }
  }

  // Manually toggle the tracking state:  moving vs stationary
  /*void _onClickChangePace() {
    setState(() {
      _isMoving = !_isMoving;
    });
    print("[onClickChangePace] -> $_isMoving");

    bg.BackgroundGeolocation.changePace(_isMoving).then((bool isMoving) {
      print('[changePace] success $isMoving');
    }).catchError((e) {
      print('[changePace] ERROR: ' + e.code.toString());
    });

    if (!_isMoving) {}
  }*/

  // Manually fetch the current position.
  void _onClickGetCurrentPosition() async {
    bg.BackgroundGeolocation.getCurrentPosition(
        persist: true,
        // <-- do not persist this location
        desiredAccuracy: 40,
        // <-- desire an accuracy of 40 meters or less
        maximumAge: 10000,
        // <-- Up to 10s old is fine.
        timeout: 30,
        // <-- wait 30s before giving up.
        samples: 3,
        // <-- sample just 1 location
        extras: {"getCurrentPosition": true}).then((bg.Location location) {
      print('[getCurrentPosition] - $location');
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: $error');
    });
  }

  ////
  // Event handlers
  //

  void _onLocation(bg.Location location) {
    print('[${bg.Event.LOCATION}] - $location');

//    SendDataToAPI sender = SendDataToAPI();
 //   sender.submitData(location, "location");
    
    setState(() {
      //_odometer = (location.odometer / 1000.0).toStringAsFixed(1);
    });
  }

  void _onLocationError(bg.LocationError error) {
    print('[${bg.Event.LOCATION}] ERROR - $error');
    setState(() {});
  }

  void _onMotionChange(bg.Location location) {
    print('[${bg.Event.MOTIONCHANGE}] - $location');
    setState(() {
      //_isMoving = location.isMoving;
    });
  }

//  void _onActivityChange(bg.ActivityChangeEvent event) {
//    print('[${bg.Event.ACTIVITYCHANGE}] - $event');
//    setState(() {
      //_motionActivity = event.activity;
//    });
//  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    print('[${bg.Event.PROVIDERCHANGE}] - $event');
    setState(() {});
  }

  void _onHttp(bg.HttpEvent event) async {
    print('[${bg.Event.HTTP}] - $event');

    setState(() {});
  }

  void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
    print('[${bg.Event.CONNECTIVITYCHANGE}] - $event');
    setState(() {});
  }

  void _onHeartbeat(bg.HeartbeatEvent event) {
    print('[${bg.Event.HEARTBEAT}] - $event');
    setState(() {});
  }

  void _onGeofence(bg.GeofenceEvent event) async {
    print('[${bg.Event.GEOFENCE}] - $event');

    bg.BackgroundGeolocation.startBackgroundTask().then((int taskId) async {
      // Execute an HTTP request to test an async operation completes.
      String url = "${ENV.TRACKER_HOST}/api/devices";
      bg.State state = await bg.BackgroundGeolocation.state;
      http.read(Uri.parse(url), headers: {
        "Authorization": "Bearer ${state.authorization!.accessToken}"
      }).then((String result) {
        print("[http test] success: $result");
        bg.BackgroundGeolocation.playSound(
            util.Dialog.getSoundId("TEST_MODE_CLICK"));
        bg.BackgroundGeolocation.stopBackgroundTask(taskId);
      }).catchError((dynamic error) {
        print("[http test] failed: $error");
        bg.BackgroundGeolocation.stopBackgroundTask(taskId);
      });
    });
  }

  void _onSchedule(bg.State state) {
    print('[${bg.Event.SCHEDULE}] - $state');
    setState(() {});
  }

  void _onEnabledChange(bool enabled) {
    print('[${bg.Event.ENABLEDCHANGE}] - $enabled');
    setState(() {
      _enabled = enabled;
    });
  }

  void _onNotificationAction(String action) {
    print('[onNotificationAction] $action');
    switch (action) {
      case 'notificationButtonFoo':
        bg.BackgroundGeolocation.changePace(false);
        break;
      case 'notificationButtonBar':
        break;
    }
  }

  void _onPowerSaveChange(bool enabled) {
    print('[${bg.Event.POWERSAVECHANGE}] - $enabled');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.gps_fixed),
            color: Colors.yellow,
            onPressed: _onClickGetCurrentPosition,
          ),
          Switch(
            value: _enabled,
            onChanged: _onClickEnable,
            activeColor: Colors.yellow,
          ),
        ],
      ),
      //body: body,
      drawer: new SpaceMapperSideDrawer(),
      body: MapView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.of(context).pushNamed('/record_contact');
          //Navigator.of(context).pushNamed('/active_projects');
          Navigator.of(context).pushNamed('/participate_in_a_project');
          _onClickGetCurrentPosition();
        },
        //child: Icon(Icons.person),
        child: Icon(Icons.all_inclusive),
        backgroundColor: Colors.blue,
      ),);
      /*floatingActionButton: Row(
        children: projects.map((project) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                // Handle button click for the project here.
                // You can use the project information to customize the behavior.
                // For example, project.projectName contains the project name.
                // Navigate or perform actions related to the selected project.
              },
              child: Text(project.projectName), // Set the project name as the button label.
              backgroundColor: Colors.blue,
            ),
          );
        }).toList(),
      ),
    );
  */


    
  }

  @override
  void dispose() {
    super.dispose();
  }
}
