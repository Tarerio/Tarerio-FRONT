import 'package:flutter/material.dart';

class PrincipalAdministrador extends StatelessWidget {

  const PrincipalAdministrador({super.key});

  @override
  Widget build(BuildContext context) {
    // Show the modal when the page is loaded

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, Administrador'),
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