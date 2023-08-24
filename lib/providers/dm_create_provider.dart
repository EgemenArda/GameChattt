import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/dm_screen.dart';

class DmCreateProvider extends ChangeNotifier {
  DocumentReference roomRef =
      FirebaseFirestore.instance.collection('direct-messages').doc();

  Future<void> checkAndCreateDMRoom(
      String user1, String user2, context, userImage) async {
    CollectionReference dmCollection =
        FirebaseFirestore.instance.collection('direct-messages');

    QuerySnapshot user1Rooms = await dmCollection
        .where('roomUser', arrayContainsAny: [user1, user2]).get();

    if (user1Rooms.docs.isNotEmpty) {
      print('Ysdasdasd');

      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => DmScreen(
                roomId: dmCollection.doc().id,
                roomName: user2,
                roomImage: userImage,
              )));
    } else {
      DocumentReference newDmRoom = await dmCollection.add({
        'roomUser': [
          user1,
          user2
        ] // Burada alan adını 'roomUser' olarak düzelttim
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => DmScreen(
                roomId: newDmRoom.id,
                roomName: user2,
                roomImage: userImage,
              )));
      print('Yeni DM odası oluşturuldu: ${newDmRoom.id}');
    }
  }
}
