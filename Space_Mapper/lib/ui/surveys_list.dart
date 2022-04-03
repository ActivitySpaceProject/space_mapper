import 'package:flutter/material.dart';

import '../models/app_localizations.dart';
import '../components/banner_image.dart';
import '../components/survey_tile.dart';
import '../mocks/mock_survey.dart';
import '../models/project.dart';
import '../styles.dart';

const ListItemHeight = 245.0;

class AvailableSurveysScreen extends StatefulWidget {
  @override
  AvailableSurveysScreenState createState() => AvailableSurveysScreenState();
}

class AvailableSurveysScreenState extends State<AvailableSurveysScreen> {
  List<Project> surveys = [];
  bool loading = false;

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
                AppLocalizations.of(context)?.translate("participate_in_a_project") ?? "")),
        body: RefreshIndicator(
          onRefresh: loadData,
          child: Column(
            children: [
              renderProgressBar(context),
              Expanded(child: renderListView(context))
            ],
          ),
        ));
  }

  Future<void> loadData() async {
    if (this.mounted) {
      setState(() => this.loading = true);
      final surveys = await MockSurvey.fetchAll();
      setState(() {
        this.surveys = surveys;
        this.loading = false;
      });
    }
  }

  Widget renderProgressBar(BuildContext context) {
    return (this.loading
        ? LinearProgressIndicator(
            value: null,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))
        : Container());
  }

  Widget renderListView(BuildContext context) {
    return ListView.builder(
        itemCount: this.surveys.length, itemBuilder: _listViewItemBuilder);
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final survey = this.surveys[index];
    return GestureDetector(
      onTap: () => _navigationToSurveyDetail(context, survey.id),
      child: Container(
        height: ListItemHeight,
        child: Stack(
          children: [
            BannerImage(url: survey.imageUrl, height: 300.0),
            _tileFooter(survey),
          ],
        ),
      ),
    );
  }

  void _navigationToSurveyDetail(BuildContext context, int surveyID) {
    Navigator.of(context).pushNamed('/survey_detail', arguments: surveyID);
  }

  Widget _tileFooter(Project survey) {
    final overlay = Container(
      padding: EdgeInsets.symmetric(
          vertical: 5.0, horizontal: Styles.horizontalPaddingDefault),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: SurveyTile(survey: survey, darkTheme: true),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [overlay],
    );
  }
}
