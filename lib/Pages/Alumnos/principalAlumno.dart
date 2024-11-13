import 'package:flutter/material.dart';
import '../../Models/menuAccesible.dart';
import '../../Widgets/Header.dart';
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

  @override
  void initState() {
    super.initState();
    _loadMenuAccesible();
  }

  void _loadMenuAccesible() async {
    try {
      final response = await _api.obtenerMenuAccesible(widget.nickname);
      if (response != null) {
        setState(() {
          _selectedTitleFontSize = response['texto_titulo'] ?? _selectedTitleFontSize;
          _selectedTextFontSize = response['texto_descripcion'] ?? _selectedTextFontSize;
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Este es un título',
              style: TextStyle(
                fontSize: _getFontSize(_selectedTitleFontSize),
                fontWeight: FontWeight.bold,
                color: colorPalette.fuente,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(
                fontSize: _getFontSize(_selectedTextFontSize),
                color: colorPalette.fuente,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorCircle(colorPalette.colorPrincipal, 'Primario', colorPalette.fuente),
                _buildColorCircle(colorPalette.colorSecundario, 'Secundario', colorPalette.fuente),
                _buildColorCircle(colorPalette.componentes, 'Componentes', colorPalette.fuente),
                _buildColorCircle(colorPalette.fuente, 'Texto', colorPalette.fuente),
                _buildColorCircle(colorPalette.fondo, 'Fondo', colorPalette.fuente),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color color, String label, Color borderColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: TextStyle(color: borderColor, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}