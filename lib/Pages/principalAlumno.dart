import 'package:flutter/material.dart';
import 'home.dart'; //

class PrincipalAlumno extends StatelessWidget {
  final String nickname;

  PrincipalAlumno({required this.nickname});

  @override
  Widget build(BuildContext context) {
    // Show the modal when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showConfirmationDialog(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $nickname'),
      ),
      body: Center(
        child: Text(
          'Bienvenido, $nickname!',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.person, size: 50),
          title: Text('Confirmación', style: TextStyle(fontSize: 40)),
          content: Text('¿Eres $nickname?', style: TextStyle(fontSize: 30)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Sí', style: TextStyle(fontSize: 30)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()), // Navigate back to PatronAlumno
                );
              },
              child: Text('No', style: TextStyle(fontSize: 30)),
            ),
          ],
        );
      },
    );
  }
}