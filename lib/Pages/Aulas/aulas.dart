import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/AulaCard.dart';
import 'package:tarerio/Widgets/Navbar.dart';

import 'package:tarerio/API/aulasAPI.dart';
import 'package:tarerio/Pages/Aulas/crearAula.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/API/profesoresAPI.dart';
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
  List<dynamic> aulas = [];
  List<dynamic> profesores = [];
  bool isloadingAulas = true;
  bool isLoadingProfesores = true;

  @override
  void initState() {
    super.initState();
    fetchAulas();
    fetchProfesores();
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
        isloadingAulas = false; // Cambia el estado de carga
      });
    } catch (e) {
      print("Error al obtener aulas: $e");
      setState(() {
        isloadingAulas =
            false; // Cambia el estado de carga incluso si hay un error
      });
    }
  }

  Future<void> fetchProfesores() async {
    try {
      final response = await ProfesoresAPI().obtenerProfesores();
      setState(() {
        profesores = response;
        isLoadingProfesores = false;
      });
    } catch (e) {
      print("Error al obtener profesores: $e");
      setState(() => isLoadingProfesores = false);
    }
  }

  void _confirmarEliminacion(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este Aula?'),
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
                await _borrarAula(
                    id); // Llama a la función para eliminar la tarea
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
        aulas.removeWhere(
            (aula) => aula['id'] == id); // Actualiza la lista de tareas
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
          title: const Text('Aulas',
              style: TextStyle(
                  color: const Color(0xFF2EC4B6),
                  fontSize: 24,
                  fontWeight: FontWeight.bold))),
      body: isloadingAulas
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: aulas.length,
              itemBuilder: (context, index) {
                final aula = aulas[index];
                int idAula = aula['id_aula'];
                return AulaCard(
                  claveAula: aula['clave_aula'] ?? "Sin clave",
                  cupoAula: aula['cupo'] ?? 0,
                  imagenUrl: 'assets/images/aula.jpg', //aula['imagenUrl']! //
                  onEdit: () {
                    // Lógica para editar aula
                  },
                  onAssign: () {
                    mostrarDialogoProfesores(context, idAula);
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
            MaterialPageRoute(builder: (context) => CrearAula()),
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

  void mostrarDialogoProfesores(BuildContext context, int idAula) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seleccionar Profesor'),
          content: isloadingAulas
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: profesores.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 192, 184, 184),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                              profesores[index]['nickname'] ?? 'Sin nombre'),
                          onTap: () async {
                            int idUsuario = profesores[index][
                                'id_usuario']; // Convertimos id_usuario a String
                            try {
                              await AulasAPI()
                                  .asignarProfesorAula(idAula, idUsuario);
                              Navigator.pop(context);
                              _showSuccessModal(context, "Éxito",
                                  "Profesor asignado exitosamente");
                            } catch (e) {
                              _showErrorModal(context, "Error", e.toString());
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
