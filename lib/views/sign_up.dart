import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController nameController = TextEditingController();
  bool isValidNameText = true;

  TextEditingController userNameController = TextEditingController();
  bool isValidUserNameText = true;

  TextEditingController phoneController = TextEditingController();
  bool isValidPhoneText = true;

  TextEditingController emailController = TextEditingController();
  bool isValidEmailText = true;

  TextEditingController passwordController = TextEditingController();
  bool isValidPasswordText = true;

  TextEditingController confirmPasswordController = TextEditingController();
  bool isValidConfirmPasswordText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/headerSingUp.png", // Ruta de tu imagen de fondo
              fit: BoxFit.cover, // Ajusta la imagen al tamaño de la pantalla
              width: double.infinity, // Ancho de la imagen
              height: 160, // Alto de la imagen
            ),
            Container(
              margin: EdgeInsets.only(right: 115.0, top: 10,), // Margen a la derecha de 20.0 unidades
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
              child: Text("We’re so happy that you want to join us, now we need to validate your data and check if you’re elegible, so we will need the following data",
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
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
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
                    labelText: 'Email                                @uniandes.edu.co',
                    border: OutlineInputBorder(),
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
                  ),
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
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (newValue) {
                    setState(() {
                      isValidConfirmPasswordText = isValidConfirmPassword(newValue);
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
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(top: 20.0), // Margen a la derecha de 20.0 unidades
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes definir la función que se ejecutará al presionar el botón
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFC600), 
                  fixedSize: Size(330, 50), // Establece el color de fondo del botón a FFC600
                ),
                child: Text(
                  "Sing Up",
                  style: TextStyle(
                    color: Colors.black, // Establece el color del texto en blanco
                    fontSize: 18, // Tamaño de fuente
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
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
    );
  }

  bool isValidName(String name) {
    // Implementa tu lógica de validación de correo electrónico aquí
    return true;
  }

  bool isValidUserName(String userName) {
    // Implementa tu lógica de validación de correo electrónico aquí
    return true;
  }

  bool isValidPhone(String phone) {
    // Implementa tu lógica de validación de correo electrónico aquí
    return true;
  }

  bool isValidEmail(String email) {
    // Implementa tu lógica de validación de correo electrónico aquí
    return true;
  }

  bool isValidPassword(String password) {
    // Implementa tu lógica de validación de correo electrónico aquí
    return true;
  }

  bool isValidConfirmPassword(String confirmPassword) {
    // Implementa tu lógica de validación de correo electrónico aquí
    return true;
  }

}