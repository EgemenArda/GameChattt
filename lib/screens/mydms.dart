import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/user_page.dart';
import 'package:provider/provider.dart';

import '../providers/dm_create_provider.dart';

class myDms extends StatefulWidget {
  @override
  State<myDms> createState() => _myDmsState();
}

class _myDmsState extends State<myDms> {
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
          return CircularProgressIndicator();
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
                  return SizedBox();
                }

                String friendUsername = snapshot.data!.get('username');
                String friendImage = snapshot.data!.get('image_url');

                return ListTile(
                  leading: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => UserPageScreen(
                                  profilePicture: friendImage,
                                  username: friendUsername)));
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(friendImage),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  title: Text(friendUsername,
                      style: const TextStyle(
                        fontSize: 24,
                      )),
                  subtitle: Text('Son mesaj'),
                  onTap: () async {
                    Future<String> getUsernameFromUserId(String userId) async {
                      DocumentSnapshot userSnapshot = await FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(userId)
                          .get();

                      if (userSnapshot.exists) {
                        Map<String, dynamic>? userData =
                            userSnapshot.data() as Map<String, dynamic>?;
                        if (userData != null &&
                            userData.containsKey('username')) {
                          return userData['username'];
                        } else {
                          return 'Username Not Found';
                        }
                      } else {
                        return 'Unknown User';
                      }
                    }

                    String creatorUsername = await getUsernameFromUserId(
                        FirebaseAuth.instance.currentUser!.uid);

                    // ignore: use_build_context_synchronously
                    Provider.of<DmCreateProvider>(context, listen: false)
                        .checkAndCreateDMRoom(creatorUsername, friendUsername,
                            context, friendImage);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
