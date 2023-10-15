import 'package:accesstech/src/bottom_navigation_bar.dart';
import 'package:accesstech/src/building_screen.dart';
import 'package:accesstech/src/contact_screen.dart';
import 'package:accesstech/src/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //TODO Make wheelchair icon work
  BitmapDescriptor wheelchairIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }
// TODO Get this working.
  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/wheelchair_marker.png")
        .then(
          (icon) {
        setState(() {
          wheelchairIcon = icon;
        });
      },
    );
  } //End of making a wheelchair icon

  int _currentIndex = 0;
  int _previousIndex = 0;
  final List<Widget> _screens = [ // List all possible screen destinations
    MapScreen(),
    BuildingScreen(),
    ContactScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Help button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 204, 0, 0),
        foregroundColor: Colors.white,
        child: Icon(Icons.chat_bubble_outline_rounded),
        onPressed: _helpReqSheet,
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex], // Put possible screens as body
        transitionBuilder: (Widget child, Animation<double> animation){
          var begin = Offset(_currentIndex-_previousIndex as double, 0.0); // Start the new screen from the right
          const end = Offset.zero; // End the transition at the current screen
          const curve = Curves.easeInOut; // Use your desired curve
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        } // Set your desired curve
      ),
      // Define bottom bar
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: (int index) {
          _previousIndex = _currentIndex;
          setState(() { // Change screen to index
            _currentIndex = index;
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