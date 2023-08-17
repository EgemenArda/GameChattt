import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreenProvider extends ChangeNotifier {
  String user = FirebaseAuth.instance.currentUser!.uid;

  ProfileScreenProvider() {
    getImageFromUserId(user);
  }
  final formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> validateForm() async {
    if (formKey.currentState!.validate()) {
      User? user = auth.currentUser;
      return users
          .doc(user!.uid)
          .update({'username': usernameController.text})
          .then((value) => print('User updated'))
          .catchError((error) => print('Failed to update user $error'));
    }
    notifyListeners();
  }

  String userImage = "";

  void getImageFromUserId(String userId) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      userImage = userData!["image_url"];
    }
    notifyListeners();
  }
}
