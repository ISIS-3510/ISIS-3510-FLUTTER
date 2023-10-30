import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:unishop/Model/Repository/users_repository.dart';
import 'package:unishop/views/sign_up.dart';
import 'package:unishop/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  TextEditingController emailController = TextEditingController();
  bool isValidEmailText = true;

  TextEditingController passwordController = TextEditingController();
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
                        errorText: isValidEmailText ? null : 'Invalid Email',
                      ),
                      style: TextStyle(
                        color: Colors.black
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (newValue) {
                        setState(() {
                          isValidEmailText = UsersRepository.isValidEmail(newValue);
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
                      style: TextStyle(
                        color: Colors.black
                      ),
                      obscureText: true, // Para contraseñas
                      onChanged: (newValue) {
                        setState(() {
                          isValidPasswordText = UsersRepository.isValidPassword(newValue);
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
                    onPressed: _handleLogin,
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

  void showAlert(String title,String message, Color backgroundColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          backgroundColor: backgroundColor, // Establece el color de fondo
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra la alerta
              },
            ),
          ],
        );
      },
    );
  }

  void _handleLogin() async {
    try {
      final response = await UsersRepository.logIn();

      if (response.statusCode == 200) {
        final matchingUser = await UsersRepository.loginVerifier(emailController, passwordController, response);        
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('user_degree', matchingUser['degree']);
          prefs.setString('user_email', matchingUser['email']);
          prefs.setString('user_id', matchingUser['id']);
          prefs.setString('user_name', matchingUser['name']);
          prefs.setString('user_password', matchingUser['password']);
          prefs.setString('user_phone', matchingUser['phone']);
          prefs.setString('user_username', matchingUser['username']);

          // Authentication successful, show a success alert
          showAlert('Success', 'Authentication successful', Colors.green);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeView(),
            ),
          );
      } else {
        // Handle other HTTP status codes as needed
        showAlert('Error', 'Failed to fetch data', Colors.red);
      }
    } catch (e) {
      // Handle any network or parsing errors
      showAlert('Error', 'An error occurredaaaa: $e', Colors.red);
    }
  }

}