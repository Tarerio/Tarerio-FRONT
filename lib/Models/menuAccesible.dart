import 'package:flutter/material.dart';

class FontSizes {
  static const double PEQUENIO = 14.0;
  static const double MEDIANO = 18.0;
  static const double GRANDE = 24.0;
  static const double GRANDE_PLUS = 28.0;

  static const double TITLE_PEQUENIO = 16.0;
  static const double TITLE_MEDIANO = 20.0;
  static const double TITLE_GRANDE = 26.0;
  static const double TITLE_GRANDE_PLUS = 30.0;
}

class ColorPalette {
  final Color colorPrincipal;
  final Color colorSecundario;
  final Color fuente;
  final Color fondo;
  final Color componentes;

  const ColorPalette({
    required this.colorPrincipal,
    required this.colorSecundario,
    required this.fuente,
    required this.fondo,
    required this.componentes,
  });

  static const ColorPalette TARERIO = ColorPalette(
    colorPrincipal: Color(0xFF2EC4B6),
    colorSecundario: Color(0xFFFF9800),
    fuente: Colors.black,
    fondo: Colors.white,
    componentes: Colors.teal,
  );
}