import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        actions: [
          Container(
            height: 200,
            margin: EdgeInsets.all(8.0), // Adds margin around the button
            child: ElevatedButton(
              onPressed: () {
                // Action when the "Tutores y Administradores" button is pressed
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person),
                  SizedBox(height: 15), // Reduce the space between icon and text
                  Text(
                    'Tutores y administrador',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Reduce vertical padding
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Adds borderRadius
                ),
                elevation: 5, // Adds shadow
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/tarerio.png', height: 200), // Added image
            SizedBox(height: 20),
            Text(
              'Inicia Sesión:',
              style: TextStyle(
                fontSize: 40,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 60), // Increases space above the button
            Container(
              height: 200,
              margin: EdgeInsets.all(8.0), // Adds margin around the button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/inicioAlumno'); // Navega a InicioAlumno
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school, size: 30,),
                    SizedBox(height: 5, width: 200,), // Reduce the space between icon and text
                    Text(
                      'Alumno',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Reduce vertical padding
                  textStyle: TextStyle(fontSize: 38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Adds borderRadius
                  ),
                  elevation: 5, // Adds shadow
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}