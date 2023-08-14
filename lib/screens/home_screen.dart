import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/homepage_provider.dart';
import 'game_rooms.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
      body: Consumer<HomePageProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: SizedBox(
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                  ),
                  itemCount: provider.games.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return GameRooms(
                              gameName: provider.games[index].name,
                            );
                          },
                        ));
                      },
                      child: Card(
                        color: Colors.amber,
                        child: Center(child: Text(provider.games[index].name)),
                      ),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
