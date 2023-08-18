import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/profile_proivder.dart';
import 'package:game_chat_1/screens/friends_screen.dart';
import 'package:game_chat_1/screens/myrooms_screen.dart';
import 'package:game_chat_1/screens/profile_screen.dart';
import 'package:game_chat_1/screens/register_screen.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String username = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _getUserName() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        var userName = userSnapshot['username'];
        setState(() {
          username = userName;
        });
      } else {
        print('User data not found in Firestore.');
      }
    } else {
      print('User is not logged in.');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  void signOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const AuthScreen()));
    } catch (error) {
      print('error geldi $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      backgroundColor: Color.fromRGBO(44, 8, 78, 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          CircleAvatar(
            backgroundImage: NetworkImage(
                Provider.of<ProfileScreenProvider>(context).userImage),
            radius: 50,
          ),
          const SizedBox(height: 10),
          Text(
            username,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          Text(
            FirebaseAuth.instance.currentUser!.email.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (BuildContext context, index) {
              return InkWell(
                onTap: () {
                  if (index == 3) {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) =>
                                MyRoomsScreen(username: username)));
                  } else if (index == 2) {
                    Provider.of<ProfileScreenProvider>(context, listen: false)
                        .checkEmailVerification();
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) =>
                                ProfileScreen(username: username)));
                  } else if (index == 4) {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const FriendsScreen()));
                  }
                },
                child: ListTile(
                  leading: index == 0
                      ? const Icon(Icons.settings)
                      : index == 1
                          ? const Icon(Icons.notifications)
                          : index == 2
                              ? const Icon(Icons.person)
                              : index == 3
                                  ? const Icon(Icons.home)
                                  : index == 4
                                      ? const Icon(Icons.people_alt)
                                      : const Icon(Icons.people_alt),
                  title: index == 0
                      ? const Text('Setting')
                      : index == 1
                          ? const Text('Notifications')
                          : index == 2
                              ? const Text('Profile')
                              : index == 3
                                  ? const Text('My Rooms')
                                  : index == 4
                                      ? const Text('Friends')
                                      : const Text('Friends'),
                ),
              );
            },
          ),
          TextButton.icon(
              onPressed: () {
                signOut(context);
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: const Text("Sign Out"))
        ],
      ),
    );
  }
}
