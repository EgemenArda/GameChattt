import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/home_screen.dart';

class AuthProvider extends ChangeNotifier {
  final _firebase = FirebaseAuth.instance;

  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKeyRegister = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  var isLogin = true;
  var isAuthenticating = false;
  var enteredEmail = '';
  var enteredPassword = '';

  bool checkedBool = false;

  var enteredUsername = '';
  File? selectedImage;

  register(context) async {
    formKeyRegister.currentState!.save();
    try {
      final userCredential = await _firebase.createUserWithEmailAndPassword(
          email: enteredEmail, password: enteredPassword);

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': enteredUsername,
        'email': enteredEmail,
        'image_url': "https://picsum.photos/200/300",
      });
      
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).collection('pendingRequests');
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).collection('pendingRequests').doc(userCredential.user!.uid).delete();
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).collection('friends');
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).collection('friends').doc(userCredential.user!.uid).delete();


      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const HomeScreen()));
    } on FirebaseAuthException catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Registration error!'),
          content: Text(error.message ?? 'Auth failed.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Container(
                color: Colors.green,
                padding: const EdgeInsets.all(14),
                child: const Text('Okay'),
              ),
            ),
          ],
        ),
      );
      isAuthenticating = false;
    }
  }

  void login(context) async {
    formKeyLogin.currentState!.save();
    try {
      final userCredential = await _firebase.signInWithEmailAndPassword(
          email: enteredEmail, password: enteredPassword);
      print('User logged in: ${userCredential.user?.email}');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const HomeScreen()));
    } on FirebaseAuthException {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login error!'),
          content: const Text(
              'Wrong email or password! Please correct and try again!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Container(
                color: Colors.green,
                padding: const EdgeInsets.all(14),
                child: const Text('Okay'),
              ),
            ),
          ],
        ),
      );
    }
    // Make sure to update state after catching the error
    notifyListeners();
  }
}
