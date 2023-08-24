import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/custom_drawer.dart';
import 'package:game_chat_1/services/connection_check.dart';
import 'package:provider/provider.dart';

import '../providers/homepage_provider.dart';
import '../providers/profile_proivder.dart';
import 'game_rooms.dart';

class HomeScreen extends StatefulWidget with WidgetsBindingObserver {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

 

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileScreenProvider>(context).updateTheImageNow();
    return ConnectionCheck(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Image(
            image: AssetImage(
              'assets/images/background.jpg',
            ),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) => CircleAvatar(
                backgroundImage: NetworkImage(
                    Provider.of<ProfileScreenProvider>(context).userImage),
                child: TextButton(
                  child: const Text(''),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
          ),
          centerTitle: true,
        ),
        drawer: const CustomDrawer(),
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
                        // final filteredRooms = provider.games
                        //     .where((game) =>
                        //         game.name == provider.games[index].name)
                        //     .toList();
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
