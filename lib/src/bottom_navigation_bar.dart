import 'package:flutter/material.dart';

/*
Authors:
  Travis Libre
Description:
  This file is the builder for the bottom navigation bar. It takes the current
  index and 'onDestinationSelected' logic as inputs. Upon being called, it
  constructs the nav-bar and returns it.
*/

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const BottomNavigationBarWidget({
    Key? key,
    required this.currentIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: onDestinationSelected, //Allow User implementation
      selectedIndex: currentIndex,
      indicatorColor: Colors.red,
      destinations: const [ // Creates buttons and labels
        NavigationDestination(
          label: "Buildings",
          icon: Icon(Icons.search),
        ),
        NavigationDestination(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        NavigationDestination(
          label: "Contact",
          icon: Icon(Icons.call),
        ),
      ],
    );
  }
}