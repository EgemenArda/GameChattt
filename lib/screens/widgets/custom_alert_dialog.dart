import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {Key? key, required this.title, required this.content})
      : super(key: key);
  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.8),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black87),
      ),
      content: Text(
        content,
        style: const TextStyle(color: Colors.black54),
      ),
      actions: <Widget>[
        TextButton(
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
      ],
    );
  }
}
