import 'package:flutter/material.dart';

class CustomBottomNavigationBar2 extends StatelessWidget {
  const CustomBottomNavigationBar2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black12,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      onTap: (index) {
        if (index == 0) {
          Navigator.pop(context);
        }
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.gamepad_outlined), label: 'Games'),
        BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined), label: 'Messages')
      ],
    );
  }
}
