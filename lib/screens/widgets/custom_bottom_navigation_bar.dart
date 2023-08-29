import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key, this.snapshot}) : super(key: key);
  final snapshot;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      fixedColor: const Color(0xff2398C3),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: snapshot.data.index,
      onTap: (int) {},
      items: [
        const BottomNavigationBarItem(
          label: 'search',
          icon: Icon(Icons.search),
        ),
        const BottomNavigationBarItem(
          label: 'Browse',
          icon: Icon(Icons.view_list),
        ),
        BottomNavigationBarItem(
          label: 'Create Room',
          icon: Container(
            child: const FlutterLogo(
              size: 35.0,
            ),
          ),
        ),
        const BottomNavigationBarItem(
          label: 'My Rooms',
          icon: Icon(Icons.bookmark),
        ),
        const BottomNavigationBarItem(
          label: 'Settings',
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }
}
