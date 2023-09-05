import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/friend_provider.dart';
import 'package:provider/provider.dart';

import '../services/status_service.dart';

class UserPageScreen extends StatelessWidget {
  final OnlineStatusService _onlineStatusService = OnlineStatusService();

  UserPageScreen(
      {super.key, required this.profilePicture, required this.username});

  String username;
  String profilePicture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<FriendsProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(profilePicture),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  child: StreamBuilder<String>(
                    stream: _onlineStatusService.onlineStatusStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String isOnline = snapshot.data!;
                        return Text(isOnline == 'false' ? 'Offline' : 'Online');
                      } else {
                        return const Text('...');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    provider.sendFriendRequestWithButton(context, username);
                  },
                  child: const Text('Send Friend Request'),
                ),
                Text(
                  username,
                  style: Theme.of(context).textTheme.headlineMedium,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
