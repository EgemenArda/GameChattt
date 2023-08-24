import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/chat_info.dart';
import 'package:game_chat_1/screens/widgets/chat_messages.dart';
import 'package:game_chat_1/screens/widgets/chat_messages_dm.dart';
import 'package:game_chat_1/screens/widgets/new_messages.dart';
import 'package:game_chat_1/screens/widgets/new_messages_dm.dart';
import 'package:swipe_to/swipe_to.dart';

class DmScreen extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String roomImage;
  const DmScreen({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.roomImage,
  });

  @override
  State<DmScreen> createState() => _DmScreenState();
}

class _DmScreenState extends State<DmScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();
    final token = fcm.getToken();
    print(token);
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  var ReplyMessage;
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.roomImage),
              backgroundColor: Colors.transparent,
            ),
            Text(widget.roomName)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatMessagesDm(
            roomId: widget.roomId,
            onSwippedMessage: (message) {
              replyToMessage(message);
              focusNode.requestFocus();
            },
          )), // ChatMessages widget'i burada
          NewMessagesDm(
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
