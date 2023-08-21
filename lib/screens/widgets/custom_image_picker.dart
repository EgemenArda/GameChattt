import 'dart:io';

import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/user_image_picker.dart';

class CustomImagePicker extends StatelessWidget {
  const CustomImagePicker(
      {Key? key, required this.title, required this.content})
      : super(key: key);
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.4),
      title: const Text('Select your profile picture'),
      content: Container(
        height: 200,
        child: Column(children: [
          Row(
            children: [
              UserImagePicker(
                onPickImage: (File pickedImage) {},
              )
            ],
          )
        ]),
      ),
      actions: <Widget>[
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
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
