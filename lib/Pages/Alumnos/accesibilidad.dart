import 'package:flutter/material.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';

import '../../consts.dart'; // Adjust the import path as needed

class AccesibilidadPage extends StatefulWidget {
  final String nickname;

  const AccesibilidadPage({Key? key, required this.nickname}) : super(key: key);

  @override
  _AccesibilidadPageState createState() => _AccesibilidadPageState();
}

class _AccesibilidadPageState extends State<AccesibilidadPage> {
  double _selectedTitleFontSize = FontSizes.TITLE_MEDIANO;
  double _selectedTextFontSize = FontSizes.MEDIANO;
  ColorPalette _selectedPalette = ColorPalette.TARERIO;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menú de Accesibilidad ',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text (
                  'Menú accesible de ${widget.nickname}',
                  style: TextStyle(
                    fontSize: 35,
                    color: Color(0xFF2EC4B6),
                  ),
                ),
              ),
              Text(
                'Selecciona la fuente de títulos:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              DropdownButton<double>(
                value: _selectedTitleFontSize,
                items: [
                  DropdownMenuItem(
                    value: FontSizes.TITLE_PEQUENIO,
                    child: Text('Pequeño (16)'),
                  ),
                  DropdownMenuItem(
                    value: FontSizes.TITLE_MEDIANO,
                    child: Text('Mediano (20)'),
                  ),
                  DropdownMenuItem(
                    value: FontSizes.TITLE_GRANDE,
                    child: Text('Grande (26)'),
                  ),
                  DropdownMenuItem(
                    value: FontSizes.TITLE_GRANDE_PLUS,
                    child: Text('Grande+ (30)'),
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
              DropdownButton<double>(
                value: _selectedTextFontSize,
                items: [
                  DropdownMenuItem(
                    value: FontSizes.PEQUENIO,
                    child: Text('Pequeño (14)'),
                  ),
                  DropdownMenuItem(
                    value: FontSizes.MEDIANO,
                    child: Text('Mediano (18)'),
                  ),
                  DropdownMenuItem(
                    value: FontSizes.GRANDE,
                    child: Text('Grande (24)'),
                  ),
                  DropdownMenuItem(
                    value: FontSizes.GRANDE_PLUS,
                    child: Text('Grande+ (28)'),
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
              DropdownButton<ColorPalette>(
                value: _selectedPalette,
                items: [
                  DropdownMenuItem(
                    value: ColorPalette.TARERIO,
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
                    value: ColorPalette.TARERIO_INV,
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
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPalette = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              DefaultButton(text: "Actualizar", onPressed: () {}, color: Color(0xFF2EC4B6)),
            ],
          ),
        ),
      ),
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