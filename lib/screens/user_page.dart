import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/friend_provider.dart';
import 'package:provider/provider.dart';

class UserPageScreen extends StatelessWidget {
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
                Container(
                  width: 100, // Genişliği istediğiniz gibi ayarlayın
                  height: 100, // Yüksekliği istediğiniz gibi ayarlayın
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(profilePicture),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.sendFriendRequest(context);
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
