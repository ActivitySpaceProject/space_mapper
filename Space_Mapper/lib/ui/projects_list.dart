import 'package:flutter/material.dart';

import '../models/app_localizations.dart';
import '../components/banner_image.dart';
import '../components/project_tile.dart';
import '../mocks/mock_project.dart';
import '../models/project.dart';
import '../styles.dart';

const ListItemHeight = 245.0;

class AvailableProjectsScreen extends StatefulWidget {
  @override
  AvailableProjectsScreenState createState() => AvailableProjectsScreenState();
}

class AvailableProjectsScreenState extends State<AvailableProjectsScreen> {
  List<Project> projects = [];
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
      final projects = await MockProject.fetchAll();
      setState(() {
        this.projects = projects;
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
        itemCount: this.projects.length, itemBuilder: _listViewItemBuilder);
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final project = this.projects[index];
    return GestureDetector(
      onTap: () => _navigationToProjectDetail(context, project.id),
      child: Container(
        height: ListItemHeight,
        child: Stack(
          children: [
            BannerImage(url: project.imageUrl, height: 300.0),
            _tileFooter(project),
          ],
        ),
      ),
    );
  }

  void _navigationToProjectDetail(BuildContext context, int projectID) {
    Navigator.of(context).pushNamed('/project_detail', arguments: projectID);
  }

  Widget _tileFooter(Project project) {
    final overlay = Container(
      padding: EdgeInsets.symmetric(
          vertical: 5.0, horizontal: Styles.horizontalPaddingDefault),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: ProjectTile(project: project, darkTheme: true),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [overlay],
    );
  }
}
