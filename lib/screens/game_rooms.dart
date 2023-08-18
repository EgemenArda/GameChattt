import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/profile_proivder.dart';
import 'package:provider/provider.dart';
import 'widgets/custom_drawer.dart';
import '../providers/game_room_provider.dart';
import 'create_room_screen.dart';

class GameRooms extends StatefulWidget {
  const GameRooms({super.key, required this.gameName});
  final gameName;
  @override
  State<GameRooms> createState() => _GameRoomsState();
}

class _GameRoomsState extends State<GameRooms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => CircleAvatar(
            backgroundImage: NetworkImage(
                Provider.of<ProfileScreenProvider>(context).userImage),
            child: TextButton(
              child: const Text(''),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(widget.gameName),
      ),
      drawer: CustomDrawer(),
      body: Consumer<GameRoomProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => CreateRoomScreen(
                            gameName: widget.gameName,
                          )));
                },
                child: const Text("Create room"),
              ),
              StreamBuilder(
                stream: provider.getRooms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No rooms found.'));
                  } else {
                    final rooms = snapshot.data;
                    return Container(
                      height: 285,
                      child: ListView.builder(
                        itemCount: rooms!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              print(rooms[index].roomUser);
                              CollectionReference _roomCollection =
                                  FirebaseFirestore.instance
                                      .collection('rooms');
                              QuerySnapshot snapshot = await _roomCollection
                                  .doc(rooms[index].documentId)
                                  .collection('roomUser')
                                  .get();

                              // ignore: use_build_context_synchronously
                              provider.showAlertDialog(
                                  context,
                                  rooms[index].roomName,
                                  rooms[index].documentId,
                                  rooms[index].roomSize,
                                  snapshot.docs,
                                  rooms[index].roomCreator
                                  );
                            },
                            child: ListTile(
                              leading: Text(rooms[index].roomCreator),
                              title: Text(rooms[index].roomName),
                              subtitle: Text(rooms[index].roomDescription),
                              trailing: StreamBuilder<int>(
                                stream: provider.getRoomUserCountStream(
                                    rooms[index].documentId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text("Loading...");
                                  }
                                  if (snapshot.hasError) {
                                    return Text("Error");
                                  }
                                  int roomUserCount = snapshot.data ?? 0;
                                  return Text(
                                      "$roomUserCount/${rooms[index].roomSize}");
                                },
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
      ),
    );
  }
}
