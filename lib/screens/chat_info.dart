import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/game_room_provider.dart';
import 'package:game_chat_1/screens/widgets/chatJoinRequests.dart';
import 'package:game_chat_1/screens/widgets/inChatInfo.dart';
import 'package:provider/provider.dart';

class ChatInfo extends StatefulWidget {
  const ChatInfo({
    super.key,
    required this.owner,
    required this.users,
    required this.roomId,
    required this.userImage,
  });

  final String owner;
  final String roomId;
  final String userImage;

  final List<String> users;

  @override
  State<ChatInfo> createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  User? user = FirebaseAuth.instance.currentUser;
  int whichInfoScreen = 0;

  @override
  Widget build(BuildContext context) {
    widget.users.remove(widget.owner);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        onTap: (index) {
          setState(() {
            whichInfoScreen = index;
          });
        },
        currentIndex: whichInfoScreen,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.room_preferences), label: 'In room'),
          BottomNavigationBarItem(
            icon: Badge(
              label: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rooms')
                    .doc(widget.roomId)
                    .collection('joinRequests')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  List<String> joinRequests =
                      List.from(snapshot.data!.docs.map((doc) => doc.id));
                  if (joinRequests.isEmpty) {
                    return const Text('0');
                  }
                  return Text(joinRequests.length.toString());
                },
              ),
              child: const Icon(Icons.local_post_office_rounded),
            ),
            label: 'Join Requests',
          )
        ],
      ),
      appBar: AppBar(),
      body: Consumer<GameRoomProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      whichInfoScreen == 0
                          ? InChatInfo(
                              owner: widget.owner,
                              roomId: widget.roomId,
                              userImage: widget.userImage)
                          : chatJoinRequests(roomId: widget.roomId),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
