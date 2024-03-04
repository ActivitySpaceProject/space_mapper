import 'package:asm/external_projects/tiger_in_car/models/tiger_in_car_state.dart';
import 'package:flutter/material.dart';

import '../external_projects/tiger_in_car/screens/finish_experiment.dart';
import '../external_projects/tiger_in_car/screens/main.dart';
import '../ui/form_view.dart';
import '../ui/home_view.dart';
import '../ui/list_view.dart';
import '../ui/report_issues.dart';
import '../ui/project_detail.dart';
import '../ui/projects_list.dart';
import '../ui/web_view.dart';


class GlobalRouteData {
  static String? user_route = "brown";
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    print('project rouite ping 1: $settings.name'); 
    GlobalRouteData.user_route = settings.name;
    //print(settings.name);
    print(GlobalRouteData.user_route); 
    print('project rouite ping 2: ($GlobalRouteData.user_route)'); 
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeView('Space Mapper'));
      case '/participate_in_a_project':
        return MaterialPageRoute(builder: (_) => AvailableProjectsScreen());
      case '/active_projects':
        //return MaterialPageRoute(builder: (_) => TigerInCar());
        return MaterialPageRoute(builder: (_) => AvailableProjectsScreen());
      case '/locations_history':
        return MaterialPageRoute(builder: (_) => STOListView());
      case '/report_an_issue':
        return MaterialPageRoute(builder: (_) => ReportAnIssue());
//      case '/my_statistics':
 //       return MaterialPageRoute(builder: (_) => MyStatistics());
      case '/navigation_to_webview':
        if (args is Map<String, String>) {
          return MaterialPageRoute(
              builder: (_) => MyWebView(args['selectedUrl'] ?? '',
                  args['locationHistoryJSON'] ?? '', args['locationSharingMethod'] ?? ''));
        }
        return _errorRoute();
      case '/record_contact':
        return MaterialPageRoute(builder: (_) => FormView());
      case '/project_detail':
        if (args is int) {
          return MaterialPageRoute(builder: (_) => ProjectDetail(args));
        }
        return _errorRoute();
      case '/project_tiger_in_car':
        return MaterialPageRoute(builder: (_) => TigerInCar());
      case '/tiger_in_car_finish_experiment':
        if(args is TigerInCarState){
          return MaterialPageRoute(builder: (_) => FinishExperiment(args));
        }
        return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Error 404'),
          ),
          body: Center(
            child: Text("ERROR 404: named route doesn't exist"),
          ));
    });
  }
}
