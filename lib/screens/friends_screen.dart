import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/custom_elevated_buton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:game_chat_1/providers/friend_provider.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Friends List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
      body: Consumer<FriendsProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green, width: 3.0),
                      ),
                      onPressed: () => provider.showFriendsDialog(context),
                      child: const Text(
                        'Add friends',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    thickness: 2,
                  ),
                  StreamBuilder(
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
                                  return SizedBox();
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
                                  icon: Icon(Icons.check),
                                ),
                                IconButton(
                                  onPressed: () => provider.rejectFriendRequest(pendingUserId),
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
