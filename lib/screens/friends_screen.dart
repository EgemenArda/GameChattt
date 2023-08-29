import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/friendRequests.dart';
import 'package:game_chat_1/screens/widgets/myFriends.dart';
import 'package:game_chat_1/services/connection_check.dart';
import 'package:provider/provider.dart';
import 'package:game_chat_1/providers/friend_provider.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  int whichFriendScreen = 0;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return ConnectionCheck(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.deepPurple,
          onTap: (index) {
            setState(() {
              whichFriendScreen = index;
            });
          },
          currentIndex: whichFriendScreen,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'My Friends'),
            BottomNavigationBarItem(
              icon: Badge(
                label: StreamBuilder(
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
                      return Text('0');
                    }
                    return Text(pendingRequests.length.toString());
                  },
                ),

                child: Icon(Icons.person_add),
              ),
              label: 'Friend Requests',
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      whichFriendScreen == 1
                          ? const friendRequests()
                          : myFriends(),
                    ],
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    provider.showFriendsDialog(context);
                  },
                  child: Icon(Icons.add),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
