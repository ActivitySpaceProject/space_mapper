import 'package:flutter/material.dart';

import '../app_localizations.dart';
import '../models/surveys.dart';

class AvailableSurveysScreen extends StatefulWidget {
  @override
  _AvailableSurveysScreenState createState() => _AvailableSurveysScreenState();
}

class _AvailableSurveysScreenState extends State<AvailableSurveysScreen> {
  List<Survey> surveys = [];
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
            title:
                Text(AppLocalizations.of(context)!.translate("take_survey"))),
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
      final surveys = await Survey.fetchAll();
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
    final location = this.surveys[index];
    return GestureDetector(
      onTap: () => _navigationToLocationDetail(context, location.id),
      child: Container(
        //height: ListItemHeight,
        height: 100.0,
        child: Stack(
          children: [
            //BannerImage(url: location.url, height: 300.0),
            //_tileFooter(location),
          ],
        ),
      ),
    );
  }

  void _navigationToLocationDetail(BuildContext context, int locationID) {
    //Navigator.push(context,
    //    MaterialPageRoute(builder: (context) => LocationDetail(locationID)));
  }
}
