import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/chat_info.dart';
import 'package:game_chat_1/screens/widgets/chat_messages.dart';
import 'package:game_chat_1/screens/widgets/new_messages.dart';

class ChatScreen extends StatelessWidget {
  final String roomId;
  final String roomName;
  final String roomCreator;
  final String roomType;
  final String? roomCode;

  const ChatScreen(
      {required this.roomId,
      required this.roomName,
      required this.roomCreator,
      required this.roomType,
      this.roomCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomCode == null ? "Public Room" : roomCode!),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ChatInfo(
                    owner: roomCreator,
                  ),
                ));
              },
              icon: const Icon(Icons.info_outline))
        ],
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
