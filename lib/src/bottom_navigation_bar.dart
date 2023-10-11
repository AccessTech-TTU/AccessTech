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
      onTap: onTap,
    );
  }
}

Future<void> navigateWithTransition(BuildContext context, Widget screen, double i) async {
  await Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return screen;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(i, 0.0); // Start the new screen from the right
        const end = Offset.zero; // End the transition at the current screen
        const curve = Curves.easeInOut; // Use your desired curve
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}