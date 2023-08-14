import 'package:flutter/material.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key, required this.gameName});
  final String gameName;
  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  int selectedNumber = 1; // Varsayılan seçilen sayı 1
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create ${widget.gameName} room"),
        centerTitle: true,
      ),
      body: Center(
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
                  decoration: InputDecoration(labelText: "Room Name"),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Room Description"),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Room Size:",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(width: 10),
                    DropdownButton<int>(
                      value: selectedNumber,
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedNumber = newValue!;
                        });
                      },
                      items:
                          List<DropdownMenuItem<int>>.generate(10, (int index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text((index + 1).toString()),
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Create Room"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
