import 'package:flutter/material.dart';
import 'package:unishop/View/user_posts.dart';

class FloatingButton extends StatelessWidget{
  const FloatingButton ({super.key, required this.contextButton});
  final BuildContext contextButton;

  @override
  Widget build(BuildContext context) { 
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Visibility(
      visible: !keyboardIsOpen,
      child: FloatingActionButton(
          onPressed: () {
            Navigator.of(contextButton).pushReplacement(
                MaterialPageRoute(builder: (ctx) => UserPostsView()));
          },
          tooltip: 'Increment',
          backgroundColor: Colors.black,
          elevation: 4.0,
          child: Icon(Icons.add)),
    );
  }
}