import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/chat_messages_dm.dart';
import 'package:game_chat_1/screens/widgets/new_messages_dm.dart';

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

  var replyMessage;
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
          )),
          NewMessagesDm(
            roomId: widget.roomId,
            focusNode: focusNode,
            onCancelReply: cancelReply,
            replyMessage: replyMessage,
          )
        ],
      ),
    );
  }

  void replyToMessage(message) {
    setState(() {
      replyMessage = message;
    });
  }

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }
}
