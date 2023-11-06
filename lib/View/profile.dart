import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unishop/View/login.dart';
import 'package:unishop/widgets/floating_button.dart';
import 'dart:async';
import 'package:unishop/widgets/footer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unishop/Model/DAO/dao.dart';


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

  Future<Position> help() async{

    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      print(permission);
      if(permission == LocationPermission.denied){
        print("eeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrror");
        openAppSettings();
        return Future.error("error");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    
    Position position = await help();
    print(position.latitude);
    print(position.longitude);

    var msj = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";

    showAlert("Alert sent", msj, Colors.red);

    daoCreateAlert(position.latitude.toString(), position.latitude.toString(), userId);

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
      floatingActionButton: FloatingButton(contextButton: context),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            SizedBox(height: 5),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Username: ',
                  style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.black,),
                  
                ),
                Text(userUsername,
                style: TextStyle(
                  color: Colors.black,
                ),),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Email: ',
                  style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.black),
                ),
                Text(userEmail,
                style: TextStyle(
                  color: Colors.black,
                ),),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Phone: ',
                  style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.black,),
                ),
                Text(userPhone,
                style: TextStyle(
                  color: Colors.black,
                ),),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Degree: ',
                  style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.black,),
                ),
                Text(userDegree,
                style: TextStyle(
                  color: Colors.black,
                ),),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'In Trouble?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
              color: Colors.black,),
            ),
            SizedBox(height: 10),
            Text(
              'Ask for help!',
              style: TextStyle(fontSize: 16,
              color: Colors.black,),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){ getCurrentLocation();}, // Call the help function here
                    child: Text('HELP!'),
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
            Text(
              '* You must allow UniShop to access your location',
              style: TextStyle(fontSize: 12,
              color: Colors.black,),
    
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: showAlertLogOut, // Call the logout function here
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
      bottomNavigationBar: Footer(currentIndex: 4, contextFooter: context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked
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
              child: Text('Log out', style: TextStyle(color: Colors.red),),
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
