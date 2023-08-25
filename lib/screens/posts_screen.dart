import 'package:chat_app/bloc/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'create_post_screen.dart';

class PostsScreen extends StatefulWidget {
  static const String id = 'posts_screen';

  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Create Post
          IconButton(onPressed: () {
            final picker = ImagePicker();
            picker.pickImage(source: ImageSource.gallery, imageQuality: 40).then((xFile) {

              if(xFile != null) {
                final File file = File(xFile.path);

                Navigator.of(context).pushNamed(CreatePostScreen.id);
              }
            });

          }, icon: const Icon(Icons.add)),

          IconButton(onPressed: () {
            context.read<AuthCubit>().signOut();
          }, icon: Icon(Icons.logout)),
        ],
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Container();
      }),
    );
  }
}
