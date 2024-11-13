import 'package:flutter/material.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';

import '../../Widgets/ErrorModal.dart';
import '../../Widgets/SuccessModal.dart';
import '../../API/alumnosAPI.dart';

class AccesibilidadPage extends StatefulWidget {
  final String nickname;

  const AccesibilidadPage({Key? key, required this.nickname}) : super(key: key);

  @override
  _AccesibilidadPageState createState() => _AccesibilidadPageState();
}

class _AccesibilidadPageState extends State<AccesibilidadPage> {
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

  void crearModificarMenuAccesible(BuildContext context) async {
    try {
      final response = await _api.crearModificarMenuAccesible(widget.nickname, _selectedTitleFontSize, _selectedTextFontSize, _selectedPalette);
      if (response['status'] != 'error') {
        _showSuccessModal(context, 'Éxito', 'Configuración de accesibilidad actualizada correctamente.');
      } else {
        _showErrorModal(context, 'Error', 'Ocurrió un error al intentar actualizar la configuración de accesibilidad.');
      }
    } catch (e) {
      _showErrorModal(context, 'Error', 'Ocurrió un error al intentar actualizar la configuración de accesibilidad.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accesibilidad ${widget.nickname}',
          style: TextStyle(
            color: Color(0xFF2EC4B6),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Selecciona la fuente de títulos:',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<String>(
                        value: _selectedTitleFontSize,
                        items: [
                          DropdownMenuItem(
                            value: "PEQUEÑO",
                            child: Text('PEQUEÑO (14)'),
                          ),
                          DropdownMenuItem(
                            value: "MEDIANO",
                            child: Text('MEDIANO (18)'),
                          ),
                          DropdownMenuItem(
                            value: "GRANDE",
                            child: Text('GRANDE (24)'),
                          ),
                          DropdownMenuItem(
                            value: "GRANDE+",
                            child: Text('GRANDE+ (28)'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedTitleFontSize = value!;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Selecciona la fuente para el texto normal:',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<String>(
                        value: _selectedTextFontSize,
                        items: [
                          DropdownMenuItem(
                            value: "PEQUEÑO",
                            child: Text('PEQUEÑO (16)'),
                          ),
                          DropdownMenuItem(
                            value: "MEDIANO",
                            child: Text('MEDIANO (20)'),
                          ),
                          DropdownMenuItem(
                            value: "GRANDE",
                            child: Text('GRANDE (26)'),
                          ),
                          DropdownMenuItem(
                            value: "GRANDE+",
                            child: Text('GRANDE+ (30)'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedTextFontSize = value!;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Selecciona la paleta de colores:',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<String>(
                        value: _selectedPalette,
                        items: [
                          DropdownMenuItem(
                            value: 'TARERIO',
                            child: Row(
                              children: [
                                _buildColorBox(ColorPalette.TARERIO.colorPrincipal),
                                _buildColorBox(ColorPalette.TARERIO.colorSecundario),
                                _buildColorBox(ColorPalette.TARERIO.fuente),
                                _buildColorBox(ColorPalette.TARERIO.fondo),
                                _buildColorBox(ColorPalette.TARERIO.componentes),
                                SizedBox(width: 10),
                                Text('TARERIO'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'TARERIO_INV',
                            child: Row(
                              children: [
                                _buildColorBox(ColorPalette.TARERIO_INV.colorPrincipal),
                                _buildColorBox(ColorPalette.TARERIO_INV.colorSecundario),
                                _buildColorBox(ColorPalette.TARERIO_INV.fuente),
                                _buildColorBox(ColorPalette.TARERIO_INV.fondo),
                                _buildColorBox(ColorPalette.TARERIO_INV.componentes),
                                SizedBox(width: 10),
                                Text('TARERIO_INV'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'HIGH_CONTRAST',
                            child: Row(
                              children: [
                                _buildColorBox(ColorPalette.HIGH_CONTRAST.colorPrincipal),
                                _buildColorBox(ColorPalette.HIGH_CONTRAST.colorSecundario),
                                _buildColorBox(ColorPalette.HIGH_CONTRAST.fuente),
                                _buildColorBox(ColorPalette.HIGH_CONTRAST.fondo),
                                _buildColorBox(ColorPalette.HIGH_CONTRAST.componentes),
                                SizedBox(width: 10),
                                Text('HIGH_CONTRAST'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'SOFT_PASTEL',
                            child: Row(
                              children: [
                                _buildColorBox(ColorPalette.SOFT_PASTEL.colorPrincipal),
                                _buildColorBox(ColorPalette.SOFT_PASTEL.colorSecundario),
                                _buildColorBox(ColorPalette.SOFT_PASTEL.fuente),
                                _buildColorBox(ColorPalette.SOFT_PASTEL.fondo),
                                _buildColorBox(ColorPalette.SOFT_PASTEL.componentes),
                                SizedBox(width: 10),
                                Text('SOFT_PASTEL'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'DARK_MODE',
                            child: Row(
                              children: [
                                _buildColorBox(ColorPalette.DARK_MODE.colorPrincipal),
                                _buildColorBox(ColorPalette.DARK_MODE.colorSecundario),
                                _buildColorBox(ColorPalette.DARK_MODE.fuente),
                                _buildColorBox(ColorPalette.DARK_MODE.fondo),
                                _buildColorBox(ColorPalette.DARK_MODE.componentes),
                                SizedBox(width: 10),
                                Text('DARK_MODE'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedPalette = value!;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DefaultButton(text: "Actualizar", onPressed: () {
                        crearModificarMenuAccesible(context);
                      }, color: Color(0xFF2EC4B6)),
                    ],
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: Container(
                    color: _getColorPalette(_selectedPalette).fondo,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Ejemplo de Título',
                          style: TextStyle(
                            fontSize: _getFontSize(_selectedTitleFontSize),
                            fontWeight: FontWeight.bold,
                            color: _getColorPalette(_selectedPalette).fuente,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Ejemplo de Texto',
                          style: TextStyle(
                            fontSize: _getFontSize(_selectedTextFontSize),
                            color: _getColorPalette(_selectedPalette).fuente,
                          ),
                        ),
                        SizedBox(height: 20),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildColorCircle(_getColorPalette(_selectedPalette).colorPrincipal, 'Principal'),
                            _buildColorCircle(_getColorPalette(_selectedPalette).colorSecundario, 'Secundario'),
                            _buildColorCircle(_getColorPalette(_selectedPalette).fondo, 'Fondo'),
                            _buildColorCircle(_getColorPalette(_selectedPalette).componentes, 'Componentes'),
                            _buildColorCircle(_getColorPalette(_selectedPalette).fuente, 'Fuente'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getFontSize(String size) {
    switch (size) {
      case "PEQUEÑO":
        return 14.0;
      case "MEDIANO":
        return 18.0;
      case "GRANDE":
        return 24.0;
      case "GRANDE+":
        return 28.0;
      default:
        return 18.0;
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

  Widget _buildColorCircle(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: _getColorPalette(_selectedPalette).fuente, width: 2),
          ),
          margin: EdgeInsets.symmetric(horizontal: 5),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle( fontSize: 16, color: _getColorPalette(_selectedPalette).fuente),),
      ],
    );
  }

  Widget _buildColorBox(Color color) {
    return Container(
      width: 20,
      height: 20,
      color: color,
      margin: EdgeInsets.symmetric(horizontal: 2),
    );
  }
}