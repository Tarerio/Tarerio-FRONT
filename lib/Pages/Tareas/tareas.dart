import 'package:flutter/material.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/Widgets/Cards/TareaCard.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/Pages/Tareas/asignacionTareaAlumno.dart';
import 'package:tarerio/Pages/Tareas/editarTareas.dart';
import 'package:tarerio/Pages/Tareas/crearTareaJuego.dart';
import 'package:tarerio/Pages/Tareas/crearTareaPorPasos.dart';
import 'package:tarerio/Pages/Tareas/crearTareaPeticion.dart';
import 'dart:async';
import 'package:tarerio/consts.dart';

import '../../Widgets/ConfirmationModal.dart';
import '../../Widgets/ErrorModal.dart';
import '../../Widgets/SuccessModal.dart';

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

      final tareasPorPasos = await _porPasosAPI.obtenerTareas();
      final tareasPeticion = await _peticionAPI.obtenerTareas();
      final tareasJuego = await _juegoAPI.obtenerTareas();

      setState(() {
        Tareas = [
          ...tareasPorPasos.map((tarea) => {'tipo': TAREA_POR_PASOS, ...tarea}),
          ...tareasPeticion.map((tarea) => {'tipo': TAREA_PETICION, ...tarea}),
          ...tareasJuego.map((tarea) => {'tipo': TAREA_JUEGO, ...tarea}),
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

  void _eliminarTarea(
      BuildContext context, int id, String tipo) {

    onAccept() async {
      try {
        String mensaje = "La tarea ha sido eliminada correctamente";
        switch (tipo) {
          case TAREA_POR_PASOS:
            mensaje = (await TareaPorPasosAPI().eliminarTarea(id))["message"];
            break;
          case TAREA_PETICION:
            mensaje = (await TareaPeticionAPI().eliminarTarea(id))["message"];
            break;
          case TAREA_JUEGO:
            mensaje = (await TareaJuegoAPI().eliminarTarea(id))["message"];
            break;
          default:
            throw Exception('Tipo de tarea no reconocido');
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuccessModal(title: "Tarea eliminada", content: mensaje);
          },
        );
        fetchTareas();
      } catch (e) {
        print("Error al eliminar tarea: $e");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorModal(title: "Error al eliminar tarea", content: "Ha ocurrido un error al eliminar la tarea");
          },
        );
      }
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationModal(title: "Eliminar Tarea", content: "Los alumnos asignados perderan esta tarea", onAccept: onAccept);
      },
    );
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
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 8.0, // Space between cards horizontally
          runSpacing: 8.0, // Space between cards vertically
          children: Tareas.map((tarea) {
            return SizedBox(
              height: 350,
              width: MediaQuery.of(context).size.width > 800
                  ? 200
                  : 150, // Adjust width based on screen size
              child: TareaCard(
                ID_tarea: tarea['ID_tarea'],
                titulo: tarea['Titulo'],
                descripcion: tarea['Descripcion'],
                imagenBase64: tarea['imagenBase64'] ?? '', // No hay imagen en las tareas de momento
                tipo: tarea['tipo'],
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarTareas(idTarea: tarea['ID_tarea'], tipoTarea: tarea['tipo']),
                    ),
                  );
                },
                onAssign: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AsignarTareaAlumno(origen: tarea['ID_tarea'], tipoTarea: tarea['tipo']),
                    ),
                  );
                },
                onDelete: () {
                  _eliminarTarea(context, tarea['ID_tarea'], tarea['tipo']);
                },
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
