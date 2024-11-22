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

    return Scaffold(
      appBar: Header(nickname: widget.nickname),
      backgroundColor: colorPalette.fondo,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "TAREAS DEL DÍA",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Mostrar las tareas obtenidas
            Expanded(
              child: _tareasDeHoy.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay tareas asignadas para hoy.",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tareasDeHoy.length,
                      itemBuilder: (context, index) {
                        final tarea = _tareasDeHoy[index];
                        print(tarea);
                        return _buildTaskCard(
                          tarea['Titulo'] ?? 'Tarea sin nombre'
                                           
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(String text) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => {},
      ),
    );
  }
}
