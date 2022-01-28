import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('integration test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      //final Finder addContactButton = find.byIcon(Icons.person);
      final Finder contactButton = find.byIcon(Icons.person);

      await tester.tap(contactButton);

      await tester.pumpAndSettle();
    });
  });
}
