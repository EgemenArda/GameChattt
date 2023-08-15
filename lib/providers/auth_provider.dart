import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final _firebase = FirebaseAuth.instance;

  TextEditingController phoneController = TextEditingController();
  final formKeyRegister = GlobalKey<FormState>();
  final formKeyLogin = GlobalKey<FormState>();
  var isLogin = true;
  var isAuthenticating = false;
  var enteredEmail = '';
  var enteredPassword = '';

  var enteredUsername = '';
  File? selectedImage;
  void register(context) async {
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
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Auth failed.'),
        ),
      );

      isAuthenticating = false;
    }
  }

  void login(context) {
    formKeyLogin.currentState!.save();
    try {
      final userCredential = _firebase.signInWithEmailAndPassword(
          email: enteredEmail, password: enteredPassword);
      print(userCredential);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      print(error.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Auth failed.'),
        ),
      );

      isAuthenticating = false;
    }
    notifyListeners();
  }
}
