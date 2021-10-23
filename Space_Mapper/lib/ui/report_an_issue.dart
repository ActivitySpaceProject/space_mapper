import 'package:asm/ui_style/report_an_issue_style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ReportAnIssue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report an Issue/Feature Request")),
      body: reportIssueBody(context),
    );
  }
}

Widget reportIssueBody(BuildContext context) {
  return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            "Help us improve by either reporting an issue or requesting a useful feature.",
            style: TextStyle(fontSize: 17.0),
          ),
          DisplayService(
              "Github",
              Icon(
                AntDesign.github,
                size: ReportAnIssueStyle.iconSize,
              )),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Report issues on github to get the fastest solution.",
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          CustomButtonWithUrl(
              "Go to Github Issues",
              "https://github.com/ActivitySpaceProject/space_mapper/issues",
              MaterialStateProperty.all(Colors.lightBlue[100]),
              context),
          Container(
            //Container only to add more margin
            margin: EdgeInsets.only(bottom: 10.0),
          ),
          DisplayService(
              "Email",
              Icon(
                Icons.email_outlined,
                size: ReportAnIssueStyle.iconSize,
              )),
          Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "As an alternative, you can send us an email.",
                style: TextStyle(fontSize: 17.0),
              )),
          CustomButtonWithUrl(
              "Report an issue by email",
              "https://github.com/ActivitySpaceProject/space_mapper/issues",
              MaterialStateProperty.all(Colors.red[100]),
              context),
          CustomButtonWithUrl(
              "Request a feature by email",
              "https://github.com/ActivitySpaceProject/space_mapper/issues",
              MaterialStateProperty.all(Colors.lightBlue[100]),
              context),
        ],
      ));
}

_launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget DisplayService(String name, Icon icon) {
  return Container(
    margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
    child: Row(
      children: [
        icon,
        Container(
          margin: EdgeInsets.only(right: 25.0),
        ),
        Text(
          name,
          style: TextStyle(fontSize: 25.0),
        ),
      ],
    ),
  );
}

Widget CustomButtonWithUrl(String text, String openUrl,
    MaterialStateProperty<Color?> backgroundColor, BuildContext context) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: backgroundColor,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black)))),
        onPressed: () {
          _launchUrl(openUrl);
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
      ));
}
