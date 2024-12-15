import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Header.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/API/alumnosAPI.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';

class TareaAlumno extends StatefulWidget {
  final String nickname;
  final ColorPalette colorPalette;
  final double titleFontSize;
  final double textFontSize;
  final int idTarea;

  const TareaAlumno({
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

class _TareaAlumno extends State<TareaAlumno> {
  final AlumnosAPI _api = AlumnosAPI();

  Map<String, dynamic> explicaciones = {
    'texto': false,
    'imagenes': false,
    'pictograma': false,
    'video': false,
    'audio': false,
  };

  List<String> tiposActivos = [];
  String? tipoExplicacionSeleccionado;
  int pasoActual = 0; // Paso actual de la tarea
  List<Map<String, dynamic>> pasos = [];

  @override
  void initState() {
    super.initState();
    cargarInfoAlumno();
    cargarPasosTarea();
  }

  void cargarPasosTarea() {
    // Simulación de pasos de la tarea
    pasos = [
      {
        'texto': 'Explicación del paso 1 en texto',
        'imagenes': 'imagen_paso1.png'
      },
      {
        'texto': 'Explicación del paso 2 en texto',
        'imagenes': 'imagen_paso2.png'
      },
      {
        'texto': 'Explicación del paso 3 en texto',
        'imagenes': 'imagen_paso3.png'
      },
    ];
  }

  void cargarInfoAlumno() async {
    try {
      Map<String, dynamic> _alumno = await _api.obtenerAlumno(widget.nickname);
      Map<String, dynamic> alumnoInfo = _alumno['alumno'];
      explicaciones.updateAll((key, value) {
        return alumnoInfo.containsKey(key) ? alumnoInfo[key] : value;
      });

      setState(() {
        tiposActivos = explicaciones.keys
            .where((key) => explicaciones[key] == true)
            .toList();
        tipoExplicacionSeleccionado = alumnoInfo['porDefecto'];
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Widget getContenidoPorTipo() {
    if (tipoExplicacionSeleccionado == null || pasos.isEmpty) {
      return const Text('No hay contenido disponible.');
    }

    final paso = pasos[pasoActual];
    switch (tipoExplicacionSeleccionado) {
      case 'texto':
        return Text(paso['texto'] ?? 'Texto no disponible');
      case 'imagenes':
        return Image.asset(
          paso['imagenes'] ?? 'assets/placeholder.png',
          fit: BoxFit.cover,
        );
      case 'pictograma':
        return Image.asset(
          paso['pictograma'] ?? 'assets/placeholder.png',
          fit: BoxFit.cover,
        );
      case 'video':
        return const Text('Video');
      case 'audio':
        return const Text('Audio');
      default:
        return const Text('Tipo no soportado.');
    }
  }

  void cambiarPaso(int incremento) {
    setState(() {
      final nuevoPaso = pasoActual + incremento;
      if (nuevoPaso >= 0 && nuevoPaso < pasos.length) {
        pasoActual = nuevoPaso;
      }
    });
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
                  icon: Icon(Icons.arrow_back_ios,
                      color: widget.colorPalette.componentes, size: 90),
                  onPressed: () => cambiarPaso(-1), // Retroceder paso
                ),
                // Contenido de la tarea
                Expanded(
                  child: Center(
                    child: getContenidoPorTipo(),
                  ),
                ),
                // Flecha derecha
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios,
                      color: widget.colorPalette.componentes, size: 90),
                  onPressed: () => cambiarPaso(1), // Avanzar paso
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Indicador del paso actual
          Text(
            'PASO ${pasoActual + 1}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Selector de tipo de contenido
          if (tiposActivos.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: tiposActivos.map((tipo) {
                  return Expanded(
                    // Hace que cada botón ocupe el mismo espacio horizontal
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5), // Espacio entre botones
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tipoExplicacionSeleccionado =
                                tipo; // Actualizar tipo
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tipoExplicacionSeleccionado == tipo
                              ? widget.colorPalette.colorSecundario
                              : widget.colorPalette.colorSecundario
                                  .withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(
                              vertical:
                                  20), // Aumenta el tamaño vertical del botón
                        ),
                        child:
                            _getImagenForTipo(tipo), // Asigna un ícono por tipo
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          
        ],
      ),
    );
  }

  Widget _getImagenForTipo(String tipo) {
    switch (tipo) {
      case 'texto':
        return Image.asset(
          'assets/images/explicaciones/texto.png',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        );
      case 'imagenes':
        return Image.asset(
          'assets/images/explicaciones/imagenes.png',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        );
      case 'pictograma':
        return Image.asset(
          'assets/images/explicaciones/pictogramas.png',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        );
      case 'video':
        return Image.asset(
          'assets/images/explicaciones/video.png',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        );
      case 'audio':
        return Image.asset(
          'assets/images/explicaciones/audio.png',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        );
      default:
        return Image.asset(
          'assets/placeholder.png',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        );
    }
  }
}
