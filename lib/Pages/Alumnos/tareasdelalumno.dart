import 'package:flutter/material.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import 'package:tarerio/Widgets/Cards/TareaCard.dart';
import '../../consts.dart';

class TareasDelAlumno extends StatefulWidget {
  final String nickname;

  const TareasDelAlumno({super.key, required this.nickname});

  @override
  _TareasDelAlumnoState createState() => _TareasDelAlumnoState();
}

class _TareasDelAlumnoState extends State<TareasDelAlumno> {
  List<dynamic> tareas = [];
  String? estado = "";
  String? fecha = "";

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  Future<Map<String, dynamic>?> _fetchTareaJuegoByID(int tareaId) async {
    TareaJuegoAPI juegoAPI = TareaJuegoAPI();
    try {
      final tareaJuego = await juegoAPI.obtenerTareaByID(tareaId);
      return {'tipo': 'TareaJuego', 'details': tareaJuego};
    } catch (e) {
      // Handle error
    }
    return null;
  }

  Future<Map<String, dynamic>?> _fetchTareaPeticionByID(int tareaId) async {
    TareaPeticionAPI peticionAPI = TareaPeticionAPI();
    try {
      final tareaPeticion = await peticionAPI.obtenerTareaByID(tareaId);
      return {'tipo': 'TareaPeticion', 'details': tareaPeticion};
    } catch (e) {
      // Handle error
    }
    return null;
  }

  Future<Map<String, dynamic>?> _fetchTareaPorPasosByID(int tareaId) async {
    TareaPorPasosAPI porPasosAPI = TareaPorPasosAPI();
    try {
      final tareaPorPasos = await porPasosAPI.obtenerTareaByID(tareaId);
      return {'tipo': 'TareaPorPasos', 'details': tareaPorPasos};
    } catch (e) {
      // Handle error
    }
    return null;
  }

  void _markTaskAsDone(int idTarea, String idAlumno, String tipo) async {
    try {
      switch (tipo) {
        case 'TareaJuego':
          TareaJuegoAPI juegoAPI = TareaJuegoAPI();
          await juegoAPI.markAsDone(idTarea, idAlumno);
          break;
        case 'TareaPeticion':
          TareaPeticionAPI peticionAPI = TareaPeticionAPI();
          await peticionAPI.markAsDone(idTarea, idAlumno);
          break;
        case 'TareaPorPasos':
          TareaPorPasosAPI porPasosAPI = TareaPorPasosAPI();
          await porPasosAPI.markAsDone(idTarea, idAlumno);
          break;
        default:
          throw Exception('Tipo de tarea no reconocido');
      }
      // Optionally, refresh the task list after marking as done
      _cargarTareas();
    } catch (e) {
      print('Error marking task as done: $e');
    }
  }

  Future<void> _cargarTareas() async {
    TareaJuegoAPI juegoAPI = TareaJuegoAPI();
    TareaPeticionAPI peticionAPI = TareaPeticionAPI();
    TareaPorPasosAPI porPasosAPI = TareaPorPasosAPI();

    try {
      final tareasJuego =
          await juegoAPI.obtenerAsignadasAlumno(widget.nickname, estado, fecha);
      final tareasPeticion = await peticionAPI.obtenerAsignadasAlumno(
          widget.nickname, estado, fecha);
      final tareasPorPasos = await porPasosAPI.obtenerAsignadasAlumno(
          widget.nickname, estado, fecha);

      // Add 'tipo' field to each task
      final allTareas = [
        ...tareasJuego.map((tarea) => {...tarea, 'tipo': 'TareaJuego'}),
        ...tareasPeticion.map((tarea) => {...tarea, 'tipo': 'TareaPeticion'}),
        ...tareasPorPasos.map((tarea) => {...tarea, 'tipo': 'TareaPorPasos'}),
      ];

      List<dynamic> detailedTareas = [];
      for (var tarea in allTareas) {
        final tareaId = tarea['ID_tarea'];
        Map<String, dynamic>? tareaDetails;

        switch (tarea['tipo']) {
          case 'TareaJuego':
            tareaDetails = await _fetchTareaJuegoByID(tareaId);
            break;
          case 'TareaPeticion':
            tareaDetails = await _fetchTareaPeticionByID(tareaId);
            break;
          case 'TareaPorPasos':
            tareaDetails = await _fetchTareaPorPasosByID(tareaId);
            break;
          default:
            throw Exception('Tipo de tarea no reconocido');
        }

        if (tareaDetails != null) {
          detailedTareas.add({
            ...tarea,
            'details': tareaDetails,
          });
        }
      }

      setState(() {
        tareas = detailedTareas;
      });
    } catch (e) {
      print("Error al cargar tareas: $e");
    }
  }

  void _filtrarTareas() {
    setState(() {
      _cargarTareas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas de ${widget.nickname}',
            style: TextStyle(
                color: Color(colorPrincipal),
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
                    hint: const Text('Filtrar por estado'),
                    value: estado,
                    items: const [
                      DropdownMenuItem<String>(
                        value: "",
                        alignment: Alignment.center,
                        child: Text("Todas"),
                      ),
                      DropdownMenuItem<String>(
                        value: "en_proceso",
                        alignment: Alignment.center,
                        child: Text("En proceso"),
                      ),
                      DropdownMenuItem<String>(
                        value: "completado",
                        alignment: Alignment.center,
                        child: Text("Completadas"),
                      ),
                      DropdownMenuItem<String>(
                        value: "revisado",
                        alignment: Alignment.center,
                        child: Text("Revisadas"),
                      ),
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        estado = newValue;
                        _filtrarTareas();
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    underline: const SizedBox.shrink(),
                    iconEnabledColor: Color(colorPrincipal),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 213,
                  child: TextField(
                    controller: TextEditingController(text: fecha),
                    decoration: InputDecoration(
                      labelText: 'Buscar por fecha',
                      labelStyle: TextStyle(color: Color(colorPrincipal)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(colorPrincipal)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(colorPrincipal), width: 2.0),
                      ),
                      suffixIcon: Icon(Icons.calendar_today,
                          color: Color(colorPrincipal)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          fecha =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          _filtrarTareas();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
      body: tareas.isEmpty
          ? const Center(
              child: Text(
              'Aún tiene tareas asignadas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: tareas.map((tarea) {
                    final details = tarea['details']['details'];
                    final tipo = tarea['details']['tipo'];
                    final status = tarea['completado'] && !tarea['revisado']
                        ? 'Completada'
                        : tarea['revisado']
                            ? 'Revisada'
                            : 'En proceso';
                    final statusColor =
                        tarea['completado'] && !tarea['revisado']
                            ? Color(colorPrincipal)
                            : tarea['revisado']
                                ? Colors.green
                                : Color(colorSecundario);
                    return SizedBox(
                      height: 350,
                      width:
                          MediaQuery.of(context).size.width > 800 ? 200 : 150,
                      child: Stack(
                        children: [
                          TareaCard(
                            ID_tarea: details['ID_tarea'],
                            titulo: details['Titulo'],
                            descripcion: details['Descripcion'],
                            imagenBase64: details['imagenBase64'] ?? '',
                            tipo: tipo,
                            onRevisar: tarea['completado'] && !tarea['revisado']
                                ? () {
                                    _markTaskAsDone(details['ID_tarea'],
                                        widget.nickname, tipo);
                                  }
                                : null,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }

  void _cleanFiltros() {
    setState(() {
      estado = "";
      fecha = "";
      _filtrarTareas();
    });
  }
}
