import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

Future<void> getRoomUsers(String roomId) async {
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
  }
}

late CurrentUser _users;
CurrentUser get users => _users;
set users(user) {
  _users = user;
}

Future<void> getUserFromUserId(String userId) async {
  userId = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (userSnapshot.exists) {
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;
    // print(userData);

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
