import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/Pages/Alumnos/tareaPeticion.dart';
import 'package:tarerio/Pages/Alumnos/tareaPorPasos.dart';
import 'package:tarerio/Pages/Alumnos/tareaJuego.dart';

class TareaAlumnoCard extends StatefulWidget {
  final int idTarea;
  final String text;
  final String descripcion;
  final String imagen;
  final String nickname;
  final ColorPalette colorPalette;
  final double titleFontSize;
  final double textFontSize;
  final BoxConstraints constraints;
  final String tipoTarea;

  const TareaAlumnoCard({
    super.key,
    required this.idTarea,
    required this.text,
    required this.descripcion,
    required this.imagen,
    required this.nickname,
    required this.colorPalette,
    required this.titleFontSize,
    required this.textFontSize,
    required this.constraints,
    required this.tipoTarea,
  });

  @override
  _TareaAlumnoCardState createState() => _TareaAlumnoCardState();
}

class _TareaAlumnoCardState extends State<TareaAlumnoCard> {
  @override
  Widget build(BuildContext context) {
    final isTablet = widget.constraints.maxWidth >= 1200;
    final cardWidth = isTablet
        ? widget.constraints.maxWidth * 0.7
        : widget.constraints.maxWidth * 0.9;
    final cardHeight = widget.constraints.maxHeight * 0.15;

    return Focus(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TareaAlumnoPorPasos(
                idTarea: widget.idTarea,
                nickname: widget.nickname,
                colorPalette: widget.colorPalette,
                textFontSize: widget.textFontSize,
                titleFontSize: widget.titleFontSize,
              ),
            ),
          );
        },
        child: Semantics(
          label: "Tarjeta de tarea: ${widget.text}",
          button: true,
          child: Card(
            color: widget.colorPalette.componentes,
            elevation: 6,
            margin: EdgeInsets.symmetric(
              vertical: widget.constraints.maxHeight * 0.04,
              horizontal: isTablet
                  ? widget.constraints.maxWidth * 0.2
                  : widget.constraints.maxWidth * 0.1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: InkWell(
                focusColor: Colors.blue.withOpacity(0.2),
                hoverColor: Colors.blue.withOpacity(0.1),
                splashColor: Colors.blueAccent,
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                      context,
                      widget.tipoTarea == 'Juego'
                          ? MaterialPageRoute(
                              builder: (context) => TareaAlumnoJuego(
                                idTarea: widget.idTarea,
                                nickname: widget.nickname,
                                colorPalette: widget.colorPalette,
                                textFontSize: widget.textFontSize,
                                titleFontSize: widget.titleFontSize,
                              ),
                            )
                          : widget.tipoTarea == 'Por Pasos'
                              ? MaterialPageRoute(
                                  builder: (context) => TareaAlumnoPorPasos(
                                    idTarea: widget.idTarea,
                                    nickname: widget.nickname,
                                    colorPalette: widget.colorPalette,
                                    textFontSize: widget.textFontSize,
                                    titleFontSize: widget.titleFontSize,
                                  ),
                                )
                              : MaterialPageRoute(
                                  builder: (context) => TareaAlumnoPeticion(
                                    nickname: widget.nickname,
                                    colorPalette: widget.colorPalette,
                                    titleFontSize: widget.titleFontSize,
                                    textFontSize: widget.textFontSize,
                                    idTarea: widget.idTarea,
                                  ),
                                ));
                },
                child: Row(
                  children: [
                    // Imagen
                    Semantics(
                      label: "Imagen relacionada con la tarea",
                      child: Container(
                        width: cardWidth * 0.3,
                        height: cardHeight,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(16)),
                        ),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.memory(base64Decode(widget.imagen)),
                        ),
                      ),
                    ),

                    // Texto de la tarea
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.text.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.colorPalette.fuente,
                            fontSize: widget.textFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
