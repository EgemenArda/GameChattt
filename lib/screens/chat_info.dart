import 'package:flutter/material.dart';

class ChatInfo extends StatelessWidget {
  const ChatInfo({super.key, required this.owner});
  final String owner;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Owner: ${owner}"),
            Container(
              height: 500,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return ;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}