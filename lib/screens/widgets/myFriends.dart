import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class myFriends extends StatefulWidget {
  @override
  State<myFriends> createState() => _myFriendsState();
}

class _myFriendsState extends State<myFriends> {
  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(currentUserId).collection('friends').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<String> myFriends = List.from(snapshot.data!.docs.map((doc) => doc.id));

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
              future: FirebaseFirestore.instance.collection('users').doc(friendUserId).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }

                String friendUsername = snapshot.data!.get('username');

                return ListTile(
                  title: Text(friendUsername),
                );
              },
            );
          },
        );
      },
    );
  }
}