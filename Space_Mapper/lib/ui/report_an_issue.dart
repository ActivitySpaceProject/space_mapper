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
  List<String> emails = ['john.palmer@upf.edu', 'pablogalve100@gmail.com'];

  return Padding(
      padding: EdgeInsets.all(ReportAnIssueStyle.screenPadding),
      child: Column(
        children: [
          Text(
            "Help us improve by either reporting an issue or requesting a useful feature.",
            style: TextStyle(fontSize: ReportAnIssueStyle.normalTextSize),
          ),
          displayService(
              "Github",
              Icon(
                AntDesign.github,
                size: ReportAnIssueStyle.iconSize,
              )),
          Container(
            margin: EdgeInsets.only(
                bottom: ReportAnIssueStyle.marginBetweenTextAndButtons),
            child: Text(
              "Report issues on github to get the fastest solution.",
              style: TextStyle(fontSize: ReportAnIssueStyle.normalTextSize),
            ),
          ),
          customButtonWithUrl(
              "Go to Github Issues",
              "https://github.com/ActivitySpaceProject/space_mapper/issues",
              ReportAnIssueStyle.requestFeatureColor,
              context),
          Container(
            //Container only to add more margin
            margin: EdgeInsets.only(
                bottom: ReportAnIssueStyle.marginBetweenTextAndButtons),
          ),
          displayService(
              "Email",
              Icon(
                Icons.email_outlined,
                size: ReportAnIssueStyle.iconSize,
              )),
          Container(
              margin: EdgeInsets.only(
                  bottom: ReportAnIssueStyle.marginBetweenTextAndButtons),
              child: Text(
                "As an alternative, you can send us an email.",
                style: TextStyle(fontSize: ReportAnIssueStyle.normalTextSize),
              )),
          customButtonWithUrl("Report an issue by email", null,
              ReportAnIssueStyle.reportIssueColor, context,
              emails: emails,
              subject: 'Space Mapper: Report Issue',
              body:
                  'Dear Space Mapper support, \n\n I want to report the following issue:'),
          customButtonWithUrl("Request a feature by email", null,
              ReportAnIssueStyle.requestFeatureColor, context,
              emails: emails,
              subject: 'Space Mapper: Feature Request',
              body:
                  'Dear Space Mapper support, \n\n I want to request the following feature:'),
        ],
      ));
}

_launchUrl(String url) async {
  //The url must be valid

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<bool> launchMailto(
    List<String> emails, String? subject, String? body) async {
  //All emails must be valid
  for (int i = 0; i < emails.length; i++) {
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emails[i]) ==
        false) {
      return false;
    }
  }

  final mailtoLink = Mailto(
    to: emails,
    subject: subject,
    body: body,
  );
  // Convert the Mailto instance into a string.
  // Use either Dart's string interpolation
  // or the toString() method.
  await launch('$mailtoLink');
  return true;
}

Widget displayService(String name, Icon icon) {
  return Container(
    margin: EdgeInsets.fromLTRB(0.0, ReportAnIssueStyle.marginIconTopAndBottom,
        0.0, ReportAnIssueStyle.marginIconTopAndBottom),
    child: Row(
      children: [
        icon,
        Container(
          margin: EdgeInsets.only(
              right: ReportAnIssueStyle.marginBetweenIconAndTitle),
        ),
        Text(
          name,
          style: TextStyle(fontSize: ReportAnIssueStyle.titleSize),
        ),
      ],
    ),
  );
}

Widget customButtonWithUrl(String text, String? openUrl,
    MaterialStateProperty<Color?> backgroundColor, BuildContext context,
    {List<String>? emails, String? subject, String? body}) {
  return Container(
      width: MediaQuery.of(context).size.width *
          ReportAnIssueStyle.buttonWidthPercentage,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: backgroundColor,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        ReportAnIssueStyle.buttonBorderRadius),
                    side: BorderSide(color: Colors.black)))),
        onPressed: () {
          //If emails list is null, this buttons opens a link on click, otherwise it sends an email with introduced data
          emails == null
              ? _launchUrl(openUrl!)
              : launchMailto(emails, subject!, body!);
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
      ));
}
