import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets(
        'integration test',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      //final Finder addContactButton = find.byIcon(Icons.person);
      //final Finder menuButton = find.byIcon(Icons.menu);
      
      //await tester.tap(menuButton);

      await tester.pumpAndSettle();
    });
  });
}
