import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unishop/View/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unishop/Controller/alert_controller.dart';
import 'package:unishop/Model/DAO/dao.dart';


final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: Color.fromARGB(255, 255, 198, 0),
  background: Colors.white,
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  await initNotifications();

  AlertController alertController = AlertController();
  alertController.callSearchAlerts();


  runApp(MaterialApp(
    title: 'Unishop',
    theme: ThemeData().copyWith(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: TextTheme(
        titleLarge: GoogleFonts.archivo(
          fontWeight: FontWeight.w500,
          fontSize: 28,
          color: Colors.black
        ),
        bodySmall: GoogleFonts.archivo(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: Color.fromARGB(255, 152, 162, 172)
        ),
        labelLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: Colors.black
        ),
        labelSmall: GoogleFonts.archivo(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: Colors.black
        ),
      ),
    ),
    home: LoginView(),
  ));
}
