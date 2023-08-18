import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  var onPressed;

  CustomElevatedButton({Key? key, required this.title, this.onPressed})
      : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer),
      child: Text(title),
    );
  }
}
