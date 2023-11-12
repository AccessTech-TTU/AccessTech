import 'package:accesstech/src/DraggableBottomSheet.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:accesstech/src/building_screen.dart';
import 'package:accesstech/src/contact_screen.dart';
import 'package:accesstech/src/mapScreen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late int _selectedPageIndex;
  static late List<Widget> _screens;
  late PageController _pageController;
  late Animation<double> _animation;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _selectedPageIndex = 1;
    _screens = [
      // List of states accessible from BottomNavBar
      BuildingScreen(),
      MapScreen(key: Key('Map')),
      ContactScreen()
    ];
    //pageController controls state transitions
    _pageController = PageController(initialPage: _selectedPageIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
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
      floatingActionButton: FloatingActionBubble(
        iconData: Icons.help,
        items: [
          Bubble(
              icon: Icons.chat_bubble,
              iconColor: Colors.white,
              title: "Request",
              bubbleColor: Color.fromARGB(255, 204, 0, 0),
              onPress: () {
                _animationController.reverse();
                _helpReqSheet();
              },
              titleStyle: TextStyle(color: Colors.white)),
          Bubble(
              icon: Icons.phone,
              iconColor: Colors.white,
              title: "Call",
              bubbleColor: Color.fromARGB(255, 204, 0, 0),
              onPress: () {
                _animationController.reverse();
                launchUrl("tel://8067422405" as Uri);
              },
              titleStyle: TextStyle(color: Colors.white)),
          Bubble(
              icon: Icons.history,
              iconColor: Colors.white,
              title: "History",
              bubbleColor: Color.fromARGB(255, 204, 0, 0),
              onPress: () {
                _animationController.reverse();
                AlertDialog(
                  title: Text("Request History"),
                );
              },
              titleStyle: TextStyle(color: Colors.white)),
        ],
        iconColor: Colors.white,
        backGroundColor: Color.fromARGB(255, 204, 0, 0),
        animation: _animation,
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
      ),
      body: Stack(
        children: [
          PageView(
            // Main body is the screens
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: _screens,
          ),
          MyDraggableSheet(key: Key('Sheet')),
        ],
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
