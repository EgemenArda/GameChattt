import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:game_chat_1/services/game_list_service.dart';

class ConnectionService {
  late StreamSubscription<ConnectivityResult> connectivity;
  late GamesListService roomListService;

  ConnectionService(GamesListService service) {
    roomListService = service;
  }

  Future<bool> isInternetConnectionAvailable() async {
    bool isConnectionAvailable = true;
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      isConnectionAvailable = false;
      roomListService.isConnectionAvailable = false;
      roomListService.isGamesLoading = false;
      roomListService
          .addGamesError('internet connections is currently not available');
    }
    return isConnectionAvailable;
  }

  watchConnectivity(GamesListService roomListService) {
    connectivity = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult status) {
      switch (status) {
        case ConnectivityResult.none:
          roomListService.isConnectionAvailable = false;
          roomListService.isGamesLoading = false;
          roomListService
              .addGamesError('internet connection is currently not available');
          break;
        default:
          roomListService.isConnectionAvailable = true;
          roomListService.refreshCurrentListGames();
      }
    });
  }

  void cancel() {
    connectivity.cancel();
  }
}
