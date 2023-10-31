import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unishop/View/login.dart';
import 'package:unishop/widgets/floating_button.dart';
import 'dart:async';
import 'package:unishop/widgets/footer.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userDegree = "";
  String userEmail = "";
  String userId = "";
  String userName = "";
  String userPassword = "";
  String userPhone = "";
  String userUsername = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userDegree = prefs.getString('user_degree') ?? "";
      userEmail = prefs.getString('user_email') ?? "";
      userId = prefs.getString('user_id') ?? "";
      userName = prefs.getString('user_name') ?? "";
      userPassword = prefs.getString('user_password') ?? "";
      userPhone = prefs.getString('user_phone') ?? "";
      userUsername = prefs.getString('user_username') ?? "";
    });
  }

  Future<void> help() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingButton(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        'https://www.w3schools.com/howto/img_avatar.png'), // Add your image URL here
                  ),
                  SizedBox(width: 20),
                  Text(
                    userName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(height: 5),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Username: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(userUsername),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Email: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(userEmail),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Phone: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(userPhone),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Degree: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(userDegree),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'In Trouble?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Ask for help!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: help, // Call the help function here
                    child: Text('HELP!'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '* You must allow UniShop to access your location',
              style: TextStyle(fontSize: 12),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: showAlert, // Call the logout function here
                child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(currentIndex: 4),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked
    );
  }

  void showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log out"),
          content: Text("Are you sure you want to log out?"),
          backgroundColor: Colors.white, // Establece el color de fondo
          actions: <Widget>[
            TextButton(
              child: Text('Log out', style: TextStyle(color: Colors.red),),
              onPressed: () {
                // Aquí puedes agregar la lógica para cerrar la sesión
                Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginView())); // Cierra la alerta
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra la alerta
              },
            ),
          ],
        );
      },
    );
  }

}
