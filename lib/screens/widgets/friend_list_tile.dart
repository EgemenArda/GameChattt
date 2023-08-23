import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_proivder.dart';

class FriendListTile extends StatelessWidget {
  const FriendListTile(
      {Key? key, required this.friendsName, required this.friendsImage})
      : super(key: key);

  final String friendsName;
  final String friendsImage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
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
          ],
        ),
        title: Text(friendsName,
            style: TextStyle(
              fontSize: 24,
            )),
        subtitle: Text('online'),
        onTap: () {},

        ///onTab dm göndersin
        onLongPress: () {},

        ///onLongPress infotu acsın
        ///infoda remove olsun
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.mail_outline)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_forever_outlined)),
          ],
        ));
  }
}
