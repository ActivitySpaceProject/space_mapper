import 'package:asm/ui_style/report_an_issue_style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ReportAnIssue extends StatelessWidget {
  _launchGithubIssues() async {
    const url = 'https://github.com/ActivitySpaceProject/space_mapper/issues';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report an Issue")),
      body: reportIssueBody(),
    );
  }
}

Widget reportIssueBody() {
  return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text(
              "Help us improve by either reporting an issue or requesting a useful feature.",
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          DisplayService(
              "Github",
              Icon(
                AntDesign.github,
                size: ReportAnIssueStyle.iconSize,
              )),
          Container(
            //padding: EdgeInsets.all(10.0),
            child: Text("Report issues on github to get the fastest solution."),
          ),
          Text("Here goes a button"),
          DisplayService(
              "Email",
              Icon(
                Icons.email_outlined,
                size: ReportAnIssueStyle.iconSize,
              )),
          Container(
            //padding: EdgeInsets.all(10.0),
            child: Text("As an alternative, you can send us an email."),
          ),
          Text("Here goes a button"),
          Text("Here goes a button")
        ],
      ));
}

//Display
Widget DisplayService(String name, Icon icon) {
  return Container(
    margin: EdgeInsets.only(bottom: 20.0),
    child: Row(
      children: [
        icon,
        Container(
          margin: EdgeInsets.only(right: 25.0),
        ),
        Text(
          "Github",
          style: TextStyle(fontSize: 25.0),
        ),
      ],
    ),
  );
}
