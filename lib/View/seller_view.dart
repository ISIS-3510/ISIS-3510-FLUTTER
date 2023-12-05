import 'package:flutter/material.dart';
import 'package:unishop/View/login.dart';
import 'package:unishop/Model/DAO/dao.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Seller extends StatefulWidget {
  @override
  _SellerState createState() => _SellerState();
}

class _SellerState extends State<Seller> {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var seller_username = prefs.getString('seller_username') ?? "";

    var infoSeller = await daoSearchUserByUsername(seller_username);

    setState(() {
      userDegree = infoSeller["degree"];
      userEmail = infoSeller["email"];
      userId = infoSeller["id"];
      userName = infoSeller["name"];
      userPassword = infoSeller["password"];
      userPhone = infoSeller["phone"];
      userUsername = infoSeller["username"];
    });
  }

  void call() async {
    var phoneNumber = '+57' + userPhone;
    launch('tel://$phoneNumber');
  }

  void showAlert(String title, String message, Color backgroundColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            width: 100,
            height: 40,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(message),
                  // Aquí puedes agregar más widgets si es necesario
                ],
              ),
            ),
          ),
          backgroundColor: backgroundColor,
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                    color: Colors.white), // Cambia el color del texto a blanco
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Custom toolbar height
        automaticallyImplyLeading:
            false, // We will manually add a leading button
        backgroundColor: Colors.white,
        title: Text(
          userName,
          style: TextStyle(
              color: Colors.black, // Title text color
              fontWeight: FontWeight.bold,
              fontSize: 28),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios, // Use the iOS style back icon
            color: Colors.blue, // Icon color
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 0, // No padding at the top
          left: 20, // 20 pixels of padding on the left
          right: 20, // 20 pixels of padding on the right
          bottom: 20, // 20 pixels of padding at the bottom
        ),
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
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Personal Information',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            SizedBox(height: 5),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Username: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  userUsername,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Email: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Phone: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  userPhone,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Degree: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  userDegree,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      call();
                    }, // Call the help function here
                    child: Text('Contact Seller'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void showAlertLogOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log out"),
          content: Text("Are you sure you want to log out?"),
          backgroundColor: Colors.white, // Establece el color de fondo
          actions: <Widget>[
            TextButton(
              child: Text(
                'Log out',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // Aquí puedes agregar la lógica para cerrar la sesión
                Navigator.pushReplacement(
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
