import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/TareaPorPasosCard.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/Pages/crearTareaJuego.dart';
import 'package:tarerio/Pages/crearTareaPorPasos.dart';
import 'package:tarerio/API/TareaPorPasosAPI.dart'; // Asegúrate de importar tu API
import 'dart:async';

class TareasPage extends StatefulWidget {
  TareasPage({super.key});

  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  List<Map<String, dynamic>> tareas = []; // Lista para almacenar las tareas
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    fetchTareas(); // Llamar a la función para obtener las tareas
  }

  Future<void> fetchTareas() async {
    try {
      TareaPorPasosAPI _api = TareaPorPasosAPI();
      final response = await _api.obtenerTareas(); // Implementa este método en TareaPorPasosAPI
      setState(() {
        tareas = response; // Actualiza la lista de tareas
        isLoading = false; // Cambia el estado de carga
      });
    } catch (e) {
      print("Error al obtener tareas: $e");
      setState(() {
        isLoading = false; // Cambia el estado de carga incluso si hay un error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;

    if (screenWidth > 1200) {
      crossAxisCount = 4;
    } else if (screenWidth > 800) {
      crossAxisCount = 3;
    } else if (screenWidth > 500) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
      ),
      drawer: Navbar(
        screenIndex: 0,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Mostrar indicador de carga
          : GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        itemCount: tareas.length,
        itemBuilder: (context, index) {
          final tarea = tareas[index];
          return TareaCard(
            titulo: tarea['Titulo'] ?? 'Sin Titulo',
            descripcion: tarea['Descripcion'] ?? 'Sin Descripción',
            tipo: tarea['tipo'] ?? 'desconocido',
            imagenUrl: tarea['Imagen'] ?? '',
            onEdit: () {
              // Logic to edit task
            },
            onAssign: () {
              // Logic to assign task
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTaskTypeDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2EC4B6),
      ),
    );
  }

  void _showTaskTypeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.format_list_bulleted),
              title: const Text('Tarea por Juego'),
              onTap: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CrearTareaJuego(IdAdministrador: 1)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.gamepad),
              title: const Text('Tarea de Por Pasos'),
              onTap: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CrearTareaPorPasos(idAdministrador: 1)),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
