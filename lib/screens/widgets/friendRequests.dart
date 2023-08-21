import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/custom_elevated_buton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:game_chat_1/providers/friend_provider.dart';

class friendRequests extends StatefulWidget {
  const friendRequests({super.key});

  @override
  State<friendRequests> createState() => _friendRequestsState();
}

class _friendRequestsState extends State<friendRequests> {
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

                      String username =
                      snapshot.data!.get('username');

                      return Text(username);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => provider
                            .acceptFriendRequest(pendingUserId),
                        icon: const Icon(Icons.check),
                      ),
                      IconButton(
                        onPressed: () => provider.rejectFriendRequest(pendingUserId),
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
