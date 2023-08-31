import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/chat_screen.dart';
import 'package:game_chat_1/services/firestore_services.dart';

class CreateRoomProvider extends ChangeNotifier {
  CreateRoomProvider() {
    setCurrentUsername();
  }
  int selectedNumber = 1;
  String selectedRoomType = "";
  String currentUsername = "";

  void setCurrentUsername() async {
    currentUsername =
        await getUsernameFromUserId(FirebaseAuth.instance.currentUser!.uid);
    notifyListeners();
  }

  TextEditingController roomName = TextEditingController();
  TextEditingController roomDescription = TextEditingController();
  String gameName = "Please Choose a game";
  void setGameName(value) {
    gameName = value;
    notifyListeners();
  }

  void createRoom(context) async {
    final FirestoreService firestoreService = FirestoreService();
    Future<void> user = FirestoreService()
        .getUserFromUserId(FirebaseAuth.instance.currentUser!.uid);

    if (user != null) {
      String creatorUserId = FirebaseAuth.instance.currentUser!.uid;
      String creatorUsername = await firestoreService.users.username;
      const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
      Random _rnd = Random();

      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
      final code = getRandomString(6);

      DocumentReference roomRef =
          FirebaseFirestore.instance.collection('rooms').doc();

      await roomRef.set({
        'room_name': roomName.text,
        'room_description': roomDescription.text,
        'room_creator': creatorUsername,
        'room_size': selectedNumber,
        'game_name': gameName,
        'room_type': selectedRoomType,
        'room_code': code,
      });

      await roomRef.collection("roomUser").add({
        'username': creatorUsername,
        'fcmToken': 'user.fcmToken',
      });
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomRef.id)
          .collection('joinRequests');
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomRef.id)
          .collection('joinRequests')
          .doc(roomRef.id)
          .delete();
      var querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomRef.id)
          .collection('roomUser')
          .get();
      List<String> usernames = [];
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data();
          String username = data['username'];

          usernames.add(username);
        }

        print("Usernames in the room: $usernames");
      } else {
        print("No usernames found in the room.");
      }
      if (selectedRoomType == "Private") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => ChatScreen(
            roomId: roomRef.id, // Oda belgesinin ID'sini geçir
            roomName: roomName.text,
            roomCode: code,
            roomCreator: creatorUsername, roomType: selectedRoomType,
            roomUser: usernames,
          ),
        ));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => ChatScreen(
            roomId: roomRef.id, // Oda belgesinin ID'sini geçir
            roomName: roomName.text,
            roomCreator: creatorUsername, roomType: selectedRoomType,
            roomUser: usernames,
          ),
        ));
      }
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
