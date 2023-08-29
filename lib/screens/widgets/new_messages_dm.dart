import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessagesDm extends StatefulWidget {
  final String roomId;
  final FocusNode focusNode;
  final replyMessage;
  final VoidCallback onCancelReply;
  const NewMessagesDm(
      {super.key,
      required this.roomId,
      required this.focusNode,
      required this.onCancelReply,
      required this.replyMessage});

  @override
  State<NewMessagesDm> createState() => _NewMessagesDmState();
}

class _NewMessagesDmState extends State<NewMessagesDm> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance
        .collection('direct-messages')
        .doc(widget.roomId)
        .collection('messages')
        .add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url']
    });
  }

  @override
  Widget build(BuildContext context) {
    final isReplying = widget.replyMessage != null;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          // if (isReplying) buildReply(),
          Expanded(
            child: TextField(
              focusNode: widget.focusNode,
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: "Send a message..."),
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }

  // Widget buildReply() => Container(
  //       padding: EdgeInsets.all(8),
  //       decoration: BoxDecoration(
  //           color: Colors.grey.withOpacity(0.2),
  //           borderRadius: const BorderRadius.only(
  //             topLeft: Radius.circular(12),
  //             topRight: Radius.circular(24),
  //           )),
  //       child: ReplyMessageWidget(
  //           message: widget.replyMessage, onCancelReply: widget.onCancelReply),
  //     );
}
