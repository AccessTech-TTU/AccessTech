// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:accesstech/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('BuildingScreen: Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: BuildingScreen(),
    ));

    // Verify that the AppBar is present.
    expect(find.byType(AppBar), findsOneWidget);

    // Verify that the GridView is present.
    expect(find.byType(GridView), findsOneWidget);

    // Verify that the BottomNavigationBar is present.
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Add more widget-specific checks as needed.
  });
}
