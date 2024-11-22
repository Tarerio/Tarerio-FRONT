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

  // Función para cargar las tareas del día actual
  void _loadTareasDeHoy() async {
    try {
      String fechaHoy = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final tareasPorPasosAsignadas =
          await _tareaPorPasosAPI.obtenerAsignadasAlumno(
        widget.nickname,
        '',
        fechaHoy,
      );

      List tareasPorPasos = [];

      for (int i = 0; i < tareasPorPasosAsignadas.length; i++) {
        final idTarea = tareasPorPasosAsignadas[i]['ID_tarea'];
        final tarea = await _tareaPorPasosAPI.obtenerTareaByID(idTarea);
        tareasPorPasos.add(tarea);
      }

      final tareasPeticionAsignadas =
          await _tareaPeticionAPI.obtenerAsignadasAlumno(
        widget.nickname,
        '',
        fechaHoy,
      );

      List tareasPeticion = [];

      for (int i = 0; i < tareasPeticionAsignadas.length; i++) {
        final idTarea = tareasPeticionAsignadas[i]['ID_tarea'];
        final tarea = await _tareaPeticionAPI.obtenerTareaByID(idTarea);
        tareasPeticion.add(tarea);
      }

      final tareasJuegoAsignadas = await _tareaJuegoAPI.obtenerAsignadasAlumno(
        widget.nickname,
        '',
        fechaHoy,
      );

      List tareasJuego = [];

      for (int i = 0; i < tareasJuegoAsignadas.length; i++) {
        final idTarea = tareasJuegoAsignadas[i]['ID_tarea'];
        final tarea = await _tareaJuegoAPI.obtenerTareaByID(idTarea);
        tareasJuego.add(tarea);
      }

      setState(() {
        _tareasDeHoy = [
          ...(tareasPorPasos),
          ...(tareasPeticion),
          ...(tareasJuego),
        ];
      });
    } catch (e) {
      print("Error al cargar las tareas del día: $e");
    }
  }

  void _loadMenuAccesible() async {
    try {
      final response = await _api.obtenerMenuAccesible(widget.nickname);
      if (response != null) {
        setState(() {
          _selectedTitleFontSize =
              response['texto_titulo'] ?? _selectedTitleFontSize;
          _selectedTextFontSize =
              response['texto_descripcion'] ?? _selectedTextFontSize;
          _selectedPalette = response['paleta_colores'] ?? _selectedPalette;
        });
      }
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
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    appBar: Header(nickname: widget.nickname),
    backgroundColor: colorPalette.fondo,
    body: Padding(
      padding: EdgeInsets.all(screenWidth * 0.05), // Ajuste dinámico del padding
      child: Column(
        children: [
          Text(
            "TAREAS DEL DÍA",
            style: TextStyle(
              fontSize: screenWidth * 0.ç1, // Ajuste dinámico del tamaño de la fuente
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _tareasDeHoy.isEmpty
                ? Center(
                    child: Text(
                      "No hay tareas asignadas para hoy.",
                      style: TextStyle(fontSize: screenWidth * 0.05), // Ajuste dinámico
                    ),
                  )
                : ListView.builder(
                    itemCount: _tareasDeHoy.take(3).length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final tarea = _tareasDeHoy[index];
                      return _buildTaskCard(
                        tarea['Titulo'] ?? 'Tarea sin nombre',
                        tarea['imagenBase64'] ?? '',
                        screenWidth, screenHeight,
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTaskCard(String text, String imagen, double screenWidth, double screenHeight) {
  return Card(
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.03, horizontal: screenWidth * 0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        // Imagen que ocupa todo el alto de la tarjeta
        Container(
          height: screenHeight * 0.15,  // Ajuste dinámico del tamaño de la imagen
          width: screenWidth * 0.3,     // Ajuste dinámico del ancho de la imagen
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
            image: DecorationImage(
              image: MemoryImage(base64Decode(imagen)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Texto al lado de la imagen
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),  // Ajuste dinámico del padding
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.08,  // Ajuste dinámico del tamaño de la fuente
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
