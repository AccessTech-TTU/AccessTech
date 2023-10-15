import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationBarWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      fixedColor: Colors.red,
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
      onTap: onTap, // Allow onTap function to be caller-defined
    );
  }
}