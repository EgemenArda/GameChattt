import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:game_chat_1/models/room_model.dart';
import 'package:game_chat_1/screens/chat_screen.dart';

class GameRoomProvider extends ChangeNotifier {
  Stream<List<Rooms>> getRooms() {
    final stream = FirebaseFirestore.instance.collection("rooms").snapshots();
    return stream.map((event) => event.docs.map((doc) {
          return Rooms.fromSnapshot(doc);
        }).toList());
  }

  Stream<int> getRoomUserCountStream(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('roomUser')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> showAlertDialog(
    context,
    roomName,
    roomId,
    roomSize,
    roomUsers,
    roomCreator,
  ) async {
    String user = FirebaseAuth.instance.currentUser!.uid;

    String currentUsername = await getUsernameFromUserId(user);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
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
              child: const Text('Yes'),
              onPressed: () async {
                var querySnapshot = await FirebaseFirestore.instance
                    .collection('rooms')
                    .doc(roomId)
                    .collection('roomUser')
                    .get();
                List<String> usernames = [];
                if (querySnapshot.docs.isNotEmpty) {
                  querySnapshot.docs.forEach((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    String username = data[
                        'username']; // Varsayılan alan adını kullanarak ayarlayın

                    usernames.add(username);
                  });

                  print("Usernames in the room: $usernames");
                } else {
                  print("No usernames found in the room.");
                }
                print(usernames);
                if (usernames.contains(currentUsername)) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ChatScreen(
                      roomId: roomId, // Oda belgesinin ID'sini geçir
                      roomName: roomName,
                      roomCreator: roomCreator,
                    ),
                  ));
                } else {
                  if (roomUsers.length >= roomSize) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error!!"),
                          content: const Text("this room is full!"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    FirebaseFirestore.instance
                        .collection("rooms")
                        .doc(roomId)
                        .collection("roomUser")
                        .add({'username': currentUsername});

                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ChatScreen(
                        roomId: roomId, // Oda belgesinin ID'sini geçir
                        roomName: roomName,
                        roomCreator: roomCreator,
                      ),
                    ));
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
