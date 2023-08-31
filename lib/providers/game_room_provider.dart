import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/models/room_model.dart';
import 'package:game_chat_1/models/user_model.dart';
import 'package:game_chat_1/screens/chat_screen.dart';
import 'package:game_chat_1/services/firestore_services.dart';

import '../screens/widgets/custom_alert_dialog.dart';

class GameRoomProvider extends ChangeNotifier {
  final FirestoreService firestoreService = FirestoreService();

  Stream<List<Rooms>> getRooms(gameName) {
    final stream = FirebaseFirestore.instance
        .collection("rooms")
        .where("game_name", isEqualTo: gameName)
        .snapshots();

    return stream.map((event) => event.docs.map((doc) {
          return Rooms.fromSnapshot(doc);
        }).toList());
  }

  Stream<int> compareAfterDate(String roomId) async* {
    DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('lastDate')
            .doc(roomId)
            .get();
    Timestamp before = userDocSnapshot.data()?['left'];
    QuerySnapshot<Map<String, dynamic>> messagesAfterDate =
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .collection('messages')
            .where('createdAt', isGreaterThan: before)
            .get();

    yield messagesAfterDate.docs.length;
  }

  Stream<List<String>> getUsersInRoom(String roomId, String owner) {
    final stream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('roomUser')
        .snapshots();

    return stream.map((querySnapshot) {
      List<String> usersInRoom = [];
      for (var doc in querySnapshot.docs) {
        usersInRoom.add(doc.data()['username']);
      }

      usersInRoom.remove(owner);
      return usersInRoom;
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

  Stream<List<Rooms>> getMyDms(String username) {
    final stream = FirebaseFirestore.instance
        .collectionGroup('dmPeople')
        .where('username', isEqualTo: username)
        .snapshots();

    return stream.asyncMap((event) async {
      List<Rooms> myRooms = [];

      for (var doc in event.docs) {
        String roomPath = doc.reference.parent.parent!.id;
        DocumentSnapshot<Map<String, dynamic>> roomSnapshot =
            await FirebaseFirestore.instance
                .collection('direct-messages')
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
                firestoreService
                    .getUserFromUserId(FirebaseAuth.instance.currentUser!.uid);
                Navigator.of(context).pop();

                var querySnapshot = await FirebaseFirestore.instance
                    .collection('rooms')
                    .doc(roomId)
                    .collection('roomUser')
                    .get();
                List<String> usernames = [];
                bool isUsernameAlreadyRegistered = false;
                if (querySnapshot.docs.isNotEmpty) {
                  for (var doc in querySnapshot.docs) {
                    Map<String, dynamic> data = doc.data();
                    String username = data['username'];

                    usernames.add(username);
                    if (username == _users.username) {
                      isUsernameAlreadyRegistered = true;
                    }
                  }
                }
                if (!isUsernameAlreadyRegistered) {
                  firestoreService.addRoomUser(roomId, _users);
                }
                if (usernames.contains(_users.username)) {
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
                            title: const Text('Private Room Password'),
                            content: TextField(
                              onChanged: (value) {
                                password = value;
                              },
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Enter the password',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, password);
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          );
                        },
                      );

                      if (enteredPassword == roomCode) {
                        await firestoreService.addRoomUser(roomId, _users);
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
                      await firestoreService.addRoomUser(roomId, _users);
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

  late CurrentUser _users;

  CurrentUser get users => _users;

  set users(user) {
    _users = user;
  }
//
//   Future<void> getUserFromUserId(String userId) async {
//     userId = FirebaseAuth.instance.currentUser!.uid;
//     DocumentSnapshot userSnapshot =
//         await FirebaseFirestore.instance.collection('users').doc(userId).get();
//
//     if (userSnapshot.exists) {
//       Map<String, dynamic>? userData =
//           userSnapshot.data() as Map<String, dynamic>?;
//       // print(userData);
//
//       if (userData != null) {
//         CurrentUser user = CurrentUser.fromMap(userData);
//
//         users = user;
//         print(user);
//       } else {
//         print('User data is null.');
//       }
//     } else {
//       print('User does not exist.');
//     }
//   }
// }
}
