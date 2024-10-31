import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/AulaCard.dart';
import 'package:tarerio/Widgets/Navbar.dart';

class AulasPage extends StatelessWidget {
  AulasPage({super.key});

  final List<Map<String, String>> aulas = [
    {
      'nombre': 'Aula A1',
      'imagenUrl':
          'https://www.colegiolasrosas.es/imgs/galerias/aulas-educacion-primaria/ColegioLasRosas_aulas_educacion_primaria_1.jpg', // Cambia esta URL por la ruta real
    },
    {
      'nombre': 'Aula A2',
      'imagenUrl':
          'https://www.colegiolasrosas.es/imgs/galerias/aulas-educacion-primaria/ColegioLasRosas_aulas_educacion_primaria_1.jpg', // Cambia esta URL por la ruta real
    },
    // Agrega más aulas según los datos de tu base de datos
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aulas'),
      ),
      body: ListView.builder(
        itemCount: aulas.length,
        itemBuilder: (context, index) {
          final aula = aulas[index];
          return AulaCard(
            nombreAula: aula['nombre']!,
            imagenUrl: aula['imagenUrl']!,
            onEdit: () {
              // Lógica para editar aula
            },
            onAssign: () {
              // Lógica para asignar aula
            },
          );
        },
      ),
      drawer: Navbar(
        screenIndex: 2,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }
}
