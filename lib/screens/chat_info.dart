import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatInfo extends StatefulWidget {
  const ChatInfo({super.key, required this.owner});
  final String owner;

  @override
  State<ChatInfo> createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    String username = user!.displayName.toString();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text("Owner: ${username}"),
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
