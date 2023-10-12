import 'package:accesstech/src/building_screen.dart';
import 'package:accesstech/src/contact_screen.dart';
import 'package:accesstech/src/map_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
  }
  class _HomeScreenState extends State<HomeScreen> {
    int _currentIndex = 0;
    List<Widget> _screens = [MapScreen(), BuildingScreen(), ContactScreen()];
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 204, 0, 0),
          child: Icon(Icons.chat_bubble_outline_rounded),
          onPressed: () {
            showDialog(context: context, builder: (context) => AlertDialog(
              title: Text("Contact Help"),
              content: TextField(decoration: InputDecoration(hintText: "What do you need help with?"),),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text("Send"))
              ],
            ));
          },
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
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
