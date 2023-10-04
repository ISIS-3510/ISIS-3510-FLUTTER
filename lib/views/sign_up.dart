import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController nameController = TextEditingController();
  bool isValidNameText = false;

  TextEditingController userNameController = TextEditingController();
  bool isValidUserNameText = false;

  TextEditingController degreeController = TextEditingController();
  bool isValidDegreeText = false;

  TextEditingController phoneController = TextEditingController();
  bool isValidPhoneText = false;

  TextEditingController emailController = TextEditingController();
  bool isValidEmailText = false;

  TextEditingController passwordController = TextEditingController();
  bool isValidPasswordText = false;

  TextEditingController confirmPasswordController = TextEditingController();
  bool isValidConfirmPasswordText = false;

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
                margin: EdgeInsets.only(right: 115.0, top: 10,),
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
                    style: TextStyle(
                      color: Colors.black
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (newValue) {
                      setState(() {
                        isValidNameText = isValidName(newValue);
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
                      errorText: isValidUserNameText ? null : 'Invalid Username',
                    ),
                    style: TextStyle(
                          color: Colors.black
                        ),
                    keyboardType: TextInputType.name,
                    onChanged: (newValue) {
                      setState(() {
                        isValidUserNameText = isValidUserName(newValue);
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
                    controller: degreeController,
                    decoration: InputDecoration(
                      labelText: 'Degree',
                      border: OutlineInputBorder(),
                      errorText: isValidDegreeText ? null : 'Invalid Degree',
                    ),
                    style: TextStyle(
                          color: Colors.black
                        ),
                    keyboardType: TextInputType.name,
                    onChanged: (newValue) {
                      setState(() {
                        isValidDegreeText = isValidDegree(newValue);
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
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                      errorText: isValidPhoneText ? null : 'Invalid Phone',

                    ),
                    style: TextStyle(
                          color: Colors.black
                        ),
                    keyboardType: TextInputType.phone,
                    onChanged: (newValue) {
                      setState(() {
                        isValidPhoneText = isValidPhone(newValue);
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
                      labelText: 'Email                                           @uniandes.edu.co',
                      border: OutlineInputBorder(),
                      errorText: isValidEmailText ? null : 'Invalid Email',

                    ),
                    style: TextStyle(
                          color: Colors.black
                        ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (newValue) {
                      setState(() {
                        isValidEmailText = isValidEmail(newValue);
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
                      errorText: isValidPasswordText ? null : 'Invalid Password',

                    ),
                    
                    style: TextStyle(
                          color: Colors.black
                        ),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (newValue) {
                      setState(() {
                        isValidPasswordText = isValidPassword(newValue);
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
                      errorText: isValidConfirmPasswordText ? null : 'Passwords do not match',
                    ),
                    style: TextStyle(
                          color: Colors.black
                        ),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (newValue) {
                      setState(() {
                        isValidConfirmPasswordText = isValidConfirmPassword(newValue, passwordController.text);
                      });
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 40.0, top: 10, left: 40),
                child: Text("by clicking on Sing Up you agree to the privacy policy and data consent.",
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
                        isValidPhoneText &&
                        isValidEmailText &&
                        isValidPasswordText &&
                        isValidConfirmPasswordText) {
                      // Realizar la acción de signUp
                      signUp();
                    } else {
                      showAlert("Error", "Complete the fields correctly!", Colors.red);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFFC600),
                    fixedSize: Size(330, 50),
                  ),
                  child: Text(
                    "Sing Up",
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
                  Text('Already have an account?', style: TextStyle(color: Colors.black),),
                  TextButton(
                    onPressed: () {
                      // Navegar a la pantalla de inicio de sesión
                      Navigator.of(context).pop();
                    },
                    child: Text('Sing In', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0),)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidName(String name) {
    bool rta = false;
    if(name.trim().isNotEmpty){
      rta = true;
    }
    return rta;
  }

  bool isValidUserName(String userName) {
    bool rta = false;

    if(userName.trim().isNotEmpty){
      rta = true;
    }

    return rta;
  }

  bool isValidDegree(String degree) {
    bool rta = false;

    if(degree.trim().isNotEmpty){
      rta = true;
    }

    return rta;
  }

  bool isValidPhone(String phone) {
    bool rta = false;

    if(phone.length == 10){
      rta = true;
    }
    return rta;
  }

  bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegExp.hasMatch(email);
  }

  bool isValidPassword(String password) {
    if (password.length < 8) {
      return false;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\-]'))) {
      return false;
    }
    return true;
  }

  bool isValidConfirmPassword(String confirmPassword, String password) {

    return confirmPassword == password;
  }

  void showAlert(String title, String message, Color backgroundColor) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Container(
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
                  style: TextStyle(color: Colors.white), // Cambia el color del texto a blanco
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
    final url = Uri.parse('https://creative-mole-46.hasura.app/api/rest/users/signup');

    final Map<String, dynamic> requestBody = {
      "object": {
        "email": emailController.text,
        "name": nameController.text,
        "password": passwordController.text,
        "phone": phoneController.text,
        "username": userNameController.text,
        "degree": degreeController.text,
      }
    };

    final headers = {
      "content-type": "application/json",
      "x-hasura-admin-secret": "mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ",
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Registro exitoso
      showAlert("Good", "Account Created!", Color(0xFFFFC600));

      final jsonResponse = json.decode(response.body);
      final userData = jsonResponse['data']['insert_users_one'];
      print("Registro exitoso: ${userData['name']}");

    //Navigator.of(context).pushNamed("/feed");

    } else if (response.statusCode == 400) {
      // Registro no exitoso debido a duplicación de username (u otro error)
      final jsonResponse = json.decode(response.body);
      showAlert("ERROR", 'The username, email and phone must be unique!', Colors.black);
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

}