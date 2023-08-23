import 'dart:io';
import 'package:game_chat_1/providers/profile_proivder.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/user_image_picker.dart';

import '../profile_screen.dart';

class CustomImagePicker extends StatefulWidget {
  const CustomImagePicker({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  late File selectedImagefile;

  Future uploadImage() async {
    var ref = FirebaseStorage.instance.ref().child("images").child("");

    File imageFile = selectedImagefile;
    var uploadTask = await ref.putFile(imageFile!);
    String ImageUrl = await uploadTask.ref.getDownloadURL();

    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users.doc(user!.uid).update(
      {
        'image_url': ImageUrl,
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    String user = FirebaseAuth.instance.currentUser!.uid;

    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.4),
      title: const Text(
        'Change your profile picture',
        style: TextStyle(fontSize: 20),
      ),
      content: SizedBox(
        height: 140,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserImagePicker(
              onPickImage: (File pickedImage) {
                selectedImagefile = pickedImage;
              },
            )
          ],
        ),
      ),
      actions: <Widget>[
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
              uploadImage();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(14),
              child: const Text('Okay'),
            ),
          ),
        ),
      ],
    );
  }
}
