import 'package:asm/ui/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('Side drawers opens from home view', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeView("Space Mapper")));

    final menuBtn = find.byIcon(Icons.menu);
    await tester.tap(menuBtn);
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
  });
}