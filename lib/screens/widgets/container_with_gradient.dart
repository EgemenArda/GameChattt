import 'package:flutter/material.dart';

class ContainerWithGradient extends StatelessWidget {
  const ContainerWithGradient({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomRight,
            tileMode: TileMode.mirror,
            colors: [
              Color.fromRGBO(44, 8, 78, 0.8),
              Color.fromRGBO(2, 5, 28, 0.8)
            ]),
      ),
      child: child,
    );
  }
}
