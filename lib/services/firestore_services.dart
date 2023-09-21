import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class FirestoreService {
  final CollectionReference roomsCollection =
      FirebaseFirestore.instance.collection('rooms');

  Future<void> addRoomUser(String roomId, CurrentUser user) async {
    await roomsCollection.doc(roomId).collection('roomUser').add({
      'username': user.username,
      'fcmToken': user.fcmToken,
      'email': user.email,
      'image': user.image_url,
      'asdf': 'asdf',
    });
  }

  Future<QuerySnapshot> getRoomUsers(String roomId) async {
    return await roomsCollection.doc(roomId).collection('roomUser').get();
  }

  Future<void> getUserFromUserId(String userId) async {
    userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        CurrentUser user = CurrentUser.fromMap(userData);

        users = user;
        print(user);
      } else {
        print('User data is null.');
      }
    } else {
      print('User does not exist.');
    }
  }

  late CurrentUser _users;

  CurrentUser get users => _users;

  set users(user) {
    _users = user;
  }
}
