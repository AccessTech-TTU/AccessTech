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
  List<Widget> _screens = [MapScreen(), BuildingScreen(), ContactScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 204, 0, 0),
        foregroundColor: Colors.white,
        child: Icon(Icons.chat_bubble_outline_rounded),
        onPressed: _helpReqSheet,
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

  void _helpReqDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Contact Help"),
              content: TextField(
                decoration:
                    InputDecoration(hintText: "What do you need help with?"),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Send"))
              ],
            ));
  }
}
