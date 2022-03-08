import 'package:asm/components/banner_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'BannerImage with an invalid url',
    (WidgetTester tester) async {
      String url = "";
      double height = 20.0;

      await tester
          .pumpWidget(MaterialApp(home: BannerImage(url: url, height: height)));

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    },
  );

  testWidgets(
    'BannerImage with a valid url',
    (WidgetTester tester) async {
      String url = "";
      double height = 20.0;

      await tester
          .pumpWidget(MaterialApp(home: BannerImage(url: url, height: height)));

      expect(find.byType(Container), findsOneWidget);
      //expect(find.byType(Image), findsOneWidget); //TODO: How to test a network image?
    },
  );
}
