import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarerio/Widgets/Header.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import 'package:tarerio/Widgets/TareaAlumnoCard.dart';

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
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int _currentDayIndex = 0;
  final TareaJuegoAPI _tareaJuegoAPI = TareaJuegoAPI();
  final TareaPeticionAPI _tareaPeticionAPI = TareaPeticionAPI();
  final TareaPorPasosAPI _tareaPorPasosAPI = TareaPorPasosAPI();

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
      DateTime hoy = DateTime.now();
      int diasDesdeLunes = hoy.weekday - DateTime.monday;
      DateTime lunes = hoy.subtract(Duration(days: diasDesdeLunes));

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
        DateTime fechaDia = lunes.add(Duration(days: i));
        String fechaStr = DateFormat('yyyy-MM-dd').format(fechaDia);

        List<Map<String, dynamic>> tareasPorPasos = await _tareaPorPasosAPI
            .obtenerAsignadasAlumno(widget.nickname, '', fechaStr);

        for (var tarea in tareasPorPasos) {
          int idTarea = tarea['ID_tarea'];
          final tareaData = await _tareaPorPasosAPI.obtenerTareaByID(idTarea);
          _tasks[diasSemana[i]]?.add(tareaData);
        }

        List<Map<String, dynamic>> tareasPeticion = await _tareaPeticionAPI
            .obtenerAsignadasAlumno(widget.nickname, '', fechaStr);

        for (var tarea in tareasPeticion) {
          int idTarea = tarea['ID_tarea'];
          final tareaData = await _tareaPeticionAPI.obtenerTareaByID(idTarea);
          _tasks[diasSemana[i]]?.add(tareaData);
        }

        List<Map<String, dynamic>> tareasJuego = await _tareaJuegoAPI
            .obtenerAsignadasAlumno(widget.nickname, '', fechaStr);

        for (var tarea in tareasJuego) {
          int idTarea = tarea['ID_tarea'];
          final tareaData = await _tareaJuegoAPI.obtenerTareaByID(idTarea);
          _tasks[diasSemana[i]]?.add(tareaData);
        }
      }
    } catch (e) {
      print("Error al cargar las tareas de la semana: $e");
    }
  }

  String get currentDay => _tasks.keys.toList()[_currentDayIndex];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
              Text(
                currentDay.toUpperCase(),
                style: TextStyle(
                  fontSize: widget.titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
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
                    Expanded(
                      child: Center(
                        child: _tasks[currentDay]!.isEmpty
                            ? Text(
                                'NO HAY TAREAS PARA ESTE DÍA',
                                style: TextStyle(
                                  fontSize: widget.textFontSize,
                                  color: Colors.grey,
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _tasks[currentDay]!.length,
                                itemBuilder: (context, index) {
                                  final tarea = _tasks[currentDay]![index];
                                  return TareaAlumnoCard(
                                    text: tarea['Titulo'],
                                    descripcion: tarea['Descripcion'],
                                    imagen: tarea['imagenBase64'],
                                    nickname: widget.nickname,
                                    colorPalette: widget.colorPalette,
                                    titleFontSize: widget.titleFontSize,
                                    textFontSize: widget.textFontSize,
                                    constraints: constraints,
                                    idTarea: tarea['ID_tarea'],
                                  );
                                },
                              ),
                      ),
                    ),
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
      },
    );
  }
}
