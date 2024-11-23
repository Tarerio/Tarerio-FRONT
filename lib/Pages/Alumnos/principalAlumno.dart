import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
import '../../Models/menuAccesible.dart';
import '../../Widgets/Header.dart';
import '../../API/alumnosAPI.dart';
import '../../API/tareaJuegoAPI.dart';
import '../../API/tareaPeticionAPI.dart';
import '../../API/tareaPorPasosAPI.dart';
import '../../API/alumnosAPI.dart';

class PrincipalAlumno extends StatefulWidget {
  final String nickname;

  PrincipalAlumno({super.key, required this.nickname});

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
            tareasAlumnoDeHoy.add(tarea);
          case 'Por Pasos':
            final idTarea = tareas[i]['tarea']['ID_tarea'];
            final tarea = await _tareaPorPasosAPI.obtenerTareaByID(idTarea);
            tareasAlumnoDeHoy.add(tarea);
          case 'Peticion':
            final idTarea = tareas[i]['tarea']['ID_tarea'];
            final tarea = await _tareaPeticionAPI.obtenerTareaByID(idTarea);
            tareasAlumnoDeHoy.add(tarea);
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
        _selectedTitleFontSize =
            response['texto_titulo'] ?? _selectedTitleFontSize;
        _selectedTextFontSize =
            response['texto_descripcion'] ?? _selectedTextFontSize;
        _selectedPalette = response['paleta_colores'] ?? _selectedPalette;
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
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      appBar: Header(nickname: widget.nickname),
      backgroundColor: colorPalette.fondo,
      body: Column(
        children: [
          // Título principal
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "TAREAS DEL DÍA",
              style: TextStyle(
                fontSize: isTablet ? 75 : 32, // Ajuste según tablet o móvil
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Área de tareas
          Expanded(
            child: Column(
              children: [
                for (int i = 0;
                    i < (_tareasDeHoy.length > 3 ? 3 : _tareasDeHoy.length);
                    i++)
                  Expanded(
                    child: _buildTaskCard(
                      _tareasDeHoy[i]['Titulo'] ?? 'Tarea sin nombre',
                      _tareasDeHoy[i]['imagenBase64'] ?? '',
                      context,
                    ),
                  ),
                if (_tareasDeHoy.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        "No hay tareas asignadas para hoy.",
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String text, String imagen, BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    final cardWidth = isTablet ? 500.0 : 300.0;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Imagen proporcional
          Container(
            width: cardWidth * 0.5,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              image: DecorationImage(
                image: MemoryImage(base64Decode(imagen)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Texto al lado de la imagen
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isTablet ? 70 : 50, // Ajuste del tamaño de fuente
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
