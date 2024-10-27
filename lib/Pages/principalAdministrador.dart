import 'package:flutter/material.dart';
import 'home.dart'; // Import the home screen
import '../Widgets/Navbar.dart'; // Import the Navbar component

class PrincipalAdministrador extends StatelessWidget {
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
        actions: [
          IconButton(
            icon: Image.asset('assets/images/tarerio.png'),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                    (Route<dynamic> route) => false, // Remove all previous routes
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Bienvenido, Administrador!',
          style: TextStyle(fontSize: 40),
        ),
      ),
      drawer: Navbar(), // Use the Navbar component
    );
  }
}