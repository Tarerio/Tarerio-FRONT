import 'package:flutter/material.dart';

class InicioAlumno extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('Inicio de sesión'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Seleccione una categoría:',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: EdgeInsets.all(20),
                children: [
                  _buildCategoryButton('assets/images/tarerio.png', 'Superheroes'),
                  _buildCategoryButton('assets/images/tarerio.png', 'Dinosaurios'),
                  _buildCategoryButton('assets/images/tarerio.png', 'Formas'),
                  _buildCategoryButton('assets/images/tarerio.png', 'Insectos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String imagePath, String label) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: ElevatedButton(
        onPressed: () {
          // Define the action for each button here
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(20),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double imageSize;
            if (constraints.maxWidth > 400) {
              imageSize = 200; // Larger size for widths greater than 600px
            } else if (constraints.maxWidth > 200) {
              imageSize = 125; // Medium size for widths between 400px and 600px
            } else {
              imageSize = 75; // Smaller size for widths less than 400px
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, height: imageSize),
                SizedBox(height: 10),
                Text(
                  label,
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}