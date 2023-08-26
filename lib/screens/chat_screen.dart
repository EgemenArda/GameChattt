import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/chat_info.dart';
import 'package:game_chat_1/screens/home_screen.dart';
import 'package:game_chat_1/screens/widgets/chat_messages.dart';
import 'package:game_chat_1/screens/widgets/new_messages.dart';
import 'package:swipe_to/swipe_to.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.keyboard_return),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => HomeScreen()));
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
              icon: const Icon(Icons.info_outline))
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
