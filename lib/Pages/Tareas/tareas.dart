import 'package:flutter/material.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/Widgets/Cards/TareaCard.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/Pages/Tareas/crearTareaJuego.dart';
import 'package:tarerio/Pages/Tareas/crearTareaPorPasos.dart';
import 'package:tarerio/Pages/Tareas/crearTareaPeticion.dart';
import 'dart:async';

class TareasPage extends StatefulWidget {
  TareasPage({super.key});

  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  List<Map<String, dynamic>> Tareas = []; // Lista para almacenar las tareas
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
      TareaJuegoAPI _juegoAPI = TareaJuegoAPI();

      // Obtén ambas listas de tareas de manera concurrente
      final tareasPorPasos = await _porPasosAPI.obtenerTareas();
      final tareasPeticion = await _peticionAPI.obtenerTareas();
      final tareasJuego = await _juegoAPI.obtenerTareas();

      setState(() {
        Tareas = [
          ...tareasPorPasos.map((tarea) => {'tipo': 'Tarea Por Pasos', ...tarea}),
          ...tareasPeticion.map((tarea) => {'tipo': 'Tarea Peticion', ...tarea}),
          ...tareasJuego.map((tarea) => {'tipo': 'Tarea Juego', ...tarea}),
        ]; // Combina las listas en 'tareas'
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas',
            style: TextStyle(
                color: const Color(0xFF2EC4B6),
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0, // Space between cards horizontally
          runSpacing: 8.0, // Space between cards vertically
          children: Tareas.map((tarea) {
            return SizedBox(
              width: MediaQuery.of(context).size.width > 800
                  ? 200
                  : 150, // Adjust width based on screen size
              child: TareaCard(
                titulo: tarea['Titulo'],
                descripcion: tarea['Descripcion'],
                imagenbase64: tarea['imagenBase64'] ?? '', // No hay imagen en las tareas de momento
                tipo: tarea['tipo'],
                onEdit: () {},
                onAssign: () {},
                onDelete: () {},
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTaskTypeDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2EC4B6),
      ),
      drawer: Navbar(
        screenIndex: 0,
        onLogout: () {
          print("Cerrar sesión");
        },
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

}
