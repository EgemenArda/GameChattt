import 'package:flutter/material.dart';

import 'create_room_screen.dart';

class GameRooms extends StatefulWidget {
  const GameRooms({super.key, required this.gameName});
  final gameName;
  @override
  State<GameRooms> createState() => _GameRoomsState();
}

class _GameRoomsState extends State<GameRooms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.gameName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => CreateRoomScreen(
                          gameName: widget.gameName,
                        )));
              },
              child: const Text("Create room"),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 9,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    print("dadsa");
                  },
                  leading: CircleAvatar(),
                  title: Text(widget.gameName),
                  subtitle: Text("lorem lorem lorem lorem lorem lorem "),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
