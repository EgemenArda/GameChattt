import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game_chat_1/providers/game_room_provider.dart';

class FriendsScreen extends StatelessWidget{
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<GameRoomProvider> (
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
          );
        },
      ),
    );
  }
}