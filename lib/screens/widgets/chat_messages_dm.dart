import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/message_bubble.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatMessagesDm extends StatelessWidget {
  const ChatMessagesDm({super.key, required this.roomId, required this.onSwippedMessage});
  final String roomId;
  final ValueChanged onSwippedMessage;
  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    bool isRevealed = false;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('direct-messages')
          .doc(roomId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text("No messages found."),
          );
        }
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text("Something went wrong."),
          );
        }
        final loadedMesseages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMesseages.length,
          itemBuilder: (BuildContext context, int index) {
            final chatMessage = loadedMesseages[index].data();
            final nextChatMessage = index + 1 < loadedMesseages.length
                ? loadedMesseages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage["userId"];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return SwipeTo(
                onRightSwipe: () {},
                child: MessageBubble.next(
                    message: chatMessage["text"],
                    isMe: authenticatedUser.uid == currentMessageUserId),
              );
            } else {
              final message = chatMessage["text"];

              return SwipeTo(
                onRightSwipe: () => onSwippedMessage(message),
                child: MessageBubble.first(
                    userImage: chatMessage["userImage"],
                    username: chatMessage["username"],
                    message: chatMessage["text"],
                    isMe: authenticatedUser.uid == currentMessageUserId),
              );
            }
          },
        );
      },
    );
  }
}
