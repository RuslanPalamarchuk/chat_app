import 'package:chat_app/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../widgets/message_list_tile.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final currentUserID =  FirebaseAuth.instance.currentUser!.uid;

  String _message = "";

  late TextEditingController _textEditingController;


  @override
  void initState() {
    _textEditingController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context)!.settings.arguments as Post;

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .doc(post.id)
                    .collection("comments").orderBy('timeStamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.none) {
                    return const Center(child: Text("Loading..."));
                  }
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        final QueryDocumentSnapshot doc =
                            snapshot.data!.docs[index];

                        final ChatModel chatModel = ChatModel(
                            userName: doc["userName"],
                            userId: doc["userID"],
                            message: doc["message"],
                            timestamp: doc["timeStamp"]);
                        return Align(
                            alignment: chatModel.userId ==
                                    currentUserID
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: MessageListTile(chatModel));
                      });
                },
              ),
            ),
            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _textEditingController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: "Enter message",
                      ),
                      onChanged: (value) {
                        _message = value;
                      },
                    ),
                  )),
                  IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("posts")
                            .doc(post.id)
                            .collection("comments")
                            .add({
                              "userID": FirebaseAuth.instance.currentUser!.uid,
                              "userName": FirebaseAuth
                                  .instance.currentUser!.displayName,
                              "message": _message,
                              "timeStamp": Timestamp.now(),
                            })
                            .then((value) => print("chat doc added"))
                            .catchError((onError) => print(
                                "Error has occured while adding chat doc"));

                        _textEditingController.clear();

                        setState(() {
                          _message = "";
                        });
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
