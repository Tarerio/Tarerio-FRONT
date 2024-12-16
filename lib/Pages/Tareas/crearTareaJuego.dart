import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/Pages/Tareas/tareas.dart';

import '../../Widgets/AppBarDefault.dart';
import '../../Widgets/Avatar.dart';
import '../../Widgets/DefaultButton.dart';
import '../../Widgets/ErrorModal.dart';
import '../../Widgets/SuccessModal.dart';
import '../../Widgets/TextFieldDefault.dart';
import '../../consts.dart';

class CrearTareaJuego extends StatefulWidget {
  final int IdAdministrador;

  const CrearTareaJuego({super.key, required this.IdAdministrador});

  @override
  _CrearTareaJuegoState createState() => _CrearTareaJuegoState();
}

class _CrearTareaJuegoState extends State<CrearTareaJuego> {
  String? _url;

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _urlJuegoController = TextEditingController();

  //Variables para la imagen
  File? _image;
  String _base64Image = '';

  final TareaJuegoAPI _api = TareaJuegoAPI();

  void _showErrorModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorModal(title: title, content: content);
      },
    );
  }

  void _showSuccessModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessModal(title: title, content: content);
      },
    );
  }

  void _crearTarea(BuildContext context) async {
    if (_tituloController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _urlJuegoController.text.isEmpty) {
      _showErrorModal(context, 'Error al crear la tarea',
          'Por favor, llena todos los campos.');

      return;
    }

    try {
      DateTime fechaCreacion = DateTime.now();

      await _api.crearTareaJuego(
        _tituloController.text,
        _descripcionController.text,
        fechaCreacion,
        _urlJuegoController.text,
        widget.IdAdministrador,
        _base64Image,
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TareasPage()));
      _showSuccessModal(
          context, 'Tarea creada', 'La tarea se ha creado correctamente');
    } catch (e) {
      print('Request failed with error: $e');
      _showErrorModal(context, 'Error al crear la tarea',
          'Ha ocurrido un error al crear la tarea');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final bytes = await File(pickedFile.path).readAsBytes();

    setState(() {
      _image = File(pickedFile.path);
      _base64Image = base64Encode(bytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Creación tarea juego',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TareasPage()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 48.0,
          top: 16.0,
          right: 48.0,
          bottom: 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Sección izquierda: Nombre y descripción
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        TextFieldDefault(
                          width: 800,
                          label: 'Nombre de la actividad',
                          controller: _tituloController,
                          labelColor: Color(colorPrincipal),
                          labelFontSize: 18,
                          hintText: 'Nombre de la actividad',
                          padding: const EdgeInsets.symmetric(vertical: 5),
                        ),
                        const SizedBox(height: 20),
                        TextFieldDefault(
                          width: 800,
                          label: 'Descripción de la actividad',
                          controller: _descripcionController,
                          labelColor: Color(colorPrincipal),
                          labelFontSize: 18,
                          hintText: 'Descripción',
                          padding: const EdgeInsets.symmetric(vertical: 5),
                        ),
                        const SizedBox(height: 20),
                        TextFieldDefault(
                          width: 800,
                          label: 'Url del juego/aplicación',
                          controller: _urlJuegoController,
                          labelColor: Color(colorPrincipal),
                          labelFontSize: 18,
                          hintText: 'url de juego/aplicación',
                          padding: const EdgeInsets.symmetric(vertical: 5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20), // Espaciado entre las secciones
                  // Sección derecha: Avatar y botones
                  Column(
                    children: [
                      Avatar(
                        size: 90,
                        base64Image: _base64Image,
                        radius: 80.0,
                        backgroundColor: Colors.grey[300]!,
                        placeholderIcon:
                            const Icon(Icons.games, color: Colors.white),
                        onClear: () {
                          setState(() {
                            _base64Image = '';
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      DefaultButton(
                        text: 'Subir Foto',
                        onPressed: _pickImage,
                        color: const Color(0xFF2EC4B6),
                        colorText: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 250),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DefaultButton(
                    text: 'Crear Tarea',
                    onPressed: () {
                      _crearTarea(context);
                    },
                    color: const Color(0xFF2EC4B6),
                    fontSize: 20,
                    colorText: Colors.white,
                    upperCase: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
