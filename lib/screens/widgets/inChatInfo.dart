import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/game_room_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/create_room_provider.dart';

class inChatInfo extends StatefulWidget {
  const inChatInfo({super.key, required this.owner, required this.roomId, required this.userImage});
  final String owner;
  final String roomId;
  final String userImage;

  @override
  State<inChatInfo> createState() => _inChatInfoState();
}

class _inChatInfoState extends State<inChatInfo> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameRoomProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Text("Owner: ${widget.owner}"),
            StreamBuilder(
              stream: provider.getUsersInRoom(widget.roomId, widget.owner),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No users found beside Owner!'));
                } else {
                  final usersInRoom = snapshot.data;
                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: usersInRoom!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (widget.owner ==
                            Provider.of<CreateRoomProvider>(context)
                                .currentUsername) {
                          usersInRoom.remove(widget.owner);
                          return ListTile(
                            title: Text(usersInRoom[index]),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                QuerySnapshot snapshot =
                                await FirebaseFirestore.instance
                                    .collection('rooms')
                                    .doc(widget.roomId)
                                    .collection('roomUser')
                                    .get();
                                if (snapshot.size > 0) {
                                  String docId = snapshot.docs[0].id;
                                  await FirebaseFirestore.instance
                                      .collection('rooms')
                                      .doc(widget.roomId)
                                      .collection('userRoom')
                                      .doc(docId)
                                      .delete();
                                }
                              },
                              child: const Text('Remove from chat'),
                            ),
                          );
                        } else {
                          return ListTile(
                            title: Text(usersInRoom[index]),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(widget.userImage),
                              backgroundColor: Colors.transparent,
                            ),
                          );
                        }
                      },
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
