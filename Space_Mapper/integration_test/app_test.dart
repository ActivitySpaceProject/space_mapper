import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/main.dart' as app;

// TODO: Fix this function to avoid code repetition in the tests below.
// Uncommenting this will make the integration tests fail
// Finds and presses go back button
/*void goBack(WidgetTester tester) async {
  final Finder arrowBackBtn = find.byIcon(Icons.arrow_back);
  await tester.tap(arrowBackBtn);
  await tester.pumpAndSettle();
}*/

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Integration test. Navigate through all screens',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add contacts screen
      final Finder addContactBtn = find.byIcon(Icons.person);
      await tester.tap(addContactBtn);
      await tester.pumpAndSettle();
      // Finds and presses go back button
      Finder arrowBackBtn = find.byIcon(Icons.arrow_back);
      await tester.tap(arrowBackBtn);
      await tester.pumpAndSettle();

      // Open the menu and start going trough all screens
      final Finder menuBtn = find.byIcon(Icons.menu);
      await tester.tap(menuBtn);
      await tester.pumpAndSettle();

      // ListView Element => Participate in a project
      final Finder projectBtn = find.byIcon(Icons.edit);
      await tester.tap(projectBtn);
      await tester.pumpAndSettle();
      // Finds and presses go back button
      arrowBackBtn = find.byIcon(Icons.arrow_back);
      await tester.tap(arrowBackBtn);
      await tester.pumpAndSettle();

      // ListView Element => Location History
      final Finder locationHistoryBtn = find.byIcon(Icons.list);
      await tester.tap(locationHistoryBtn);
      await tester.pumpAndSettle();
      // Finds and presses go back button
      arrowBackBtn = find.byIcon(Icons.arrow_back);
      await tester.tap(arrowBackBtn);
      await tester.pumpAndSettle();

      // ListView Element => Report an Issue
      final Finder reportIssueBtn = find.byIcon(Icons.report_problem_outlined);
      await tester.tap(reportIssueBtn);
      await tester.pumpAndSettle();
      // Finds and presses go back button
      arrowBackBtn = find.byIcon(Icons.arrow_back);
      await tester.tap(arrowBackBtn);
      await tester.pumpAndSettle();

      // ListView Element => Statistics
      final Finder statisticsBtn = find.byIcon(Icons.bar_chart);
      await tester.tap(statisticsBtn);
      await tester.pumpAndSettle();
      // Finds and presses go back button
      arrowBackBtn = find.byIcon(Icons.arrow_back);
      await tester.tap(arrowBackBtn);
      await tester.pumpAndSettle();
    });
  });
}
