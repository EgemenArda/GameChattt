import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:game_chat_1/models/game_model.dart';

class HomePageProvider extends ChangeNotifier {
  HomePageProvider() {
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
}
