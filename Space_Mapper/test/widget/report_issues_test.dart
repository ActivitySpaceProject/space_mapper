import 'package:asm/ui/report_issues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Report an Issue has an AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ReportAnIssue()));
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets(
      'Report an Issue has a SingleChildScrollView to avoid overflowing',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ReportAnIssue()));
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
