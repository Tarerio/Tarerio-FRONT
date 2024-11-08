import 'package:flutter/material.dart';
import 'package:tarerio/Pages/Alumnos/alumnos.dart';
import 'package:tarerio/Pages/Aulas/aulas.dart';
import 'package:tarerio/Pages/Profesores/profesores.dart';
import 'package:tarerio/Pages/Tareas/tareas.dart';
import 'package:tarerio/Pages/Menus/menus.dart';
import 'package:tarerio/Pages/home.dart';
import 'package:tarerio/Pages/Alumnos/inicioAlumno.dart'; // Importa la página InicioAlumno
import 'package:tarerio/Pages/inicioAdministradorProfesor.dart';
import 'package:tarerio/Pages/Alumnos/registrarAlumno.dart';
import 'package:tarerio/Pages/Profesores/registrarProfesor.dart';
import 'Pages/Profesores/editarContraseniaProfesor.dart';

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
        '/administrador/tareas': (context) => TareasPage(),
        '/administrador/menus': (context) => MenusPage(),
        '/administrador/aulas': (context) => AulasPage(),
        '/administrador/profesores': (context) => ProfesoresPage(),
        '/administrador/alumnos': (context) => AlumnosPage(),
        //'/administrador/perfil': (context) => PerfilPage(), // TO ADD pagina de configuración del administrador
        '/administrador/registrarAlumno': (context) => const RegistrarAlumno(),
        '/administrador/profesores/registrarProfesor': (context) => const RegistrarProfesor(),
        '/administrador/profesores/editarContrasenia': (context) => const EditarContraseniaProfesor(),
      },
    );
  }
}
