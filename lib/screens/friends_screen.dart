import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/custom_elevated_buton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_chat_1/screens/widgets/friendRequests.dart';
import 'package:game_chat_1/screens/widgets/myFriends.dart';
import 'package:provider/provider.dart';
import 'package:game_chat_1/providers/friend_provider.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  int whichFriendScreen = 0;
  @override
  Widget build(BuildContext context) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 2),
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
                          onPressed: () {
                            setState(() {
                              whichFriendScreen = 0;
                            });
                          },
                          child: const Text(
                            'My Friends',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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
                          onPressed: () {
                            setState(() {
                              whichFriendScreen = 1;
                            });
                          },
                          child: const Text(
                            'Friend Requests',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    thickness: 2,
                  ),
                  whichFriendScreen == 1 ? const friendRequests() : myFriends(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
