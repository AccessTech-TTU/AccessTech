import 'package:accesstech/src/building_screen.dart';
import 'package:accesstech/src/contact_screen.dart';
import 'package:accesstech/src/map_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
  }
  
  class _HomeScreenState extends State<HomeScreen> {
    int _currentIndex = 0;
    List<Widget> _screens = [MapScreen(), BuildingScreen(), ContactScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Buildings",
          icon: Icon(Icons.search),
        ),
        BottomNavigationBarItem(
          label: "Contact",
          icon: Icon(Icons.call),
        ),
      ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
  }
