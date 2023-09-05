import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/container_with_gradient.dart';
import 'package:game_chat_1/screens/widgets/custom_app_bar.dart';
import 'package:game_chat_1/screens/widgets/custom_drawer.dart';
import 'package:game_chat_1/services/connection_check.dart';
import 'package:provider/provider.dart';

import '../api/apis.dart';
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
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    APIs.getFirebaseMessagingToken();
    // FirebaseApi().initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileScreenProvider>(context).updateTheImageNow();
    return ConnectionCheck(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: CustomAppBar(
            title: 'Home Screen',
            imageUrl: (Provider.of<ProfileScreenProvider>(context).userImage),
          ),
        ),
        drawer: const CustomDrawer(),
        body: ContainerWithGradient(
          child: Consumer<HomePageProvider>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                child: SizedBox(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
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
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          borderOnForeground: true,
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
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
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
