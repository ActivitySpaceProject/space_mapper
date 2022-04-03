import 'package:asm/components/survey_tile.dart';
import 'package:asm/mocks/mock_survey.dart';
import 'package:asm/models/project.dart';
import 'package:asm/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('survey_tile', (WidgetTester tester) async {
    Project survey = MockSurvey.fetchFirst();
    bool darkTheme = true;

    await tester.pumpWidget(
        MaterialApp(home: SurveyTile(survey: survey, darkTheme: darkTheme)));

    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);

    // Displays survey text
    expect(find.byType(Text), findsWidgets);
    expect(find.text(survey.name.toUpperCase()), findsOneWidget);
    expect(find.text(survey.summary), findsOneWidget);

    //expect(find.text(survey.webUrl), findsNothing);
    expect(find.text(survey.imageUrl), findsNothing);
  });

  testWidgets('survey_tile with dark style', (WidgetTester tester) async {
    Project survey = MockSurvey.fetchFirst();
    bool darkTheme = true;

    await tester.pumpWidget(
        MaterialApp(home: SurveyTile(survey: survey, darkTheme: darkTheme)));

    // Survey text is displayed in correct style
    expect(
        (tester.firstWidget(find.byType(Text)) as Text).style ==
            Styles.surveyTileTitleDark,
        isTrue);

    expect(
        (tester.firstWidget(find.byType(Text)) as Text).style ==
            Styles.surveyTileTitleLight,
        isFalse);
  });

  testWidgets('survey_tile with light style', (WidgetTester tester) async {
    Project survey = MockSurvey.fetchFirst();
    bool darkTheme = false;

    await tester.pumpWidget(
        MaterialApp(home: SurveyTile(survey: survey, darkTheme: darkTheme)));

    // Survey text is displayed in correct style
    expect(
        (tester.firstWidget(find.byType(Text)) as Text).style ==
            Styles.surveyTileTitleDark,
        isFalse);

    expect(
        (tester.firstWidget(find.byType(Text)) as Text).style ==
            Styles.surveyTileTitleLight,
        isTrue);
  });
}
