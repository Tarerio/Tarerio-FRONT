import 'package:flutter/material.dart';
import 'package:tarerio/API/alumnosAPI.dart';
import 'package:tarerio/Widgets/Header.dart';
import 'package:tarerio/Models/menuAccesible.dart';

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
  Map<String, dynamic>? alumnoData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAlumnoData();
  }

  Future<void> _fetchAlumnoData() async {
    try {
      final response = await _api.obtenerAlumno(widget.nickname);
      setState(() {
        alumnoData = response['alumno'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data: $e';
        isLoading = false;
      });
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: ${alumnoData!['id_usuario']}'),
          Text('Nickname: ${alumnoData!['nickname']}'),
          Text('Contraseña: ${alumnoData!['contrasenia']}'),
          Text('Texto: ${alumnoData!['texto']}'),
          Text('Imágenes: ${alumnoData!['imagenes']}'),
          Text('Pictograma: ${alumnoData!['pictograma']}'),
          Text('Video: ${alumnoData!['video']}'),
          Text('Audio: ${alumnoData!['audio']}'),
          Text('Por Defecto: ${alumnoData!['porDefecto']}'),
          // Add more fields as needed
        ],
      ),
    );
  }
}