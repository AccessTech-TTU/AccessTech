
import 'package:flutter/material.dart';

class HomePageController {
  late void Function() methodA;
}

class MyApp extends StatelessWidget {

  final HomePageController myController = HomePageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              myController.methodA();
            },
          ),// IconButton
        ),// AppBar
        body: HomePage(
          controller: myController,
        ),// HomePage
      ),
    );
  }
}

class HomePage extends StatefulWidget {

  final HomePageController controller;

  HomePage({ required this.controller });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    widget.controller.methodA = methodA;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void methodA() {}
}