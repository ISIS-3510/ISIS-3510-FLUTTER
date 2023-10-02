import 'package:flutter/material.dart';

class NewPostView extends StatelessWidget {
  const NewPostView ({super.key});

  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
    );
  }
}