import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/internet_connection_failed.dart';

class ConnectionCheck extends StatelessWidget {
  const ConnectionCheck({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, connectivitySnapshot) {
          var connectivityResult = connectivitySnapshot.data;
          var hasConnectivity = connectivityResult != ConnectivityResult.none;

          if (!hasConnectivity) {
            return const InternetConnectionFailed();
          }
          return child;
        });
  }
}
