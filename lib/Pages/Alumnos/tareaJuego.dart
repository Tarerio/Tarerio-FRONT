import 'dart:convert';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Header.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/Pages/Alumnos/finalizarTarea.dart';

class TareaAlumnoJuego extends StatefulWidget {
  final String nickname;
  final ColorPalette colorPalette;
  final double titleFontSize;
  final double textFontSize;
  final int idTarea;

  const TareaAlumnoJuego({
    super.key,
    required this.nickname,
    required this.colorPalette,
    required this.titleFontSize,
    required this.textFontSize,
    required this.idTarea,
  });
  @override
  // ignore: library_private_types_in_public_api
  _TareaAlumno createState() => _TareaAlumno();
}

class _TareaAlumno extends State<TareaAlumnoJuego> {
  final TareaJuegoAPI _tareaJuegoAPI = TareaJuegoAPI();

  Map<String, dynamic> tareaJuego = {};
  Uint8List fotoTexto = Uint8List(0);
  Uri link = Uri.parse('');

  @override
  void initState() {
    super.initState();
    cargarInfoTarea();
  }

  void cargarInfoTarea() async {
    try {
      final tarea = await _tareaJuegoAPI.obtenerTareaByID(widget.idTarea);
      // Una vez que se obtiene la tarea, actualiza el estado
      setState(() {
        tareaJuego = tarea;
        fotoTexto = base64Decode(tareaJuego['imagenBase64']);
        link = Uri.parse(tareaJuego['Enlace']);
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> _abrirLink() async {
    if (await canLaunchUrl(link)) {
      await launchUrl(link);
    } else {
      throw 'No se pudo abrir el enlace';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        nickname: widget.nickname,
        colorPalette: widget.colorPalette,
        titleFontSize: widget.titleFontSize,
        textFontSize: widget.textFontSize,
      ),
      body: Column(
        children: [
          // Título y descripción en la parte superior
          Padding(
            padding: const EdgeInsets.all(16.0), // Margen alrededor
            child: Column(
              children: [
                Semantics(
                  label:
                      'Título de la tarea: ${tareaJuego['Titulo'] ?? 'Sin título'}',
                  child: Text(
                    (tareaJuego['Titulo'] ?? 'Sin título').toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                    height: 20), // Espaciado entre título y descripción
                Semantics(
                  label:
                      'Descripción de la tarea: ${tareaJuego['Descripcion'] ?? 'Sin descripción'}',
                  child: Text(
                    (tareaJuego['Descripcion'] ?? 'Sin descripción').toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.textFontSize,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Espacio entre título y contenido principal
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flecha izquierda
                Semantics(
                  button: true,
                  label: 'Retroceder a la pantalla anterior',
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new,
                        color: widget.colorPalette.componentes, size: 90),
                    onPressed: () =>
                        {Navigator.pop(context)}, // Retroceder paso
                  ),
                ),
                // Imagen centrada verticalmente
                Semantics(
                  label: tareaJuego['imagenBase64'] != null
                      ? 'Imagen representativa de la tarea'
                      : 'No hay imagen disponible',
                  child: tareaJuego.isEmpty || fotoTexto.isEmpty
                      ? const CircularProgressIndicator() // Indicador de carga
                      : tareaJuego['imagenBase64'] != null
                          ? InkWell(
                              onTap:
                                  _abrirLink, // Abre el enlace al hacer click
                              child: Image.memory(
                                fotoTexto,
                                width: 350,
                                height: 350,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Text(
                              'No hay imagen disponible'.toUpperCase(),
                              style: TextStyle(
                                fontSize: widget.textFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                ),
                // Flecha derecha
                Semantics(
                  button: true,
                  label: 'Avanzar a la siguiente pantalla',
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios,
                        color: widget.colorPalette.componentes, size: 90),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FinalizarTareaPage(
                            nickname: widget.nickname,
                            colorPalette: widget.colorPalette,
                            titleFontSize: widget.titleFontSize,
                            textFontSize: widget.textFontSize,
                          ),
                        ),
                      )
                    }, // Avanzar paso
                  ),
                ),
              ],
            ),
          ),
          // Espacio inferior opcional
          const SizedBox(height: 70),
        ],
      ),
    );
  }
}
