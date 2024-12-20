import 'package:flutter/material.dart';
import 'package:tarerio/Pages/Alumnos/finalizarTarea.dart';
import 'package:tarerio/Widgets/Header.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/API/alumnosAPI.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TareaAlumnoPeticion extends StatefulWidget {
  final String nickname;
  final ColorPalette colorPalette;
  final double titleFontSize;
  final double textFontSize;
  final int idTarea;

  const TareaAlumnoPeticion({
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

class _TareaAlumno extends State<TareaAlumnoPeticion> {
  final FlutterTts _flutterTts = FlutterTts();
  final AlumnosAPI _api = AlumnosAPI();
  final TareaPeticionAPI _tareaPeticionAPI = TareaPeticionAPI();
  Map<String, dynamic> infoTarea = {};

  int pasoActual = 0; // Paso actual de la tarea
  List<dynamic> enunciados = [];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("es-ES"); // Set TTS language to Spanish
    cargarEnunciadosTarea();
  }

  void cargarEnunciadosTarea() async {
    try {
      infoTarea = await _tareaPeticionAPI.obtenerTareaByID(widget.idTarea);
      setState(() {
        enunciados = List.from(infoTarea['Enunciados'].reversed.toList());
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void cambiarPaso(int incremento) {
    setState(() {
      final nuevoPaso = pasoActual + incremento;
      if (nuevoPaso >= 0 && nuevoPaso < enunciados.length) {
        pasoActual = nuevoPaso;
      } else if (nuevoPaso == enunciados.length) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinalizarTareaPage(
              nickname: widget.nickname,
              colorPalette: widget.colorPalette,
              titleFontSize: widget.titleFontSize,
              textFontSize: widget.textFontSize,
              tipoTarea: 'Peticion',
              idTarea: widget.idTarea,
            ),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    });
  }

  String transformGoogleDriveUrl(String url) {
    return url
        .replaceAll('/file/d/', '/uc?export=view&id=')
        .replaceAll('/view?usp=drive_link', '');
  }

  Widget loadImage(String url) {
    String transformedUrl = transformGoogleDriveUrl(url);
    return SizedBox(
      width: 300, // Set the desired width
      height: 300, // Set the desired height
      child: Image.network(
        transformedUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return const Center(child: Text('ERROR AL CARGAR LA IMAGEN'));
        },
      ),
    );
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
      body: enunciados.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new,
                      color: widget.colorPalette.componentes, size: 90),
                  onPressed: () => cambiarPaso(-1), // Retroceder paso
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            enunciados[pasoActual]['Texto'].toUpperCase(),
                            style: TextStyle(
                              fontSize: widget.titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: widget.colorPalette.fuente,
                            ),
                          ),
                        ),
                        loadImage(enunciados[pasoActual]['Imagen']),
                        IconButton(
                          icon: Icon(Icons.volume_up,
                              size: 100,
                              color: widget.colorPalette.fuente),
                          onPressed: () async {
                            await _flutterTts.speak(
                                enunciados[pasoActual]['Texto'] ??
                                    'Texto no disponible');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios,
                      color: widget.colorPalette.componentes, size: 90),
                  onPressed: () => cambiarPaso(1), // Avanzar paso
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'ENUNCIADO ${pasoActual + 1}',
              style: TextStyle(
                fontSize: widget.textFontSize,
                fontWeight: FontWeight.bold,
                color: widget.colorPalette.fuente,
              ),
            ),
          ),
        ],
      ),
    );
  }
}