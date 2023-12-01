import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'settings_color_picker.dart';

/*
Authors:
  Travis Libre
Description:
  Meow
*/
Color polylineColor = Color(0x0000ff);
Color iconColor = Color(0xffffff);

class Settings extends StatelessWidget {
  final Function(Color) onPolylineColorChanged;
  final Function(Color) onIconColorChanged;
  final Color parentPolylineColor;
  final Color parentIconColor;

  const Settings({
    Key? key,
    required this.onPolylineColorChanged,
    required this.onIconColorChanged,
    required this.parentPolylineColor,
    required this.parentIconColor,
  });

  @override
  Widget build(BuildContext context) {
    // Contact Screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 2,
      ),
      body: ListView(children: <Widget>[
        ColorPickerPage(
          onColorChanged: onPolylineColorChanged,
          parentColor: parentPolylineColor,
          text: "Change route line color",
        ),
        ColorPickerPage(
          onColorChanged: onIconColorChanged,
          parentColor: parentIconColor,
          text: "Change icon color",
        ),
      ]),
    );
  }
}
