import 'package:flutter/material.dart';

/*
Authors:
  Travis Libre
Description:
  Meow
*/

class Settings extends StatelessWidget {
  const Settings({Key? key});

  @override
  Widget build(BuildContext context) {
    // Contact Screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 2,
      ),
      body: Center(
        child: Text(
          "Settings Go Here",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
