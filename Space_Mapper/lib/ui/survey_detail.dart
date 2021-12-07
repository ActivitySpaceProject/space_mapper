import 'dart:convert';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter/material.dart';

import '../app_localizations.dart';
import '../components/banner_image.dart';
import '../components/survey_tile.dart';
import '../mocks/mock_survey.dart';
import '../models/survey.dart';
import '../models/custom_locations.dart';
import '../ui/web_view.dart';
import '../styles.dart';

const BannerImageHeight = 300.0;
const BodyVerticalPadding = 20.0;
const FooterHeight = 100.0;

class SurveyDetail extends StatefulWidget {
  final int surveyID;

  SurveyDetail(this.surveyID);

  @override
  _SurveyDetailState createState() => _SurveyDetailState(surveyID);
}

class _SurveyDetailState extends State<SurveyDetail> {
  final int surveyID;
  Survey survey = Survey.blank();
  bool consent = false;
  String dropdownValue = 'Last week';

  _SurveyDetailState(this.surveyID);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              AppLocalizations.of(context)!.translate("about_the_project"))),
      body: Stack(
        children: [
          _renderBody(context, survey),
          _renderFooter(context),
        ],
      ),
    );
  }

  loadData() {
    final survey = MockSurvey.fetchByID(this.surveyID);

    if (mounted) {
      setState(() {
        this.survey = survey;
      });
    }
  }

  Widget _renderBody(BuildContext context, Survey survey) {
    var result = <Widget>[];
    result.add(BannerImage(url: survey.imageUrl, height: BannerImageHeight));
    result.add(_renderHeader());
    result.add(_renderConsentForm());
    result.add(_renderFrequencyChooser());
    result.add(_renderBottomSpacer());
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: result));
  }

  Widget _renderHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: BodyVerticalPadding,
          horizontal: Styles.horizontalPaddingDefault),
      child: SurveyTile(survey: survey, darkTheme: false),
    );
  }

  Widget _renderFooter(BuildContext contexty) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
          height: FooterHeight,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: _renderTakeSurveyButton(),
          ),
        )
      ],
    );
  }

  Widget _renderConsentForm() {
    String title = AppLocalizations.of(context)!.translate("consent_form");
    String text = AppLocalizations.of(context)!
            .translate("do_you_agree_to_share_your_anonymous_location_with") +
        "${survey.name}?";

    return Container(
      height: SurveyTileHeight,
      padding: EdgeInsets.symmetric(
          //vertical: BodyVerticalPadding,
          horizontal: Styles.horizontalPaddingDefault),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Styles.surveyTileTitleLight),
          Row(
            children: [
              Checkbox(
                value: consent,
                onChanged: (bool? newValue) {
                  setState(() {
                    consent = newValue!;
                  });
                },
              ),
              Expanded(
                child: Text('$text',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: Styles.surveyTileCaption),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderFrequencyChooser() {
    String title = "Choose frequency";

    return Container(
      height: SurveyTileHeight,
      padding: EdgeInsets.symmetric(
          //vertical: BodyVerticalPadding,
          horizontal: Styles.horizontalPaddingDefault),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Styles.surveyTileTitleLight),
          DropdownButton(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['Last week', 'Last month', 'All-time']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _renderTakeSurveyButton() {
    return TextButton(
      //color: Styles.accentColor,
      //textColor: Styles.textColorBright,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      onPressed: () => {
        _navigationToSurvey(context),
      },
      child: Text(
        'Take Survey'.toUpperCase(),
        style: Styles.textCTAButton,
      ),
    );
  }

  Future<void> _navigationToSurvey(BuildContext context) async {
    String locationHistoryJSON = "";

    // If we have consent, send location history. Otherwise, send empty string
    if (consent) {
      List allLocations = await bg.BackgroundGeolocation.locations;
      List<ShareLocation> customLocation = [];

      // We get only timestamp and coordinates into our custom class
      for (var thisLocation in allLocations) {
        ShareLocation _loc = new ShareLocation(
            bg.Location(thisLocation).timestamp,
            bg.Location(thisLocation).coords.latitude,
            bg.Location(thisLocation).coords.longitude);
        customLocation.add(_loc);
      }

      locationHistoryJSON = jsonEncode(customLocation);
      locationHistoryJSON = locationHistoryJSON.replaceAll("\"",
          "'"); //We replace " into ' to avoid a javascript exception when we post it in the webview's form
    } else {
      locationHistoryJSON = "I do not agree to share my location history.";
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyWebView(survey.webUrl, locationHistoryJSON)));
  }

  Widget _renderBottomSpacer() {
    return Container(height: FooterHeight);
  }
}
