import 'package:asm/ui/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeView has a title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeView("Space Mapper")));
    expect(find.text("Space Mapper"), findsOneWidget);
  });

  testWidgets('Find icons on home view', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeView("Space Mapper")));

    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byIcon(Icons.gps_fixed), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('Go to add contact screen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeView("Space Mapper")));

    final addContactBtn = find.byIcon(Icons.person);
    await tester.tap(addContactBtn);
    await tester.pumpAndSettle();
    
    expect(find.byType(AppBar), findsOneWidget);
  });
}
