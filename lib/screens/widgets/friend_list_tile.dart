import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/dm_create_provider.dart';
import 'package:game_chat_1/screens/user_page.dart';
import 'package:provider/provider.dart';

class FriendListTile extends StatelessWidget {
  const FriendListTile(
      {Key? key,
      required this.friendsName,
      required this.friendsImage,
      required this.index})
      : super(key: key);

  final String friendsName;
  final String friendsImage;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => UserPageScreen(
                        profilePicture: friendsImage, username: friendsName)));
              },
              child: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(friendsImage),
                backgroundColor: Colors.transparent,
                // child: Container(
                //   height: 30,
                //   width: 30,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.green,
                //   ),
                // ),
                ///To Do child conteiner positonal olarak ayarlanacak sol alt ya da sag altta cıkacak
                ///kullanıcı statusune göre renk degiştirecek
              ),
            ),
          ],
        ),
        title: Text(friendsName,
            style: const TextStyle(
              fontSize: 24,
            )),
        subtitle: const Text('online'),
        onTap: () {},

        ///onTab dm göndersin
        onLongPress: () {},

        ///onLongPress infotu acsın
        ///infoda remove olsun
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () async {
                  Future<String> getUsernameFromUserId(String userId) async {
                    DocumentSnapshot userSnapshot = await FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(userId)
                        .get();

                    if (userSnapshot.exists) {
                      Map<String, dynamic>? userData =
                          userSnapshot.data() as Map<String, dynamic>?;
                      if (userData != null &&
                          userData.containsKey('username')) {
                        return userData['username'];
                      } else {
                        return 'Username Not Found';
                      }
                    } else {
                      return 'Unknown User';
                    }
                  }

                  String creatorUsername = await getUsernameFromUserId(
                      FirebaseAuth.instance.currentUser!.uid);

                  // ignore: use_build_context_synchronously
                  Provider.of<DmCreateProvider>(context, listen: false)
                      .checkAndCreateDMRoom(
                          creatorUsername, friendsName, context, friendsImage);
                },
                icon: const Icon(Icons.mail_outline)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_forever_outlined)),
          ],
        ));
  }
}
