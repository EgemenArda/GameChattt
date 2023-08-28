import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:game_chat_1/models/game_model.dart';

class HomePageProvider extends ChangeNotifier {
  HomePageProvider() {
    _getUserName();
    getComments();
  }
  List<Games> games = [];

  Future<void> getComments() async {
    String jsonString = await rootBundle.loadString("assets/data/games.json");

    final jsonData = jsonDecode(jsonString);

    final commentData = jsonData["games"] as List<dynamic>;
    games = commentData.map((comments) => Games.fromJson(comments)).toList();
    notifyListeners();
  }

  String username = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _getUserName() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        var userName = userSnapshot['username'];
        username = userName;
      } else {
        print('User data not found in Firestore.');
      }
    } else {
      print('User is not logged in.');
    }
  }
}
