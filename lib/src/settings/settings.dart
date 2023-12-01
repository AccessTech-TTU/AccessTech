import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'settings_color_picker.dart';

/*
Authors:
  Travis Libre
Description:
  Meow
*/
class Settings extends StatefulWidget {
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
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color polylineColor = Color(0x0000ff);
  Color iconColor = Color(0xffffff);
  bool oh = false;
  bool one = false;
  bool isHighContrastMode = false;

  @override
  Widget build(BuildContext context) {
    // Contact Screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 2,
      ),
      body: ListView(
        children: <Widget>[
          ColorPickerPage(
            onColorChanged: widget.onPolylineColorChanged,
            parentColor: widget.parentPolylineColor,
            text: "Change route line color",
          ),
          ColorPickerPage(
            onColorChanged: widget.onIconColorChanged,
            parentColor: widget.parentIconColor,
            text: "Change icon color",
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Elevation Changes',
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                  ),
                  SizedBox(width: 16),
                  Transform.scale(
                    scale: 1.5,
                    child: Switch(
                      value: oh,
                      activeColor: Colors.red,
                      onChanged: (bool value) {
                        setState(() {
                          oh = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'High Contrast Mode',
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                  ),
                  SizedBox(width: 16),
                  Transform.scale(
                    scale: 1.5,
                    child: Switch(
                      value: isHighContrastMode,
                      activeColor: Colors.red,
                      onChanged: (bool value) {
                        setState(() {
                          isHighContrastMode = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Screen Reader',
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                  ),
                  SizedBox(width: 16),
                  Transform.scale(
                    scale: 1.5,
                    child: Switch(
                      value: one,
                      activeColor: Colors.red,
                      onChanged: (bool value) {
                        setState(() {
                          one = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () => (),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFC00000)),
              ),
              child: Text(
                'Adjust Font Size',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
