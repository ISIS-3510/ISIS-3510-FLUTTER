import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:unishop/views/home.dart';


final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: Color.fromARGB(255, 255, 198, 0),
  background: Colors.white,
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    home: HomeView(),
  ));
}
