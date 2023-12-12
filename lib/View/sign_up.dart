import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:unishop/Controller/sign_up_controller.dart';
import 'package:unishop/View/login.dart';
import 'package:connectivity/connectivity.dart';


//import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpController controller = SignUpController();
  TextEditingController nameController = TextEditingController();
  bool isValidNameText = true;

  TextEditingController userNameController = TextEditingController();
  bool isValidUserNameText = true;

  TextEditingController degreeController = TextEditingController();
  bool isValidDegreeText = false;

  TextEditingController phoneController = TextEditingController();
  bool isValidPhoneText = true;

  TextEditingController emailController = TextEditingController();
  bool isValidEmailText = true;

  TextEditingController passwordController = TextEditingController();
  bool isValidPasswordText = true;

  TextEditingController confirmPasswordController = TextEditingController();
  bool isValidConfirmPasswordText = true;

  String dropdownValue = 'Select your degree';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/headerSingUp.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 160,
              ),
              Container(
                margin: EdgeInsets.only(
                  right: 115.0,
                  top: 10,
                ),
                child: Text(
                  "Welcome to Unishop",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 40.0, top: 10, left: 40),
                child: Text(
                  "We’re so happy that you want to join us, now we need to validate your data and check if you’re eligible, so we will need the following data",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF98A2B3),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      errorText: isValidNameText ? null : 'Invalid Name',
                    ),
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.name,
                    onChanged: (newValue) {
                      setState(() {
                        isValidNameText = controller.isValidName(newValue);
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  margin: EdgeInsets.only(left: 35, right: 35),
                  child: TextField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      errorText:
                          isValidUserNameText ? null : 'Invalid Username',
                    ),
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.name,
                    onChanged: (newValue) {
                      setState(() {
                        isValidUserNameText =
                            controller.isValidUserName(newValue);
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  margin: EdgeInsets.only(left: 35, right: 35),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        isValidDegreeText = controller.isValidDegree(newValue);
                        print("Selected value: $dropdownValue");
                      });
                    },
                    items: <String>[
                      'Select your degree',
                      'ISIS',
                      'MATE',
                      'ADMIN',
                      'IIND',
                      'ARQUI',
                      'ARTE',
                      'DISE'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  margin: EdgeInsets.only(left: 35, right: 35),
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                      errorText: isValidPhoneText ? null : 'Invalid Phone',
                    ),
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.phone,
                    onChanged: (newValue) {
                      setState(() {
                        isValidPhoneText = controller.isValidPhone(newValue);
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  margin: EdgeInsets.only(left: 35, right: 35),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Uniandes Email',
                      border: OutlineInputBorder(),
                      errorText: isValidEmailText ? null : 'Invalid Email',
                    ),
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (newValue) {
                      setState(() {
                        isValidEmailText = controller.isValidEmail(newValue);
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  margin: EdgeInsets.only(left: 35, right: 35),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      errorText: isValidPasswordText
                          ? null
                          : 'Password must have 8 characters, capital letter, number and special character.',
                      errorStyle: TextStyle(fontSize: 8.9),
                    ),
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (newValue) {
                      setState(() {
                        isValidPasswordText =
                            controller.isValidPassword(newValue);
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  margin: EdgeInsets.only(left: 35, right: 35),
                  child: TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      errorText: isValidConfirmPasswordText
                          ? null
                          : 'Passwords do not match',
                    ),
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (newValue) {
                      setState(() {
                        isValidConfirmPasswordText =
                            controller.isValidConfirmPassword(
                                newValue, passwordController.text);
                      });
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 40.0, top: 10, left: 40),
                child: Text(
                  "by clicking on Sign Up you agree to the privacy policy and data consent.",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF98A2B3),
                  ),
                ),
              ),
              // Resto de tu contenido...
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (isValidNameText &&
                        isValidUserNameText &&
                        isValidDegreeText &&
                        isValidPhoneText &&
                        isValidEmailText &&
                        isValidPasswordText &&
                        isValidConfirmPasswordText) {
                      // Realizar la acción de signUp
                      signUp();
                    } else {
                      showAlert("Error", "Complete the fields correctly!",
                          Colors.red);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFC600),
                    fixedSize: Size(330, 50),
                  ),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navegar a la pantalla de inicio de sesión
                      Navigator.of(context).pop();
                    },
                    child: Text('Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlert(String title, String message, Color backgroundColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 100,
            height: 30,
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

  Future<void> signUp() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {

          final response = await controller.signUp(
            emailController.text,
            nameController.text,
            passwordController.text,
            phoneController.text,
            userNameController.text,
            dropdownValue);

        if (response.statusCode == 200) {
          // Registro exitoso
          showAlert("Good", "Account Created!", Color(0xFFFFC600));

          if (context.mounted){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginView(),
              ),
            );
          }

          final jsonResponse = json.decode(response.body);
          final userData = jsonResponse['data']['insert_users_one'];
          print("Registro exitoso: ${userData['name']}");

          //Navigator.of(context).pushNamed("/feed");
        } else if (response.statusCode == 400) {
          // Registro no exitoso debido a duplicación de username (u otro error)
          final jsonResponse = json.decode(response.body);
          showAlert("ERROR", 'The username, email and phone must be unique!',
              Colors.black);
          final errors = jsonResponse['errors'];
          final errorMessage = errors[0]['message'];
          print("Error en el registro: $errorMessage");

          // Puedes mostrar un mensaje de error o tomar otras medidas apropiadas
        } else {
          // Otra respuesta no esperada
          print("Error en la solicitud. Código de estado: ${response.statusCode}");
          print("Respuesta del servidor: ${response.body}");
        }

        }
        else{

      showAlert('Error', 'Connection error, check your wifi or mobile data network and try again.', Colors.grey);


        }

  }
}
