import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/AulaCard.dart';
import 'package:tarerio/Widgets/Navbar.dart';

import 'package:tarerio/API/AulasAPI.dart';

class AulasPage extends StatefulWidget {
  AulasPage({super.key});


  @override
  _AulasPageState createState() => _AulasPageState();
/*
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
*/
}
class _AulasPageState extends State<AulasPage> {
  //List<Map<String, dynamic>> aulas = []; // Lista para almacenar las aulas
  List<dynamic> aulas = [];
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    fetchAulas(); // Llamar a la función para obtener las tareas
  }

  Future<void> fetchAulas() async {
    try {
      AulasAPI _api = AulasAPI();
      final response = await _api.obtenerAulas();
      setState(() {
        aulas = response; // Actualiza la lista de tareas
        isLoading = false; // Cambia el estado de carga
      });

    } catch (e) {
      print("Error al obtener aulas: $e");
      setState(() {
        isLoading = false; // Cambia el estado de carga incluso si hay un error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aulas'),
      ),
      body: isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
        itemCount: aulas.length,
        itemBuilder: (context, index) {
          final aula = aulas[index];
          return AulaCard(
            claveAula: aula['clave_aula'] ?? "Sin clave",
            cupoAula: aula['cupo'] ?? 0,
            imagenUrl: 'assets/images/aula.jpg',  //aula['imagenUrl']! //
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
