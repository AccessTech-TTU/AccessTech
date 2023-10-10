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
    );
  }
}
