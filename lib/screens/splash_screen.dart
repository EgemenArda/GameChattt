import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/wavy_text.dart';
import 'package:kartal/kartal.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: context.padding.onlyTopMedium,
              child: const WavyText(
                animatedText: "Game Chat",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
