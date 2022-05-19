import 'package:asm/components/project_tile.dart';
import 'package:asm/mocks/mock_project.dart';
import 'package:asm/models/project.dart';
import 'package:asm/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('project_tile', (WidgetTester tester) async {
    Project project = MockProject.fetchFirst();
    bool darkTheme = true;

    await tester.pumpWidget(
        MaterialApp(home: ProjectTile(project: project, darkTheme: darkTheme)));

    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);

    // Displays project text
    expect(find.byType(Text), findsWidgets);
    expect(find.text(project.name.toUpperCase()), findsOneWidget);
    expect(find.text(project.summary), findsOneWidget);

    //expect(find.text(project.webUrl), findsNothing);
    expect(find.text(project.imageUrl), findsNothing);
  });

  testWidgets('project_tile with dark style', (WidgetTester tester) async {
    Project project = MockProject.fetchFirst();
    bool darkTheme = true;

    await tester.pumpWidget(
        MaterialApp(home: ProjectTile(project: project, darkTheme: darkTheme)));

    // Project text is displayed in correct style
    expect(
        (tester.firstWidget(find.byType(Text)) as Text).style ==
            Styles.projectTileTitleDark,
        isTrue);

    expect(
        (tester.firstWidget(find.byType(Text)) as Text).style ==
            Styles.projectTileTitleLight,
        isFalse);
  });

  testWidgets('project_tile with light style', (WidgetTester tester) async {
    Project project = MockProject.fetchFirst();
    bool darkTheme = false;

    await tester.pumpWidget(
        MaterialApp(home: ProjectTile(project: project, darkTheme: darkTheme)));

    // Project text is displayed in correct style
    expect(
        (tester.firstWidget(find.byType(Text)) as Text).style ==
            Styles.projectTileTitleDark,
        isFalse);

    expect(
        (tester.firstWidget(find.byType(Text)) as Text).style ==
            Styles.projectTileTitleLight,
        isTrue);
  });
}
