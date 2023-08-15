import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateRoomProvider extends ChangeNotifier {
  int selectedNumber = 1; // Varsayılan seçilen sayı 1
  TextEditingController roomName = TextEditingController();
  TextEditingController roomDescription = TextEditingController();
  String gameName = "Please Choose a game";
  void setGameName(value){
    gameName = value;
    notifyListeners();
  }

  void createRoom() {
    FirebaseFirestore.instance.collection('rooms').doc().set({
      'room_name': roomName.text,
      'room_description': roomDescription.text,
      'room_creator': FirebaseAuth.instance.currentUser!.email,
      'room_size': selectedNumber,
      'game_name': gameName
    });
  }
}
