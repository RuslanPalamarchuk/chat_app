import 'package:chat_app/models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageListTile extends StatelessWidget {
  final ChatModel chatModel;

  MessageListTile(this.chatModel, {super.key});

  final currentUserID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: chatModel.userId == currentUserID
                ? const Radius.circular(15)
                : Radius.zero,
            bottomRight: chatModel.userId == currentUserID
                ? Radius.zero
                : const Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: chatModel.userId == currentUserID
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: chatModel.userId == currentUserID
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Text(
                "By ${chatModel.userName}",
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                chatModel.message,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
