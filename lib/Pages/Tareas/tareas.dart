import 'package:flutter/material.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/Widgets/TareaPorPasosCard.dart';
import 'package:tarerio/Widgets/TareaPeticionCard.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/Pages/Tareas/crearTareaJuego.dart';
import 'package:tarerio/Pages/Tareas/crearTareaPorPasos.dart';
import 'package:tarerio/Pages/Tareas/crearTareaPeticion.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
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
    fetchTareas(); // Obtener tareas
  }

  Future<void> fetchTareas() async {
    try {
      TareaPorPasosAPI _porPasosAPI = TareaPorPasosAPI();
      TareaPeticionAPI _peticionAPI = TareaPeticionAPI();

      // Obtén ambas listas de tareas de manera concurrente
      final tareasPorPasos = await _porPasosAPI.obtenerTareas();
      final tareasPeticion = await _peticionAPI.obtenerTareas();

      setState(() {
        tareas = [
          ...tareasPorPasos,
          ...tareasPeticion
        ]; // Combina ambas listas en 'tareas'
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
        title: const Text('Tareas',
            style: TextStyle(
                color: const Color(0xFF2EC4B6),
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      drawer: Navbar(
        screenIndex: 0,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                return TareaPorPasosCard(
                  titulo: tarea['Titulo'] ?? 'Sin Titulo',
                  descripcion: tarea['Descripcion'] ?? 'Sin Descripción',
                  horaCierre: tarea['horaCierre'] ??
                      'Sin hora', // Asegúrate de pasar la hora de cierre
                  onEdit: () {
                    // Logic to edit task
                  },
                  onAssign: () {
                    // Logic to assign task
                  },
                  onDelete: () {
                    // Logic to delete task
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
              leading: const Icon(Icons.games),
              title: const Text('Tarea Juego'),
              onTap: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CrearTareaJuego(IdAdministrador: 1)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Tarea Por Pasos'),
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
            ListTile(
              leading: const Icon(Icons.request_quote),
              title: const Text('Tarea Petición'),
              onTap: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CrearTareaPeticion(idAdministrador: 1)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
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
                await _deleteTask(
                    id); // Llama a la función para eliminar la tarea
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(String id) async {
    try {
      TareaPorPasosAPI _api = TareaPorPasosAPI();
      await _api.eliminarTarea(id); // Llama al método de eliminación
      setState(() {
        tareas.removeWhere(
            (tarea) => tarea['id'] == id); // Actualiza la lista de tareas
      });
    } catch (e) {
      print("Error al eliminar tarea: $e");
      // Manejar el error de eliminación
    }
  }
}
