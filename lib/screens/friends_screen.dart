import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/friend_provider.dart';
import 'package:provider/provider.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<FriendsProvider>(
        builder: (context, provider, child) {
          return const SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
          );
        },
      ),
    );
  }
}
