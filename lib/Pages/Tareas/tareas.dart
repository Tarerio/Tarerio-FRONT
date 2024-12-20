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
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Widgets/ConfirmationModal.dart';
import '../../Widgets/ErrorModal.dart';
import '../../Widgets/SuccessModal.dart';

class TareasPage extends StatefulWidget {
  TareasPage({super.key});

  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  int? idAdministrador;

  List<Map<String, dynamic>> Tareas = []; // Lista para almacenar las tareas
  bool isLoading = true; // Indicador de carga

  final TareaPorPasosAPI _porPasosAPI = TareaPorPasosAPI();
  final TareaPeticionAPI _peticionAPI = TareaPeticionAPI();
  final TareaJuegoAPI _juegoAPI = TareaJuegoAPI();

  final Map<String, String> categorias = {
    'Tareas de Juegos': TAREA_JUEGO,
    'Tareas Por Pasos': TAREA_POR_PASOS,
    'Tareas de Petición': TAREA_PETICION,
  };

  String? tipoTareaSeleccionado;
  final TextEditingController nombreTareaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadIdAdministrador();
    fetchTareas(); // Obtener tareas
  }

  Future<void> _loadIdAdministrador() async {
    try {
      final id = await fetchIdAdministrador();
      setState(() {
        idAdministrador = id;
      });
    } catch (e) {
      print('Failed to load idAdministrador: $e');
    }
  }

  void _cleanFiltros(){
    setState(() {
      tipoTareaSeleccionado = null;
      nombreTareaController.text = '';
      fetchTareas();
    });
  }

  Future<int> fetchIdAdministrador() async {
    final response = await http.get(Uri.parse('$baseUrl/administradores/getIdAdmin'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Failed to load idAdministrador');
    }
  }

  Future<void> fetchTareas() async {
    try {
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

  Future<void> _filterTareas({String? nombreTarea, String? tipoTarea}) async {
    try {
      setState(() {
        isLoading = true; // Mostrar indicador de carga
      });

      List<Map<String, dynamic>>? tareasPorPasos = [];
      List<Map<String, dynamic>>? tareasPeticion = [];
      List<Map<String, dynamic>>? tareasJuego = [];

      print(nombreTarea);

      if (tipoTarea != null) {
        switch (tipoTarea) {
          case TAREA_POR_PASOS:
            tareasPorPasos = await _porPasosAPI.getFilteredTareas(nombreTarea: nombreTarea);
            break;

          case TAREA_PETICION:
            tareasPeticion = await _peticionAPI.getFilteredTareas(nombreTarea: nombreTarea);
            break;

          case TAREA_JUEGO:
            tareasJuego = await _juegoAPI.getFilteredTareas(nombreTarea: nombreTarea);
            break;
        }
      } else{
        tareasPorPasos = await _porPasosAPI.getFilteredTareas(nombreTarea: nombreTarea);
        tareasPeticion = await _peticionAPI.getFilteredTareas(nombreTarea: nombreTarea);
        tareasJuego = await _juegoAPI.getFilteredTareas(nombreTarea: nombreTarea);
      }

      setState(() {
        Tareas = [
          ...?tareasPorPasos?.map((tarea) => {'tipo': TAREA_POR_PASOS, ...tarea}),
          ...?tareasPeticion?.map((tarea) => {'tipo': TAREA_PETICION, ...tarea}),
          ...?tareasJuego?.map((tarea) => {'tipo': TAREA_JUEGO, ...tarea}),
        ];
        isLoading = false; // Oculta indicador de carga
      });

    } catch (e) {
      print("Error al obtener tareas: $e");
      setState(() {
        isLoading = false; // Oculta indicador de carga en caso de error
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.refresh_sharp,
                    color: Color(colorPrincipal),
                  ),
                  onPressed: () {
                    _cleanFiltros();
                  },
                ),
                const SizedBox(width: 10),
                Container(
                  child: DropdownButton<String>(
                    alignment: Alignment.center,
                    hint: const Text('Filtrar por categoria'),
                    value: tipoTareaSeleccionado,
                    items: categorias.entries.map((tiposTarea) {
                      return DropdownMenuItem<String>(
                        value: tiposTarea.value,
                        alignment: Alignment.center,
                        child: Text(tiposTarea.key),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        tipoTareaSeleccionado = newValue;
                        _filterTareas(tipoTarea: tipoTareaSeleccionado, nombreTarea: nombreTareaController.text);
                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    underline: SizedBox.shrink(),
                    iconEnabledColor: Color(colorPrincipal),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 213,
                  child: TextField(
                    controller: nombreTareaController,
                    decoration: InputDecoration(
                      labelText: 'Buscar por nombre',
                      labelStyle: TextStyle(color: Color(colorPrincipal)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(colorPrincipal)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(colorPrincipal), width: 2.0),
                      ),
                      suffixIcon: Icon(Icons.search, color: Color(colorPrincipal)),
                    ),
                    onChanged: (value) async {
                      await _filterTareas(nombreTarea: value, tipoTarea: tipoTareaSeleccionado);
                      setState(() {
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
          _loadIdAdministrador();
          _showTaskTypeDialog(context);
        },
        backgroundColor: const Color(0xFF2EC4B6),
        child: const Icon(Icons.add),
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
    if (idAdministrador == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorModal(
            title: "Error",
            content: "El idAdministrador no se ha cargado correctamente.",
          );
        },
      );
      return;
    }

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
                          CrearTareaJuego(IdAdministrador: idAdministrador!)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_rounded),
              title: const Text('Tarea Por Pasos'),
              onTap: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CrearTareaPorPasos(idAdministrador: idAdministrador!)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('Tarea Petición'),
              onTap: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CrearTareaPeticion(idAdministrador: idAdministrador!)),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
