import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/friend_provider.dart';
import 'package:provider/provider.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({super.key});

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Consumer<FriendsProvider>(
      builder: (context, provider, child) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('pendingRequests')
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
                      IconButton(
                        onPressed: () =>
                            provider.acceptFriendRequest(pendingUserId),
                        icon: const Icon(Icons.check),
                      ),
                      IconButton(
                        onPressed: () =>
                            provider.rejectFriendRequest(pendingUserId),
                        icon: const Icon(Icons.close),
                      ),
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
