import 'package:accesstech/src/bottom_navigation_bar.dart';
import 'package:accesstech/src/building_screen.dart';
import 'package:accesstech/src/contact_screen.dart';
import 'package:accesstech/src/map_screen.dart';
import 'package:flutter/material.dart';

/*
Authors:
  Thinh Pham, Travis Libre
Description:
  This file is the root screen, it contains the navigation bar constructor, the
  3 other screens as states, and a help button. The other screens
  (map, buildings, etc) are children of this one. It uses PageController to
  switch between states.
*/

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedPageIndex;
  static late List<Widget> _screens;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _selectedPageIndex = 1;
    _screens = [  // List of states accessible from BottomNavBar
      BuildingScreen(),
      MapScreen(),
      ContactScreen()
    ];
    //pageController controls state transitions
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Help button
      floatingActionButton: FloatingActionButton(  // Implement emergency button
        backgroundColor: Color.fromARGB(255, 204, 0, 0),
        foregroundColor: Colors.white,
        child: Icon(Icons.chat_bubble_outline_rounded),
        onPressed: _helpReqSheet,
      ),

      body: PageView( // Main body is the screens
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBarWidget(  // Call nav_bar file
        currentIndex: _selectedPageIndex,
        onDestinationSelected: (selectedPageIndex) {
          setState(() {
            _selectedPageIndex = selectedPageIndex;  // Change screen to index
            _pageController.animateToPage( // Animate page transition
                selectedPageIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease
            );
          });
        },
      ),
    );
  }

  // Function to pull a "bottom sheet" with Help Request form items
  // when Help Button is tapped
  void _helpReqSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(children: [
            Align(
              child: Text(
                "New Help Request",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.center,
            ),
            TextField(
              decoration:
              InputDecoration(hintText: "What do you need help with?"),
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(hintText: "Describe your problem"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Send"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
              ],
            ),
          ]),
        );
      },
      showDragHandle: true,
      isScrollControlled: true,
    );
  }
}