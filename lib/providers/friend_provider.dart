import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsProvider extends ChangeNotifier {
  TextEditingController friendUsernameController = TextEditingController();

  Future<void> _sendFriendRequest(context) async {
    final friendUsername = friendUsernameController.text.trim();

    if (friendUsername.isEmpty) {
      return;
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: friendUsername)
        .get();
    if (querySnapshot.docs.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('User Not Found'),
            content: const Text('No user with provided name exists'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    String friendUserId = querySnapshot.docs[0].id;
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendUserId)
        .collection('pendingRequests')
        .doc(currentUserId)
        .set({
      'timestamp': FieldValue.serverTimestamp(),
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Friend Request Sent'),
          content: Text('Friend request sent to $friendUsername'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showFriendsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Friends'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: friendUsernameController,
                decoration: const InputDecoration(labelText: 'Friends Username'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _sendFriendRequest(context);
                },
                child: const Text('Send Friend Request'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> acceptFriendRequest(String pendingUserId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .doc(pendingUserId)
        .set({});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(pendingUserId)
        .collection('friends')
        .doc(currentUserId)
        .set({});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(pendingUserId)
        .collection('pendingRequests')
        .doc(currentUserId)
        .delete();
  }

  Future<void> rejectFriendRequest(String pendingUserId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('pendingRequests')
        .doc(pendingUserId)
        .delete();
  }

}
