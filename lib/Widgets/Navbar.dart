import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final List<String> listElements = const ['Registrar Alumno', 'Registrar Profesor', 'Mi Perfil', 'Ajustes'];
  final List<String> listRoutes = const ['/administrador/registrarAlumno', '/administrador/registrarProfesor', '/administrador/perfil', '/administrador/ajustes'];

  Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.cyan[500],
            ),
            child: const Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          for (var i = 0; i < listElements.length; i++)
            ListTile(
              title: Text(listElements[i]),
              onTap: () {
                // Navigate to the corresponding page
                Navigator.pushNamed(context, listRoutes[i]);
              },
            ),
        ],
      ),
    );
  }
}