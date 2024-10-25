import 'package:flutter/material.dart';
import 'RegistrarAlumno.dart';

class PrincipalAdministrador extends StatelessWidget {
  const PrincipalAdministrador({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, Administrador'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              // Navegar a la página de registro de alumno
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrarAlumno()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Bienvenido, Administrador!',
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}