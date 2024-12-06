import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarerio/Widgets/Header.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';

class CalendarPage extends StatefulWidget {
  final String nickname;
  final ColorPalette colorPalette;
  final double titleFontSize;
  final double textFontSize;

  const CalendarPage({
    super.key,
    required this.nickname,
    required this.colorPalette,
    required this.titleFontSize,
    required this.textFontSize,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int _currentDayIndex =
      0; // Índice del día actual (0 = Lunes, 1 = Martes, ...)
  final TareaJuegoAPI _tareaJuegoAPI = TareaJuegoAPI();
  final TareaPeticionAPI _tareaPeticionAPI = TareaPeticionAPI();
  final TareaPorPasosAPI _tareaPorPasosAPI = TareaPorPasosAPI();

  // Lista de tareas por día
  final Map<String, List<Map<String, dynamic>>> _tasks = {
    'Lunes': [],
    'Martes': [],
    'Miércoles': [],
    'Jueves': [],
    'Viernes': [],
    'Sábado': [],
    'Domingo': [],
  };

  @override
  void initState() {
    super.initState();
    _loadTareasDeLaSemana();
  }

  void _loadTareasDeLaSemana() async {
    try {
      // Obtener el lunes de la semana actual
      DateTime hoy = DateTime.now();
      int diasDesdeLunes = hoy.weekday - DateTime.monday;
      DateTime lunes = hoy.subtract(Duration(days: diasDesdeLunes));

      // Nombres de los días de la semana
      List<String> diasSemana = [
        'Lunes',
        'Martes',
        'Miércoles',
        'Jueves',
        'Viernes',
        'Sábado',
        'Domingo'
      ];

      for (int i = 0; i < diasSemana.length; i++) {
        // Calcular la fecha para cada día de la semana
        DateTime fechaDia = lunes.add(Duration(days: i));
        String fechaStr = DateFormat('yyyy-MM-dd').format(fechaDia);

        // Obtener las TAREAS POR PASOS del día actual
        List<Map<String, dynamic>> tareasPorPasos =
            await _tareaPorPasosAPI.obtenerAsignadasAlumno(
          widget.nickname,
          '',
          fechaStr,
        );

        for (int j = 0;
            tareasPorPasos.isNotEmpty && j < tareasPorPasos.length;
            j++) {
          int idTarea = tareasPorPasos[j]['ID_tarea'];
          final tarea = await _tareaPorPasosAPI.obtenerTareaByID(idTarea);
          _tasks[diasSemana[i]]!.add(tarea);
        }

        // Obtener las TAREAS PETICION del día actual
        List<Map<String, dynamic>> tareasPeticion =
            await _tareaPeticionAPI.obtenerAsignadasAlumno(
          widget.nickname,
          '',
          fechaStr,
        );

        for (int j = 0; j < tareasPeticion.length; j++) {
          int idTarea = tareasPeticion[j]['ID_tarea'];
          final tarea = await _tareaPeticionAPI.obtenerTareaByID(idTarea);
          _tasks[diasSemana[i]]?.add(tarea);
        }

        // Obtener las TAREAS JUEGO del día actual
        List<Map<String, dynamic>> tareasJuego =
            await _tareaJuegoAPI.obtenerAsignadasAlumno(
          widget.nickname,
          '',
          fechaStr,
        );

        for (int j = 0; j < tareasJuego.length; j++) {
          int idTarea = tareasJuego[j]['ID_tarea'];
          final tarea = await _tareaJuegoAPI.obtenerTareaByID(idTarea);
          _tasks[diasSemana[i]]?.add(tarea);
        }
      }
    } catch (e) {
      print("Error al cargar las tareas de la semana: $e");
    }
  }

  // Obtiene el día de la semana actual basado en el índice
  String get currentDay => _tasks.keys.toList()[_currentDayIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        nickname: widget.nickname,
        colorPalette: widget.colorPalette,
        textFontSize: widget.textFontSize,
        titleFontSize: widget.titleFontSize,
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 30.0)),
          // Día actual
          Text(
            currentDay.toUpperCase(),
            style: TextStyle(
              fontSize: widget.titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Flechas y lista de tareas en una fila
          Expanded(
            child: Row(
              children: [
                // Flecha izquierda
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: widget.colorPalette.colorSecundario,
                    size: 90,
                  ),
                  onPressed: _currentDayIndex > 0
                      ? () {
                          setState(() {
                            _currentDayIndex--;
                          });
                        }
                      : null,
                ),

                // Lista de tareas
                Expanded(
                  child: Center(
                    child: _tasks[currentDay]!.isEmpty
                        ? Text(
                            'NO HAY TAREAS PARA ESTE DÍA',
                            style: TextStyle(
                                fontSize: widget.textFontSize,
                                color: Colors.grey),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.8, // Ajustar ancho
                            child: ListView.builder(
                              shrinkWrap:
                                  true, // Permite que se ajuste al contenido
                              itemCount: _tasks[currentDay]!.length,
                              itemBuilder: (context, index) {
                                final tarea = _tasks[currentDay]![index];
                                return ListTile(
                                  leading:
                                      const Icon(Icons.check_circle_outline),
                                  title: Text(
                                    tarea['Titulo'] ?? 'TAREA SIN NOMBRE',
                                    style: TextStyle(
                                        fontSize: widget.textFontSize),
                                  ),
                                  subtitle: Text(
                                    tarea['Descripcion'] ?? 'SIN DESCRIPCIÓN',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),

                // Flecha derecha
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: widget.colorPalette.colorSecundario,
                    size: 90,
                  ),
                  onPressed: _currentDayIndex < _tasks.keys.length - 1
                      ? () {
                          setState(() {
                            _currentDayIndex++;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
