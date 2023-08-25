import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/game_room_provider.dart';
import 'package:provider/provider.dart';

class myDms extends StatefulWidget {
  myDms({super.key, required this.username});

  String username;

  @override
  State<myDms> createState() => _myDmsState();
}

class _myDmsState extends State<myDms> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameRoomProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            StreamBuilder(
              stream: provider.getMyDms(widget.username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No dm found.'));
                } else {
                  final rooms = snapshot.data;
                  return SizedBox(
                    height: 285,
                    child: ListView.builder(
                      itemCount: rooms!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () async {
                            CollectionReference _roomCollection =
                            FirebaseFirestore.instance
                                .collection('direct-messages');
                            QuerySnapshot snapshot = await _roomCollection
                                .doc(rooms[index].documentId)
                                .collection('dmPeople')
                                .get();

                            // ignore: use_build_context_synchronously
                            provider.showAlertDialog(
                                context,
                                rooms[index].roomName,
                                rooms[index].documentId,
                                rooms[index].roomSize,
                                snapshot.docs,
                                rooms[index].roomCreator,
                                rooms[index].roomType,
                                rooms[index].roomCode);
                          },
                          child: ListTile(
                            leading: StreamBuilder<int>(
                              stream: provider.compareAfterDate(
                                  rooms[index].documentId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return const Text(
                                    "0",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  );
                                }
                                final messageCount = snapshot.data ?? 0;
                                return Text(
                                  "$messageCount",
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            title: Text(rooms[index].roomName),
                            subtitle: Text(rooms[index].roomDescription),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                QuerySnapshot snapshot =
                                await FirebaseFirestore.instance
                                    .collection('direct-messages')
                                    .doc(rooms[index].documentId)
                                    .collection('dmPeople')
                                    .where('username',
                                    isEqualTo: widget.username)
                                    .get();
                                if (snapshot.size > 0) {
                                  String docId = snapshot.docs[0].id;
                                  await FirebaseFirestore.instance
                                      .collection('direct-messages')
                                      .doc(rooms[index].documentId)
                                      .collection('dmPeople')
                                      .doc(docId)
                                      .delete();
                                }
                              },
                              child: const Text('Odadan ayrıl'),
                            ),
                          ),
                        );
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
