import 'package:accesstech/src/home_screen.dart';
import 'package:flutter/material.dart';

//TODO Change API key before publication
void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      colorSchemeSeed: Color.fromARGB(255, 204, 0, 0),
      /* light theme settings */
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      /* dark theme settings */
    ),
    themeMode: ThemeMode.system,
    /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
    title: "AccessRaider",
    home: HomeScreen(),
  ));
}