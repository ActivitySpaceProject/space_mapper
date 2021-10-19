import 'package:asm/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget makeTestableWidget() => MaterialApp(home: Image.network(''));

void main() {
  testWidgets('MyApp() has an appName that equals Space Mapper',
      (WidgetTester tester) async {
    // Test code goes here.
    await tester.pumpWidget(MyApp());

    // Create the Finders.
    final titleFinder = find.text("Space Mapper");

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
  });
}
