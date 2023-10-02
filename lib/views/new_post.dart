import 'package:flutter/material.dart';

class NewPost extends StatelessWidget {
  const NewPost ({super.key});

  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
    );
  }
}