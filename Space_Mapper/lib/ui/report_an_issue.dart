import 'package:asm/ui_style/report_an_issue_style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mailto/mailto.dart';

class ReportAnIssue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report an Issue")),
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
          displayService(
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
          customButtonWithUrl(
              "Go to Github Issues",
              "https://github.com/ActivitySpaceProject/space_mapper/issues",
              MaterialStateProperty.all(Colors.lightBlue[100]),
              context),
          Container(
            //Container only to add more margin
            margin: EdgeInsets.only(bottom: 10.0),
          ),
          displayService(
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
          customButtonWithUrl(
              "Report an issue by email",
              "https://github.com/ActivitySpaceProject/space_mapper/issues",
              MaterialStateProperty.all(Colors.red[100]),
              context,
              emails: ['john.palmer@upf.edu', 'pablogalve100@gmail.com'],
              subject: 'Space Mapper: Report Issue',
              body:
                  'Dear Space Mapper support, \n\n I want to report the following issue:'),
          customButtonWithUrl(
              "Request a feature by email",
              "https://github.com/ActivitySpaceProject/space_mapper/issues",
              MaterialStateProperty.all(Colors.lightBlue[100]),
              context,
              emails: ['john.palmer@upf.edu', 'pablogalve100@gmail.com'],
              subject: 'Space Mapper: Feature Request',
              body:
                  'Dear Space Mapper support, \n\n I want to request the following feature:'),
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

_launchMailto(List<String> emails, String? subject, String? body) async {
  final mailtoLink = Mailto(
    to: emails,
    subject: subject,
    body: body,
  );
  // Convert the Mailto instance into a string.
  // Use either Dart's string interpolation
  // or the toString() method.
  await launch('$mailtoLink');
}

Widget displayService(String name, Icon icon) {
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

Widget customButtonWithUrl(String text, String openUrl,
    MaterialStateProperty<Color?> backgroundColor, BuildContext context,
    {List<String>? emails, String? subject, String? body}) {
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
          //If emails list is null, this buttons opens a link on click, otherwise it sends an email with introduced data
          emails == null
              ? _launchUrl(openUrl)
              : _launchMailto(emails, subject!, body!);
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
      ));
}
