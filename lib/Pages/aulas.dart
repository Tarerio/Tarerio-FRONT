import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/AulaCard.dart';
import 'package:tarerio/Widgets/Navbar.dart';

import 'package:tarerio/API/AulasAPI.dart';
import 'package:tarerio/Pages/crearAula.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';

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

void _showErrorModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorModal(title: title, content: content);
      },
    );
  }

  void _showSuccessModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessModal(title: title, content: content);
      },
    );
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

  void _confirmarEliminacion(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este Aula?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar el diálogo
                await _borrarAula(id); // Llama a la función para eliminar la tarea
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _borrarAula(String id) async {
    try {
      AulasAPI _api = AulasAPI();
      await _api.eliminarAula(id); // Llama al método de eliminación
      setState(() {
        aulas.removeWhere((aula) => aula['id'] == id); // Actualiza la lista de tareas
      });
      _showSuccessModal(context, "Exito", "Exito al eliminar el aula");
    } catch (e) {
      print("Error al eliminar aula: $e");
      _showErrorModal(context, "Error", "Error al eliminar el aula");
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
            onDelete: () {
              _confirmarEliminacion(aula["id_aula"].toString());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearAula()
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2EC4B6),
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
