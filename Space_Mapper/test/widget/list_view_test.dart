import 'package:asm/ui/list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('list view has an appBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: STOListView()));

    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets(
      'when list view doesnt have data, it displays a CircularProgressIndicator and then an empty container',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: STOListView()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets(
      'list view displays a ListView.builder when it has at least 1 element',
      (WidgetTester tester) async {
    //CustomLocationsManager.createCustomLocation(recordedLocation) // TODO: To test this, we have to use Backgroundgeolocation package to generate a test location

    // Simulate that there is 1 recorded location

    await tester.pumpWidget(MaterialApp(home: STOListView()));
  });
}
