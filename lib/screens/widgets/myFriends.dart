import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/friend_list_tile.dart';

class MyFriends extends StatefulWidget {
  const MyFriends({super.key});

  @override
  State<MyFriends> createState() => _MyFriendsState();
}

class _MyFriendsState extends State<MyFriends> {
  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        List<String> myFriends =
            List.from(snapshot.data!.docs.map((doc) => doc.id));

        if (myFriends.isEmpty) {
          return const Center(
            child: Text('You have no friends yet'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: myFriends.length,
          itemBuilder: (context, index) {
            String friendUserId = myFriends[index];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(friendUserId)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                String friendUsername = snapshot.data!.get('username');
                String friendImage = snapshot.data!.get('image_url');

                return FriendListTile(
                  friendsName: friendUsername,
                  friendsImage: friendImage,
                  index: index,
                );
              },
            );
          },
        );
      },
    );
  }
}
