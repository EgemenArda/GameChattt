import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/game_room_provider.dart';
import 'package:game_chat_1/screens/mydms.dart';
import 'package:game_chat_1/screens/myroomsss.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyRoomsScreen extends StatefulWidget {
  MyRoomsScreen({super.key, required this.username});

  String username;

  @override
  State<MyRoomsScreen> createState() => _MyRoomsScreenState();
}

class _MyRoomsScreenState extends State<MyRoomsScreen> {
  int inWhichRooms = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        onTap: (index) {
          setState(() {
            inWhichRooms = index;
          });
        },
        currentIndex: inWhichRooms,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'My Rooms'),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'My Dms')
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Rooms'),
      ),
      body: Consumer<GameRoomProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Center(
              child: inWhichRooms == 0
                  ? myRoomsss(
                      username: widget.username,
                    )
                  : myDms(),
            ),
          );
        },
      ),
    );
  }
}
