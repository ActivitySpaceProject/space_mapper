import 'package:flutter/material.dart';

import '../models/project.dart';
import '../styles.dart';

const ProjectTileHeight = 100.0;

class ProjectTile extends StatelessWidget {
  final Project project;
  final bool darkTheme;

  ProjectTile({required this.project, required this.darkTheme});

  @override
  Widget build(BuildContext context) {
    final title = project.name.toUpperCase();
    final summary = project.summary;

    return Container(
      padding: EdgeInsets.all(0),
      height: ProjectTileHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: this.darkTheme
                  ? Styles.projectTileTitleDark
                  : Styles.projectTileTitleLight),
          Text('$summary',
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Styles.projectTileCaption),
        ],
      ),
    );
  }
}
