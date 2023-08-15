import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateRoomProvider extends ChangeNotifier {
  int selectedNumber = 1; // Varsayılan seçilen sayı 1
  TextEditingController roomName = TextEditingController();
  TextEditingController roomDescription = TextEditingController();
  String gameName = "Please Choose a game";
  void setGameName(value) {
    gameName = value;
    notifyListeners();
  }

  void createRoom() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Kullanıcının mevcut oturum bilgisi varsa
      String creatorUserId = user.uid;
      String creatorUsername = await getUsernameFromUserId(creatorUserId);

      FirebaseFirestore.instance.collection('rooms').doc().set({
        'room_name': roomName.text,
        'room_description': roomDescription.text,
        'room_creator': creatorUsername,
        'room_size': selectedNumber,
        'game_name': gameName,
      });
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