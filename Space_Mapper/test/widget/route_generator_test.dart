import 'package:asm/main.dart';
import 'package:asm/ui/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyApp redirects to "/", which is HomeView', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MyApp()));
    await tester.pumpAndSettle();
    // MyApp should redirect to Home_View
    expect(find.byType(HomeView), findsOneWidget);
  });
}