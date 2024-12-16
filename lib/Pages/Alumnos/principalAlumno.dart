import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/Widgets/Header.dart';
import 'package:tarerio/API/alumnosAPI.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import 'package:tarerio/Widgets/TareaAlumnoCard.dart';

class PrincipalAlumno extends StatefulWidget {
  final String nickname;

  const PrincipalAlumno({super.key, required this.nickname});

  @override
  _PrincipalAlumnoState createState() => _PrincipalAlumnoState();
}

class _PrincipalAlumnoState extends State<PrincipalAlumno> {
  String _selectedTitleFontSize = "MEDIANO";
  String _selectedTextFontSize = "MEDIANO";
  String _selectedPalette = 'TARERIO';

  final AlumnosAPI _api = AlumnosAPI();
  final TareaJuegoAPI _tareaJuegoAPI = TareaJuegoAPI();
  final TareaPeticionAPI _tareaPeticionAPI = TareaPeticionAPI();
  final TareaPorPasosAPI _tareaPorPasosAPI = TareaPorPasosAPI();

  List<Map<String, dynamic>> _tareasDeHoy =
      []; // Lista de tareas del día actual

  @override
  void initState() {
    super.initState();
    _loadTareasDeHoy(); // Cargar las tareas del día al iniciar
    _loadMenuAccesible(); // Cargar las configuraciones de accesibilidad
  }

  void _loadTareasDeHoy() async {
    try {
      String fechaHoy = DateFormat('yyyy-MM-dd').format(DateTime.now());
      List<Map<String, dynamic>> tareas = [];
      List<Map<String, dynamic>> tareasAlumnoDeHoy = [];

      final tareasPorPasosAsignadas =
          await _tareaPorPasosAPI.obtenerAsignadasAlumno(
        widget.nickname,
        '',
        fechaHoy,
      );

      final tareasPeticionAsignadas =
          await _tareaPeticionAPI.obtenerAsignadasAlumno(
        widget.nickname,
        '',
        fechaHoy,
      );

      final tareasJuegoAsignadas = await _tareaJuegoAPI.obtenerAsignadasAlumno(
        widget.nickname,
        '',
        fechaHoy,
      );

      for (var tarea in tareasPorPasosAsignadas) {
        tareas.add({'tarea': tarea, 'tipo': 'Por Pasos'});
      }

      for (var tarea in tareasPeticionAsignadas) {
        tareas.add({'tarea': tarea, 'tipo': 'Peticion'});
      }

      for (var tarea in tareasJuegoAsignadas) {
        tareas.add({'tarea': tarea, 'tipo': 'Juego'});
      }

      tareas.sort((a, b) {
        DateTime fechaA = DateTime.parse(a['tarea']['Fecha_fin_asignacion']);
        DateTime fechaB = DateTime.parse(b['tarea']['Fecha_fin_asignacion']);
        return fechaA.compareTo(fechaB);
      });

      for (var i = 0; i < tareas.length; i++) {
        switch (tareas[i]['tipo']) {
          case 'Juego':
            final idTarea = tareas[i]['tarea']['ID_tarea'];
            final tarea = await _tareaJuegoAPI.obtenerTareaByID(idTarea);
            tareasAlumnoDeHoy.add({
              'tarea': tarea,
              'tipo': 'Juego',
              'completado': tareas[i]['tarea']['completado']
            });
          case 'Por Pasos':
            final idTarea = tareas[i]['tarea']['ID_tarea'];
            final tarea = await _tareaPorPasosAPI.obtenerTareaByID(idTarea);
            tareasAlumnoDeHoy.add({
              'tarea': tarea,
              'tipo': 'Por Pasos',
              'completado': tareas[i]['tarea']['completado']
            });
          case 'Peticion':
            final idTarea = tareas[i]['tarea']['ID_tarea'];
            final tarea = await _tareaPeticionAPI.obtenerTareaByID(idTarea);
            tareasAlumnoDeHoy.add({
              'tarea': tarea,
              'tipo': 'Peticion',
              'completado': tareas[i]['tarea']['completado']
            });
        }
      }
      setState(() {
        _tareasDeHoy = tareasAlumnoDeHoy;
      });
    } catch (e) {
      print("Error al cargar las tareas del día: $e");
    }
  }

  void _loadMenuAccesible() async {
    try {
      final response = await _api.obtenerMenuAccesible(widget.nickname);
      setState(() {
        _selectedTitleFontSize = response['texto_titulo'];
        _selectedTextFontSize = response['texto_descripcion'];
        _selectedPalette = response['paleta_colores'];
      });
    } catch (e) {
      // Handle error if needed
    }
  }

  double _getFontSize(String size) {
    switch (size) {
      case "PEQUENIO":
        return FontSizes.PEQUENIO;
      case "MEDIANO":
        return FontSizes.MEDIANO;
      case "GRANDE":
        return FontSizes.GRANDE;
      case "GRANDE+":
        return FontSizes.GRANDE_PLUS;
      default:
        return FontSizes.MEDIANO;
    }
  }

  ColorPalette _getColorPalette(String palette) {
    switch (palette) {
      case 'TARERIO':
        return ColorPalette.TARERIO;
      case 'TARERIO_INV':
        return ColorPalette.TARERIO_INV;
      case 'HIGH_CONTRAST':
        return ColorPalette.HIGH_CONTRAST;
      case 'SOFT_PASTEL':
        return ColorPalette.SOFT_PASTEL;
      case 'DARK_MODE':
        return ColorPalette.DARK_MODE;
      default:
        return ColorPalette.TARERIO;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorPalette = _getColorPalette(_selectedPalette);
    final textFontSize = _getFontSize(_selectedTextFontSize);
    final titleFontSize = _getFontSize(_selectedTitleFontSize);

    return LayoutBuilder(
      builder: (context, constraints) {
        double titleFontSize = constraints.maxWidth * 0.05;
        return Scaffold(
          appBar: Header(
            nickname: widget.nickname,
            colorPalette: colorPalette,
            titleFontSize: titleFontSize,
            textFontSize: textFontSize,
          ),
          backgroundColor: colorPalette.fondo,
          body: Column(
            children: [
              // Título principal
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "TAREAS DEL DÍA",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w800,
                    color: colorPalette.fuente,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Área de tareas
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: _tareasDeHoy.isEmpty
                      ? Center(
                          child: Text(
                            "NO HAY TAREAS PARA EL USUARIO EL DÍA DE HOY.",
                            style: TextStyle(
                              fontSize: textFontSize,
                              color: colorPalette.fuente,
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _tareasDeHoy.length > 3
                                    ? 3
                                    : _tareasDeHoy.length,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                itemBuilder: (context, index) {
                                  print(_tareasDeHoy[index]['completado']);
                                  return TareaAlumnoCard(
                                    idTarea: _tareasDeHoy[index]['tarea']
                                        ['ID_tarea'],
                                    text: _tareasDeHoy[index]['tarea']
                                            ['Titulo'] ??
                                        'Tarea sin nombre',
                                    descripcion: _tareasDeHoy[index]['tarea']
                                            ['Descripcion'] ??
                                        'No hay descripción',
                                    imagen: _tareasDeHoy[index]['tarea']
                                            ['imagenBase64'] ??
                                        '',
                                    nickname: widget.nickname,
                                    colorPalette: colorPalette,
                                    titleFontSize: titleFontSize,
                                    textFontSize: textFontSize,
                                    constraints: constraints,
                                    tipoTarea: _tareasDeHoy[index]['tipo'],
                                    completada: _tareasDeHoy[index]['completado'],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
