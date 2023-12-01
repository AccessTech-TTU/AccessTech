import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'settings_color_picker.dart';

/*
Authors:
  Travis Libre
Description:
  Meow
*/
Color pickerColor = Color(0x0000ff);
Color currentColor = Color(0x0000ff);

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
      body: ListView(children: <Widget>[
        ColorPickerPage(),
        ColorPickerPage(),
      ]),
    );
  }
}
