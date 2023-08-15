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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var userName;
  Future<void> _getUserName() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        userName = userSnapshot['name'];
        print('User Name: $userName');
      } else {
        print('User data not found in Firestore.');
      }
    } else {
      print('User is not logged in.');
    }
  }
}