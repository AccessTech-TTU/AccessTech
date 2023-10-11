import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accesstech/src/contact_screen.dart'; // Import the ContactScreen widget
import 'package:accesstech/src/building_screen.dart'; // Import the BuildingScreen widget

void main() {
  testWidgets('ContactScreen widget test', (WidgetTester tester) async {
    // Create a GlobalKey for the Navigator
    final mockNavigatorKey = GlobalKey<NavigatorState>();

    // Build your widget with a Navigator using the mockNavigatorKey
    await tester.pumpWidget(
      MaterialApp(
        home: Navigator(
          key: mockNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (context) {
              return ContactScreen();
            });
          },
        ),
      ),
    );

    // Verify that the BottomNavigationBarWidget is displayed.
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Tap on the second item in the BottomNavigationBar (index 1).
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    // Verify that the navigator has pushed the expected route (BuildingScreen).
    expect(find.byType(BuildingScreen), findsOneWidget);

    // You can add more test cases as needed for other interactions.
  });
}
