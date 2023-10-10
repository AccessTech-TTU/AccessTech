import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';
import 'building_screen.dart';
import 'map_screen.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    // Contact Screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('AccessTech'),
        elevation: 2,
      ),
      body: Center(
        child: Text(
          "Contact Information Goes Here",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              navigateWithTransition(context, const MapScreen(),-2);
              break;
            case 1:
              navigateWithTransition(context, const BuildingScreen(),-1);
              break;
            case 2:
              break;
          }
        },
      ),
    );
  }
}
