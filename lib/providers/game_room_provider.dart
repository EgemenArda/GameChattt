import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:game_chat_1/models/room_model.dart';
import 'package:game_chat_1/screens/chat_screen.dart';

class GameRoomProvider extends ChangeNotifier {
  Future<List<Rooms>> fetchRooms() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('rooms').get();
    final List<Rooms> rooms = snapshot.docs.map((doc) {
      return Rooms.fromSnapshot(doc);
    }).toList();
    return rooms;
  } 
 
  Future<void> showAlertDialog(context, roomName, roomId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Join room?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want to join this room?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ChatScreen(
                    roomId: roomId, // Oda belgesinin ID'sini geçir
                    roomName: roomName,
                  ),
                ));
              },
            ),
          ],
        );
      },
    );
  }
}
