import 'package:flutter/material.dart';
import 'package:tarerio/API/alumnosAPI.dart';
import 'package:tarerio/Widgets/Header.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';

class PerfilAlumno extends StatefulWidget {
  final String nickname;
  final ColorPalette colorPalette;
  final double titleFontSize;
  final double textFontSize;

  const PerfilAlumno({
    Key? key,
    required this.nickname,
    required this.colorPalette,
    required this.titleFontSize,
    required this.textFontSize,
  }) : super(key: key);

  @override
  _PerfilAlumnoState createState() => _PerfilAlumnoState();
}

class _PerfilAlumnoState extends State<PerfilAlumno> {
  final AlumnosAPI _api = AlumnosAPI();
  final FlutterTts _flutterTts = FlutterTts();
  Map<String, dynamic>? alumnoData;
  bool isLoading = true;
  String errorMessage = '';
  List<String> _selectedImages = [];
  String _base64Image = '';

  @override
  void initState() {
    super.initState();
    _fetchAlumnoData();
    _initializeTts();
  }

  Future<void> _fetchAlumnoData() async {
    try {
      final response = await _api.obtenerAlumno(widget.nickname);
      setState(() {
        alumnoData = response['alumno'];
        _base64Image = alumnoData!['imagenBase64'];
        _processPattern(alumnoData!['contrasenia']);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data: $e';
        isLoading = false;
      });
    }
  }

  void _processPattern(String pattern) {
    final List<String> _category = [
      'superheroes',
      'insectos',
      'formas',
      'dinosaurios'
    ];
    List<String> _selectedCodes = [];
    RegExp exp = RegExp(r'..');
    _selectedCodes = exp.allMatches(pattern).map((match) => match.group(0)!).toList();

    if (_selectedCodes.isNotEmpty) {
      String category = '';
      if (_selectedCodes[0][0] == 'S') {
        category = 'superheroes';
      } else if (_selectedCodes[0][0] == 'I') {
        category = 'insectos';
      } else if (_selectedCodes[0][0] == 'F') {
        category = 'formas';
      } else if (_selectedCodes[0][0] == 'D') {
        category = 'dinosaurios';
      }

      for (int i = 0; i < _selectedCodes.length; i++) {
        _selectedImages.add('assets/images/$category/$category${_selectedCodes[i][1]}.png');
      }
    }
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('es-ES'); // Configura el idioma a español
    await _flutterTts.setSpeechRate(0.5); // Set speech rate (0.0 to 1.0)
    await _flutterTts.setVolume(1.0); // Set volume (0.0 to 1.0)
    await _flutterTts.setPitch(1.0); // Set pitch (0.5 to 2.0)
  }

  Future<void> _speak() async {
    String text = 'Nombre: ${alumnoData!['nickname']}. ';
    text += 'Interfaces Disponibles: ';
    if (alumnoData!['texto']) text += 'Texto, ';
    if (alumnoData!['imagenes']) text += 'Imágenes, ';
    if (alumnoData!['pictograma']) text += 'Pictogramas, ';
    if (alumnoData!['video']) text += 'Vídeo, ';
    if (alumnoData!['audio']) text += 'Audio.';

    await _flutterTts.speak(text);
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
      backgroundColor: widget.colorPalette.fondo,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : alumnoData != null
          ? _buildAlumnoProfile()
          : Center(child: Text('No data available')),
    );
  }

  Widget _buildAlumnoProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Left column
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text('Patrón:', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: widget.colorPalette.fuente)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _selectedImages.map((imagePath) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(imagePath, width: 100, height: 100),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text('Interfaces Disponibles:', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: widget.colorPalette.fuente)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Table(
                      border: TableBorder.all(color: widget.colorPalette.fuente, width: 2),
                      children: [
                        if (alumnoData!['texto'])
                          TableRow(children: [
                            Center(child: Text('Texto', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: widget.colorPalette.fuente))),
                          ]),
                        if (alumnoData!['imagenes'])
                          TableRow(children: [
                            Center(child: Text('Imágenes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: widget.colorPalette.fuente))),
                          ]),
                        if (alumnoData!['pictograma'])
                          TableRow(children: [
                            Center(child: Text('Pictogramas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: widget.colorPalette.fuente))),
                          ]),
                        if (alumnoData!['video'])
                          TableRow(children: [
                            Center(child: Text('Video', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: widget.colorPalette.fuente))),
                          ]),
                        if (alumnoData!['audio'])
                          TableRow(children: [
                            Center(child: Text('Audio', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: widget.colorPalette.fuente))),
                          ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton.icon(
                    onPressed: _speak,
                    icon: Icon(Icons.volume_up, size: 34, color: widget.colorPalette.fondo),
                    label: Text('Leer Información', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: widget.colorPalette.fondo)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.colorPalette.fuente, // Set the background color
                      padding: const EdgeInsets.all(16.0),
                      textStyle: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right column
          Expanded(
            child: Center(
              child: _base64Image.isNotEmpty
                  ? Image.memory(base64Decode(_base64Image))
                  : const Icon(Icons.person, size: 150, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}