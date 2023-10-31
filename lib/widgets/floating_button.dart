import 'package:flutter/material.dart';
import 'package:unishop/View/user_posts.dart';

class FloatingButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) { 
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Visibility(
      visible: !keyboardIsOpen,
      child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserPostsView()));
          },
          tooltip: 'Increment',
          backgroundColor: Colors.black,
          elevation: 4.0,
          child: Icon(Icons.add)),
    );
  }
}