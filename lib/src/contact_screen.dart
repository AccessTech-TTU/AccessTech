import 'package:flutter/material.dart';

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
