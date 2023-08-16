import 'package:flutter/material.dart';

import 'package:game_chat_1/screens/widgets/chat_messages.dart';
import 'package:game_chat_1/screens/widgets/new_messages.dart';

class ChatScreen extends StatelessWidget {
  final String roomId;
  final String roomName;

  ChatScreen({required this.roomId, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomName),
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatMessages(
            roomId: roomId,
          )), // ChatMessages widget'i burada
          NewMessage(
            roomId: roomId,
          ) // NewMessage widget'i burada
        ],
      ),
    );
  }
}
