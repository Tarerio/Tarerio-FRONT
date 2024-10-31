import 'package:flutter/material.dart';
import 'package:tarerio/Pages/aulas.dart';
import 'package:tarerio/Pages/home.dart';
import 'package:tarerio/Pages/inicioAlumno.dart'; // Importa la página InicioAlumno
import 'package:tarerio/Pages/inicioAdministradorProfesor.dart';
import 'package:tarerio/Pages/registrarAlumno.dart';
import 'package:tarerio/Pages/registrarProfesor.dart'; // Importa la página RegistrarAlumno

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      debugShowCheckedModeBanner: false, // Quita el banner de debug
      theme: ThemeData(
        primarySwatch: Colors.cyan, // Cambia el color principal aquí
        scaffoldBackgroundColor: Colors.white, // Cambia el color de fondo aquí
        appBarTheme: const AppBarTheme(
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
        '/inicioAlumno': (context) =>const  InicioAlumno(), // Define la rutas
        '/inicioAdministrador' : (context) => InicioAdministrador(),
        '/administrador/registrarAlumno' : (context) => const RegistrarAlumno(),
        '/administrador/registrarProfesor' : (context) => const RegistrarProfesor(),
        '/administrador/aulas' : (context) =>  AulasPage()
      },
    );
  }
}