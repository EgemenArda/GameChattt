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

    String roomIdentifier = '${user1 + user2}';

    QuerySnapshot userRooms = await dmCollection
        .where('roomIdentifier', isEqualTo: roomIdentifier)
        .get();

    if (userRooms.docs.isNotEmpty) {
      String roomId = userRooms.docs.first.id;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => DmScreen(
          roomId: roomId,
          roomName: user2,
          roomImage: userImage,
        ),
      ));
    } else {
      DocumentReference newDmRoom = await dmCollection.add({
        'roomUser': [user1, user2],
        'roomIdentifier': roomIdentifier
      });
      Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => DmScreen(
          roomId: newDmRoom.id,
          roomName: user2,
          roomImage: userImage,
        ),
      ));
      print('Yeni DM odası oluşturuldu: ${newDmRoom.id}');
    }
  }
}
