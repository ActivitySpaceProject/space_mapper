import 'package:asm/ui/web_view.dart';
import 'package:flutter/material.dart';

import '../app_localizations.dart';
import '../components/banner_image.dart';
import '../components/survey_tile.dart';
import '../mocks/mock_survey.dart';
import '../models/survey.dart';
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
          //_renderConsentForm(),
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
    String title = "Consent Form";
    String text =
        "Do you agree to share your anonymous locations to ${survey.name}?";

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

  void _navigationToSurvey(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyWebView(survey.webUrl)));
  }

  Widget _renderBottomSpacer() {
    return Container(height: FooterHeight);
  }
}