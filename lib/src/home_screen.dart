import 'dart:developer';

import 'package:accesstech/src/DraggableBottomSheet.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:accesstech/src/building_screen.dart';
import 'package:accesstech/src/contact_screen.dart';
import 'package:accesstech/src/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'request.dart';
import 'RequestsHistory.dart';

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
      MapScreen(),
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

  bool isDrawerOpen = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
              onPress: () async {
                final Uri sdsCall = Uri(scheme: 'tel', path: "806 742 2405");
                if (await canLaunchUrl(sdsCall)) {
                  await launchUrl(sdsCall);
                } else {
                  log("Can't call.");
                }
                _animationController.reverse();
              },
              titleStyle: TextStyle(color: Colors.white)),
          Bubble(
              icon: Icons.history,
              iconColor: Colors.white,
              title: "History",
              bubbleColor: Color.fromARGB(255, 204, 0, 0),
              onPress: () {
                _animationController.reverse();
                _reqHist();
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
          MyDraggableSheet(),
          // Positioned(
          //   top: 10,
          //   child: Padding(
          //     padding: const EdgeInsets.all(20.0),
          //     child: FloatingActionButton.small(
          //       onPressed: () {},
          //       child: Icon(
          //         Icons.menu,
          //         color: Colors.black,
          //       ),
          //       backgroundColor: Colors.white,
          //       elevation: 10,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 60,
          //   child: Padding(
          //     padding: const EdgeInsets.all(20.0),
          //     child: FloatingActionButton.small(
          //       onPressed: () => scaffoldKey.currentState!.openDrawer(),
          //       child: Icon(
          //         Icons.filter_vintage,
          //         color: Colors.black,
          //       ),
          //       backgroundColor: Colors.white,
          //       elevation: 10,
          //     ),
          //   ),
          // ),
        ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       DrawerHeader(
      //         decoration: BoxDecoration(color: Color.fromARGB(255, 204, 0, 0)),
      //         child: Text(
      //           "Filter",
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //         title: Text('Drawer Item 1'),
      //         // Add your drawer items here
      //       ),
      //       ListTile(
      //         title: Text('Drawer Item 2'),
      //         // Add more drawer items
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // Function to pull a "bottom sheet" with Help Request form items
  // when Help Button is tapped
  void _helpReqSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewRequest(onAddRequest: _addRequest),
      showDragHandle: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void _reqHist() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: req_hist.length,
          itemBuilder: (context, index) {
            var req = req_hist[index];
            req.getCoordinatesAsString();
            return Card(
              elevation: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(req.title, style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 4,),
                    Row(
                      children: [
                        Text(req.getDate()),
                        Spacer(),
                        Text(req.getStatus()),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      showDragHandle: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void _addRequest(Request r) {
    req_hist.add(r);
  }
}
