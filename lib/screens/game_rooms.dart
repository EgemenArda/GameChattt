import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/profile_proivder.dart';
import 'package:game_chat_1/screens/create_room_screen.dart';
import 'package:game_chat_1/screens/home_screen.dart';
import 'package:game_chat_1/screens/widgets/custom_elevated_buton.dart';
import 'package:game_chat_1/services/connection_check.dart';
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
  Widget build(BuildContext context) {
    return ConnectionCheck(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          flexibleSpace: Image(
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
        drawer: CustomDrawer(),
        body: Stack(
          children: [
            Consumer<GameRoomProvider>(
              builder: (context, provider, child) {
                return Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.mirror,
                        colors: [
                          Color.fromRGBO(44, 8, 78, 0.8),
                          Color.fromRGBO(2, 5, 28, 0.8)
                        ]),
                  ),
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
                            // final filteredRooms = snapshot.data?.where(
                            //     (game) => game.gameName == widget.gameName);
                            // print(filteredRooms);
                            // print(rooms);

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
                                          color: Colors.transparent.withOpacity(0.4),
                                          border: Border.all(width: 2, color: Colors.transparent.withOpacity(0.7)),
                                        ),
                                        child: ListTile(
                                          leading: rooms[index].roomType ==
                                                  "Private"
                                              ? Icon(Icons.lock_outline)
                                              : Icon(Icons.lock_open_outlined),
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
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black12,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context);
            }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.gamepad_outlined), label: 'Games'),
            BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined), label: 'Messages')
          ],
        ),
      ),
    );
  }
}
