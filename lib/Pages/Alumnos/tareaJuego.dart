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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flecha izquierda
                IconButton(
                    icon: Icon(Icons.arrow_back_ios_new,
                        color: widget.colorPalette.componentes, size: 90),
                    onPressed: () => {Navigator.pop(context)}
                    // Retroceder paso
                    ),
                // Contenido de la tarea
                Center(
                  child: tareaJuego.isEmpty || fotoTexto.isEmpty
                      ? CircularProgressIndicator() // Muestra un indicador mientras se carga la imagen
                      : tareaJuego['imagenBase64'] != null
                          ? InkWell(
                              onTap:
                                  _abrirLink, // Abre el enlace al hacer click
                              child: Image.memory(
                                fotoTexto,
                                width: 300,
                                height: 300,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Text(
                              'No hay imagen disponible'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: widget.textFontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                ),

                // Flecha derecha
                IconButton(
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
                        } // Avanzar paso
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
