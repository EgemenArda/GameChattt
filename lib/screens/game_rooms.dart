import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/profile_proivder.dart';
import 'package:game_chat_1/screens/create_room_screen.dart';
import 'package:game_chat_1/screens/widgets/container_with_gradient.dart';
import 'package:game_chat_1/screens/widgets/custom_bottom_navigation_bar_2.dart';
import 'package:game_chat_1/screens/widgets/custom_elevated_buton.dart';
import 'package:game_chat_1/services/connection_check.dart';
import 'package:game_chat_1/services/firestore_services.dart';
import 'package:provider/provider.dart';

import '../providers/game_room_provider.dart';
import 'widgets/custom_drawer.dart';

class GameRooms extends StatefulWidget {
  const GameRooms({super.key, required this.gameName, required this.gameImage});

  final String gameName;
  final String gameImage;

  @override
  State<GameRooms> createState() => _GameRoomsState();
}

class _GameRoomsState extends State<GameRooms> {
  @override
  void initState() {
    super.initState();
  }

  FirestoreService firestoreService = FirestoreService();

  @override
  @override
  Widget build(BuildContext context) {
    return ConnectionCheck(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          flexibleSpace: const Image(
            image: AssetImage(
              'assets/images/background.jpg',
            ),
            fit: BoxFit.cover,
          ),
          toolbarHeight: 125,
          backgroundColor: Colors.transparent,
          elevation: 0,
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
        drawer: const CustomDrawer(),
        body: Stack(
          children: [
            Consumer<GameRoomProvider>(
              builder: (context, provider, child) {
                return ContainerWithGradient(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder(
                        stream: provider.getRooms(widget.gameName),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(child: Text('No rooms found.'));
                          } else {
                            final rooms = snapshot.data;
                            return SafeArea(
                              child: SizedBox(
                                height: 400,
                                child: ListView.builder(
                                  itemCount: rooms!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () async {
                                        CollectionReference roomCollection =
                                            FirebaseFirestore.instance
                                                .collection('rooms');
                                        QuerySnapshot snapshot =
                                            await roomCollection
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
                                            rooms[index].roomCreator,
                                            rooms[index].roomType,
                                            rooms[index].roomCode);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent
                                              .withOpacity(0.4),
                                          border: Border.all(
                                              width: 2,
                                              color: Colors.transparent
                                                  .withOpacity(0.7)),
                                        ),
                                        child: ListTile(
                                          leading: rooms[index].roomType ==
                                                  "Private"
                                              ? const Icon(Icons.lock_outline)
                                              : const Icon(
                                                  Icons.lock_open_outlined),
                                          title: Text(rooms[index].roomName),
                                          subtitle: Text(
                                              rooms[index].roomDescription),
                                          trailing: StreamBuilder<int>(
                                            stream:
                                                provider.getRoomUserCountStream(
                                                    rooms[index].documentId),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Text("Loading...");
                                              }
                                              if (snapshot.hasError) {
                                                return const Text("Error");
                                              }
                                              int roomUserCount =
                                                  snapshot.data ?? 0;
                                              return Text(
                                                  "$roomUserCount/${rooms[index].roomSize}");
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CustomElevatedButton(
          title: 'Create room',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => CreateRoomScreen(
                      gameName: widget.gameName,
                    )));
          },
        ),
        bottomNavigationBar: const CustomBottomNavigationBar2(),
      ),
    );
  }
}
