import 'package:flutter/material.dart';

import '../models/project.dart';
import '../styles.dart';

const SurveyTileHeight = 100.0;

class SurveyTile extends StatelessWidget {
  final Project survey;
  final bool darkTheme;

  SurveyTile({required this.survey, required this.darkTheme});

  @override
  Widget build(BuildContext context) {
    final title = survey.name.toUpperCase();
    final summary = survey.summary;

    return Container(
      padding: EdgeInsets.all(0),
      height: SurveyTileHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: this.darkTheme
                  ? Styles.surveyTileTitleDark
                  : Styles.surveyTileTitleLight),
          Text('$summary',
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Styles.surveyTileCaption),
        ],
      ),
    );
  }
}
