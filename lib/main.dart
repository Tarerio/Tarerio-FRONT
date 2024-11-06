import 'package:flutter/material.dart';
import 'package:tarerio/Pages/alumnos.dart';
import 'package:tarerio/Pages/aulas.dart';
import 'package:tarerio/Pages/profesores.dart';
import 'package:tarerio/Pages/tareas.dart';
import 'package:tarerio/Pages/crearTareaJuego.dart';
import 'package:tarerio/Pages/crearTareaPorPasos.dart';
import 'package:tarerio/Pages/home.dart';
import 'package:tarerio/Pages/inicioAlumno.dart'; // Importa la página InicioAlumno
import 'package:tarerio/Pages/inicioAdministradorProfesor.dart';
import 'package:tarerio/Pages/registrarAlumno.dart';
import 'package:tarerio/Pages/registrarProfesor.dart';
import 'Pages/editarContraseniaProfesor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false, // Quita el banner de debug
      theme: ThemeData(
        primarySwatch: Colors.cyan, // Cambia el color principal aquí
        scaffoldBackgroundColor: Colors.white, // Cambia el color de fondo aquí
        appBarTheme: const AppBarTheme(
          color: Colors.white, // Cambia el color del AppBar aquí
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor:
                Colors.white, // Cambia el color del texto e icono a negro
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor:
                Colors.white, // Cambia el color del texto e icono a negro
          ),
        ),
      ),
      routes: {
        '/home': (context) => const Home(), // Define la rutas
        '/inicioAlumno': (context) => const InicioAlumno(),
        '/inicioAdministrador': (context) => InicioAdministrador(),
        '/administrador/alumnos': (context) => AlumnosPage(),
        '/administrador/registrarAlumno': (context) => const RegistrarAlumno(),
        '/administrador/profesores': (context) => ProfesoresPage(),
        '/administrador/profesores/registrarProfesor': (context) =>
            const RegistrarProfesor(),
        '/administrador/profesores/editarContrasenia': (context) =>
            const EditarContraseniaProfesor(),
        '/administrador/aulas': (context) => AulasPage(),
        '/administrador/tareas': (context) => TareasPage(),
        '/administrador/tareas/tareaPorPasos': (context) =>
            CrearTareaPorPasos(idAdministrador: 1)
      },
    );
  }
}
