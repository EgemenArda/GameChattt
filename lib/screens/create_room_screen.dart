import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/create_room_provider.dart';
import 'package:game_chat_1/screens/game_rooms.dart';

import 'package:provider/provider.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key, required this.gameName});
  final String gameName;

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

List<String> roomType = ["Public", "Private"];

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  String currentOption = roomType[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create ${widget.gameName} room"),
        centerTitle: true,
      ),
      body: Consumer<CreateRoomProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: widget.gameName),
                      enabled: false,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Room Name"),
                      controller: provider.roomName,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Room Description"),
                      controller: provider.roomDescription,
                    ),
                    const SizedBox(height: 15),
                    ListTile(
                      title: const Text("Public"),
                      leading: Radio(
                        value: roomType[0],
                        groupValue: currentOption,
                        onChanged: (value) {
                          setState(() {
                            currentOption = value.toString();
                            provider.selectedRoomType = currentOption;

                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Private"),
                      leading: Radio(
                        value: roomType[1],
                        groupValue: currentOption,
                        onChanged: (value) {
                          setState(() {
                            currentOption = value.toString();
                            provider.selectedRoomType = currentOption;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Room Size:",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<int>(
                          value: provider.selectedNumber,
                          onChanged: (int? newValue) {
                            setState(() {
                              provider.selectedNumber = newValue!;
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(10,
                              (int index) {
                            return DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text((index + 1).toString()),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        provider.setGameName(widget.gameName);
                        provider.createRoom(context);
                      },
                      child: const Text("Create Room"),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
