import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/chat_info.dart';
import 'package:game_chat_1/screens/home_screen.dart';
import 'package:game_chat_1/screens/widgets/chat_messages.dart';
import 'package:game_chat_1/screens/widgets/new_messages.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String roomCreator;
  final String roomType;

  final String? roomCode;
  final List<String> roomUser;

  const ChatScreen(
      {super.key,
      required this.roomId,
      required this.roomName,
      required this.roomCreator,
      required this.roomType,
      this.roomCode,
      required this.roomUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String roomCode = '';
  @override
  var ReplyMessage;
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).pop();
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('lastDate')
                .doc(widget.roomId)
                .set({'left': Timestamp.now()});
          },
        ),
        title: Text(widget.roomCode == null ? "Public Room" : widget.roomCode!),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ChatInfo(
                    roomId: widget.roomId,
                    owner: widget.roomCreator,
                    users: widget.roomUser,
                    userImage: '',
                  ),
                ));
              },
              icon: const Icon(Icons.info_outline)),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Get your friends!'),
                      content: Text(roomCode),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              roomCode = 'Generated code!';
                            });
                          },
                          child: Text('Create direct join code'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.share)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatMessages(
            roomId: widget.roomId,
            onSwippedMessage: (message) {
              replyToMessage(message);
              focusNode.requestFocus();
            },
          )), // ChatMessages widget'i burada
          NewMessage(
            roomId: widget.roomId,
            focusNode: focusNode,
            onCancelReply: cancelReply,
            replyMessage: ReplyMessage,
          )
        ],
      ),
    );
  }

  void replyToMessage(message) {
    setState(() {
      ReplyMessage = message;
    });
  }

  void cancelReply() {
    setState(() {
      ReplyMessage = null;
    });
  }
}
