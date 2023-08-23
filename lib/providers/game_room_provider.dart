import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/models/room_model.dart';
import 'package:game_chat_1/screens/chat_screen.dart';

import '../screens/widgets/custom_alert_dialog.dart';

class GameRoomProvider extends ChangeNotifier {
  Stream<List<Rooms>> getRooms(gameName) {
    final stream = FirebaseFirestore.instance
        .collection("rooms")
        .where("game_name", isEqualTo: gameName)
        .snapshots();

    return stream.asyncMap((event) async {
      final roomFutures = event.docs.map((doc) async {
        final room = Rooms.fromSnapshot(doc);
        final roomUserCollection = doc.reference.collection("roomUser");

        final roomUserSnapshot = await roomUserCollection.get();
        if (roomUserSnapshot.docs.isEmpty) {
          await doc.reference.delete();
          return null;
        }

        return room;
      }).toList();

      final rooms = await Future.wait(roomFutures);
      return rooms.whereType<Rooms>().toList(); // Filter out null values
    });
  }

  Stream<List<Rooms>> getMyRooms(String username) {
    final stream = FirebaseFirestore.instance
        .collectionGroup('roomUser')
        .where('username', isEqualTo: username)
        .snapshots();

    return stream.asyncMap((event) async {
      List<Rooms> myRooms = [];

      for (var doc in event.docs) {
        String roomPath = doc.reference.parent.parent!.id;
        DocumentSnapshot<Map<String, dynamic>> roomSnapshot =
            await FirebaseFirestore.instance
                .collection('rooms')
                .doc(roomPath)
                .get();

        if (roomSnapshot.exists) {
          myRooms.add(Rooms.fromSnapshot(roomSnapshot));
        }
      }

      return myRooms;
    });
  }

  Stream<int> getRoomUserCountStream(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('roomUser')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> showAlertDialog(context, roomName, roomId, roomSize, roomUsers,
      roomCreator, roomType, roomCode) async {
    String user = FirebaseAuth.instance.currentUser!.uid;

    String currentUsername = await getUsernameFromUserId(user);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.4),
          title: const Text('Join room?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want to join this room?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: const Text('Yes')),
              onPressed: () async {
                Navigator.of(context).pop();

                var querySnapshot = await FirebaseFirestore.instance
                    .collection('rooms')
                    .doc(roomId)
                    .collection('roomUser')
                    .get();
                List<String> usernames = [];
                if (querySnapshot.docs.isNotEmpty) {
                  for (var doc in querySnapshot.docs) {
                    Map<String, dynamic> data = doc.data();
                    String username = data['username'];

                    usernames.add(username);
                  }

                  print("Usernames in the room: $usernames");
                } else {
                  print("No usernames found in the room.");
                }
                print(usernames);
                if (usernames.contains(currentUsername)) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ChatScreen(
                      roomId: roomId,
                      roomName: roomName,
                      roomCreator: roomCreator,
                      roomType: roomType,
                      roomCode: roomCode,
                      roomUser: usernames,
                    ),
                  ));
                } else {
                  if (roomUsers.length >= roomSize) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomAlertDialog(
                          title: 'error',
                          content: "this room is full!",
                        );
                      },
                    );
                  } else {
                    if (roomType == "Private") {
                      String enteredPassword =
                          // ignore: use_build_context_synchronously
                          await showDialog(
                        context: context,
                        builder: (context) {
                          String password = '';
                          return AlertDialog(
                            title: Text('Private Room Password'),
                            content: TextField(
                              onChanged: (value) {
                                password = value;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Enter the password',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context, password); // Şifreyi döndür
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          );
                        },
                      );

                      if (enteredPassword == roomCode) {
                        FirebaseFirestore.instance
                            .collection("rooms")
                            .doc(roomId)
                            .collection("roomUser")
                            .add({'username': currentUsername});
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ChatScreen(
                            roomId: roomId,
                            roomName: roomName,
                            roomCreator: roomCreator,
                            roomType: roomType,
                            roomCode: roomCode,
                            roomUser: usernames,
                          ),
                        ));
                      } else {
                        print("Error");
                      }
                    } else {
                      FirebaseFirestore.instance
                          .collection("rooms")
                          .doc(roomId)
                          .collection("roomUser")
                          .add({'username': currentUsername});
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ChatScreen(
                          roomId: roomId,
                          roomName: roomName,
                          roomCreator: roomCreator,
                          roomType: roomType,
                          roomCode: roomCode,
                          roomUser: usernames,
                        ),
                      ));
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> getUsernameFromUserId(String userId) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      if (userData != null && userData.containsKey('username')) {
        return userData['username'];
      } else {
        return 'Username Not Found';
      }
    } else {
      return 'Unknown User';
    }
  }
}
