/* EXPECTED BEHAVIOR
If it's an embedded web, use webUrl and set projectScreen = null
If it's a project that uses another screen within the app, set projectScreen as the screen and webUrl = null
*/
import 'package:flutter/material.dart';

class Project {
  final int id;
  final String name;
  final String summary;
  final String? webUrl;
  final String? projectScreen;
  final String imageUrl;

  Project(this.id, this.name, this.summary, this.webUrl, this.projectScreen,
      this.imageUrl);

  Project.blank()
      : id = 0,
        name = ' ',
        webUrl = null,
        projectScreen = null,
        imageUrl =
            '', // Leave this without space ('' instead of ' ') to avoid an exception
        summary = ' ';

  void participate(BuildContext context, String locationHistoryJSON) {
    if (projectScreen != null) {
      // Navigate to the project screen within the app
      Navigator.of(context)
          .pushNamed(projectScreen.toString());
    } else if (webUrl != null) {
      // Open a web view with the project url

      // Store the values in a map to pass them as arguments in the new screen
      Map<String, String> arguments = Map();
      arguments['selectedUrl'] = webUrl ?? '';
      arguments['locationHistoryJSON'] = locationHistoryJSON;

      Navigator.of(context)
          .pushNamed('/navigation_to_webview', arguments: arguments);
    } else {
      throw Exception('Both projectScreen and webUrl were null');
    }
  }

  static Future<List<Project>> fetchAll() async {
    // TODO: In a future version we'll fetch data from a web app
    List<Project> list = [];
    return list;
  }
}
