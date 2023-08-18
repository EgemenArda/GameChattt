import 'package:flutter/material.dart';
import 'package:game_chat_1/services/connection_check.dart';
import 'package:provider/provider.dart';

import '../providers/homepage_provider.dart';
import 'game_rooms.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectionCheck(
      child: Scaffold(
        body: Container(
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
          child: Consumer<HomePageProvider>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                child: SizedBox(
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: provider.games.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return GameRooms(
                                  gameName: provider.games[index].name,
                                  gameImage: provider.games[index].image,
                                );
                              },
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.network(
                                      provider.games[index].image,
                                      fit: BoxFit.contain),
                                ),
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
      ),
    );
  }
}
