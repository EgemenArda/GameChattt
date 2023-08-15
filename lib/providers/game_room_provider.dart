import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/room_model.dart';

class GameRoomProvider extends ChangeNotifier {

  Future<List<Rooms>> fetchProducts() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('rooms').get();
    final List<Rooms> products = snapshot.docs.map((doc) {
      return Rooms.fromSnapshot(doc);
    }).toList();
    return products;
  }
}