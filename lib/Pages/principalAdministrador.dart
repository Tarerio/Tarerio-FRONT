import 'package:flutter/material.dart';
import 'registrarAlumno.dart';

class PrincipalAdministrador extends StatelessWidget {
  
  final List<String> listElements = ['Registrar Alumno', 'Registrar Profesor', 'Mi Perfil' ,'Ajustes'];
  final List<String> listRoutes = ['/administrador/registrarAlumno', '/administrador/registrarProfesor', '/administrador/perfil' ,'administrador/ajustes'];
  
  PrincipalAdministrador({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido, Administrador'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Bienvenido, Administrador!',
          style: TextStyle(fontSize: 40),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            for (var i = 0; i < listElements.length; i++)
              ListTile(
                title: Text(listElements[i]),
                onTap: () {
                  // Navegar a la página correspondiente
                  Navigator.pushNamed(context, listRoutes[i]);
                },
              ),
          ],
        )
      ),
    );
  }
}