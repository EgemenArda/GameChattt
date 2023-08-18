import 'package:flutter/material.dart';

class InternetConnectionFailed extends StatelessWidget {
  const InternetConnectionFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Check your connection!'),
      ),
    );
  }
}
