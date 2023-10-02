import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '/sign_up.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool btnTap = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isValidEmaiText = true;
  bool isValidPasswordText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image.asset(
            "assets/headerLogin.png", // Ruta de tu imagen de fondo
            fit: BoxFit.cover, // Ajusta la imagen al tamaño de la pantalla
            width: double.infinity, // Ancho de la imagen
            height: 300, // Alto de la imagen
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 300.0, left: 30, right: 30),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Institutional Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (newValue) {
                        setState(() {
                          isValidEmaiText = isValidEmail(newValue);
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0), // Puedes ajustar el espacio aquí
                  child: Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true, // Para contraseñas
                      onChanged: (newValue) {
                        setState(() {
                          isValidPasswordText = isValidPassword(newValue);
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 225.0), // Margen a la derecha de 20.0 unidades
                  child: Text(
                    "Forget Password ?",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
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
                      "Login",
                      style: TextStyle(
                        color: Colors.black, // Establece el color del texto en blanco
                        fontSize: 18, // Tamaño de fuente
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ),
                Image.asset(
                  "assets/footerLogin.png", // Ruta de tu imagen de fondo
                  fit: BoxFit.cover, // Ajusta la imagen al tamaño de la pantalla
                  width: double.infinity, // Ancho de la imagen
                  height: 150, // Alto de la imagen
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0), // Margen a la derecha de 20.0 unidades
                  child: Text.rich(
                    TextSpan(
                      text: "Not registered yet? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Create Account",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          // Agrega un GestureDetector para manejar el toque en "Create Account"
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navega a la pantalla de registro cuando se toca "Create Account"
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  )
                ),
                
                // ... Otros widgets aquí ...
              ],
            ),
          )

        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    // Implementa tu lógica de validación de correo electrónico aquí
    return true;
  }

  bool isValidPassword(String password) {
    // Implementa tu lógica de validación de contraseña aquí
    return true;
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginView(),
  ));
}
