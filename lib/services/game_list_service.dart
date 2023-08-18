import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';

import '../models/game_model.dart';

class GamesListService {
  bool isConnectionAvailable = true;
  bool isGamesLoading = false;
  int skipValue = 0;
  List<Games> gameList = [];
  Future<void> getGames() async {
    String jsonString = await rootBundle.loadString("assets/data/games.json");
    final jsonData = jsonDecode(jsonString);
    final gameData = jsonData["games"] as List<dynamic>;
    gameList = gameData.map((games) => Games.fromJson(games)).toList();
  }

  final StreamController<List<Games>> _gameListController =
      StreamController<List<Games>>.broadcast();

  Sink<List<Games>> get _addGamesList => _gameListController.sink;

  Stream<List<Games>> get getGamesList => _gameListController.stream;

  GamesListService() {
    startListeners();
  }

  void dispose() {
    _gameListController.close();
  }

  void startListeners() {
    _gameListController.stream.listen((games) {
      isGamesLoading = false;
    });
  }

  void addGames(List<Games> addToGames) {
    //add a new room to the existing rooms list
    if (addToGames.isNotEmpty) {
      isGamesLoading = true;
      gameList.addAll(addToGames);
    }
    _addGamesList.add(gameList);
  }

  void addGamesError(String error) {
    isGamesLoading = false;
    _gameListController.addError(error);
  }

  void refreshCurrentListGames() {
    _addGamesList.add(gameList);
  }

  void clearGames() {
    skipValue = 0;
    gameList.clear();
    _addGamesList.add([]);
  }
}
