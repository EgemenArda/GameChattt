import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/game_room_provider.dart';
import 'package:provider/provider.dart';

class chatJoinRequests extends StatefulWidget {
  chatJoinRequests({super.key, required this.roomId});
  String roomId;

  @override
  State<chatJoinRequests> createState() => _chatJoinRequestsState();
}

class _chatJoinRequestsState extends State<chatJoinRequests> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameRoomProvider>(
      builder: (context, provider, child) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('rooms')
              .doc(widget.roomId)
              .collection('joinRequests')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            List<String> pendingRequests =
                List.from(snapshot.data!.docs.map((doc) => doc.id));

            if (pendingRequests.isEmpty) {
              return const Center(
                child: Text('No pending requests'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: pendingRequests.length,
              itemBuilder: (context, index) {
                String pendingUserId = pendingRequests[index];

                return ListTile(
                  title: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(pendingUserId)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }

                      String username = snapshot.data!.get('username');

                      return Text(username);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton(
                      //   onPressed: () =>
                      //       provider.acceptRoomInvite(pendingUserId, widget.roomId),
                      //   icon: const Icon(Icons.check),
                      // ),
                      // IconButton(
                      //   onPressed: () =>
                      //       provider.rejectRoomInvite(pendingUserId, widget.roomId),
                      //   icon: const Icon(Icons.close),
                      // ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
