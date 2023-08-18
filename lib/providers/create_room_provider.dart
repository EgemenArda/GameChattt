import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/chat_screen.dart';

class CreateRoomProvider extends ChangeNotifier {
  int selectedNumber = 1; // Varsayılan seçilen sayı 1
  TextEditingController roomName = TextEditingController();
  TextEditingController roomDescription = TextEditingController();
  String gameName = "Please Choose a game";
  void setGameName(value) {
    gameName = value;
    notifyListeners();
  }

  void createRoom(context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String creatorUserId = user.uid;
      String creatorUsername = await getUsernameFromUserId(creatorUserId);

      DocumentReference roomRef =
          FirebaseFirestore.instance.collection('rooms').doc();

      await roomRef.set({
        'room_name': roomName.text,
        'room_description': roomDescription.text,
        'room_creator': creatorUsername,
        'room_size': selectedNumber,
        'game_name': gameName,
      });

      await roomRef.collection("roomUser").add({'username': creatorUsername});
      Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => ChatScreen(
          roomId: roomRef.id, // Oda belgesinin ID'sini geçir
          roomName: roomName.text,
          roomCreator: creatorUsername,
        ),
      ));
    }
  }

  Future<String> getUsernameFromUserId(String userId) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      if (userData != null && userData.containsKey('username')) {
        return userData['username'];
      } else {
        return 'Username Not Found';
      }
    } else {
      return 'Unknown User';
    }
  }
}
