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
      body: Container(
        decoration: const BoxDecoration(
            gradient: RadialGradient(
          colors: [Color(0xff2e2e2e), Color(0xff171717)],
          stops: [0, 1],
          center: Alignment.topLeft,
        )),
        child: Consumer<HomePageProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: SizedBox(
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
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
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Stack(
                            children: [
                              Image.network(provider.games[index].image),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            );
          },
        ),
      ),
    );
  }
}
