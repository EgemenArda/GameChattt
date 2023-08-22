import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_chat_1/providers/create_room_provider.dart';
import 'package:provider/provider.dart';

class ChatInfo extends StatefulWidget {
  const ChatInfo({super.key, required this.owner, required this.users});
  final String owner;
  final List<String> users;
  @override
  State<ChatInfo> createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<CreateRoomProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Column(
              children: [
                Text("Owner: ${widget.owner}"),
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: widget.users.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (widget.owner == provider.currentUsername) {
                        return ListTile(
                          title: Text(widget.users[index]),
                          trailing: ElevatedButton(onPressed: (){}, child: const Text("remove from chat")),
                        );
                      } else {
                        return ListTile(
                          title: Text(widget.users[index]),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
