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

  static const ColorPalette TARERIO_INV = ColorPalette(
    colorPrincipal: Color(0xFFFF9800),
    colorSecundario: Color(0xFF2EC4B6),
    fuente: Colors.black,
    fondo: Colors.white,
    componentes: Colors.deepOrangeAccent,
  );


  static const ColorPalette HIGH_CONTRAST = ColorPalette(
    colorPrincipal: Color(0xFF000000),
    colorSecundario: Color(0xFF888383),
    fuente: Colors.yellow,
    fondo: Colors.black,
    componentes: Color(0xFF222121),
  );

  static const ColorPalette SOFT_PASTEL = ColorPalette(
    colorPrincipal: Color(0xFFB3E5FC),
    colorSecundario: Color(0xFFFFF9C4),
    fuente: Colors.black,
    fondo: Colors.white,
    componentes: Color(0xFFFFCCBC),
  );

  static const ColorPalette DARK_MODE = ColorPalette(
    colorPrincipal: Color(0xFF212121),
    colorSecundario: Color(0xFF757575),
    fuente: Colors.white,
    fondo: Color(0xFF303030),
    componentes: Color(0xFF424242),
  );
}