import 'package:flutter/material.dart';

class ChatInfo extends StatefulWidget {
  const ChatInfo({super.key, required this.owner});
  final String owner;

  @override
  State<ChatInfo> createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text("Owner: ${widget.owner}"),
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
