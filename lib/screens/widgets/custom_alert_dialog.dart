import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.2),
      title: const Text('Login error!'),
      content: const Text('Please dont leave fields empty!'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(14),
            child: const Text('Okay'),
          ),
        ),
      ],
    );
  }
}
