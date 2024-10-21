import 'package:flutter/material.dart';
import 'package:tarerio/Pages/home.dart';
import 'package:tarerio/Pages/inicioAlumno.dart'; // Importa la página InicioAlumno

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false, // Quita el banner de debug
      theme: ThemeData(
        primarySwatch: Colors.cyan, // Cambia el color principal aquí
        scaffoldBackgroundColor: Colors.white, // Cambia el color de fondo aquí
        appBarTheme: AppBarTheme(
          color: Colors.white, // Cambia el color del AppBar aquí
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Colors.white, // Cambia el color del texto e icono a negro
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Colors.white, // Cambia el color del texto e icono a negro
          ),
        ),
      ),
      routes: {
        '/inicioAlumno': (context) => InicioAlumno(), // Define la ruta
      },
    );
  }
}