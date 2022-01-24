import 'package:asm/ui/statistics/statistics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MyStatistics());

    // Create the Finders.
    final titleFinder = find.text('Avg Contacts');
// that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
  });
}
