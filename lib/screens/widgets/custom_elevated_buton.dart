import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  var onPressed;

  CustomElevatedButton({Key? key, required this.title, required this.onPressed})
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
