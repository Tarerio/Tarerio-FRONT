import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarerio/API/registrarProfesorAPI.dart';
import 'package:tarerio/Widgets/AppBarDefault.dart';
import 'package:tarerio/Widgets/Avatar.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/Widgets/TextFieldDefault.dart';

class RegistrarProfesor extends StatefulWidget {
  const RegistrarProfesor({super.key});

  @override
  _RegistrarProfesorState createState() => _RegistrarProfesorState();
}

class _RegistrarProfesorState extends State<RegistrarProfesor> {
  final List<String> listElements = [
    'Registrar Alumno',
    'Registrar Profesor',
    'Mi Perfil',
    'Ajustes'
  ];
  final List<String> listRoutes = [
    '/administrador/registrarAlumno',
    '/administrador/registrarProfesor',
    '/administrador/perfil',
    'administrador/ajustes'
  ];

  final int colorPrincipal = 0xFF2EC4B6;

  //Clase para hacer peticiones a la API
  final RegistrarProfesorAPI _api = RegistrarProfesorAPI();

  // Controladores de texto para el nickname y la contraseña
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _patronController = TextEditingController();

  //Variables para la imagen
  File? _image;
  String _base64Image = '';

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });

    final bytes = await _image!.readAsBytes();
    _base64Image = base64Encode(bytes);
  }

  Future<String> _testRegistrar(BuildContext context) async {
    var jsonResponse = await _api.registrarProfesor(
      _nicknameController.text,
      _patronController.text,
      _base64Image,
    );
    if (jsonResponse['status'] == 'error') {
      _showErrorModal(
          context, 'Error al registrar profesor', jsonResponse['message']);
    }
    return jsonResponse['profesor']['nickname'];
  }

  void _registrarProfesor(BuildContext context) async {
    if (_nicknameController.text.isEmpty || _patronController.text.isEmpty) {
      _showErrorModal(context, 'Falta el nickname o el patrón',
          'Por favor, llena todos los campos.');
    } else {
      String profesor = await _testRegistrar(context);
      if (profesor != '') {
        _showSuccessModal(context, 'Profesor creado correctamente',
            'El profesor $profesor ha sido creado correctamente.');
        _restablecerCampos();
      }
    }
  }

  void _restablecerCampos() {
    _nicknameController.clear();
    _patronController.clear();
    setState(() {
      _image = null;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Registrar Profesor',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              size: 50.0,
            ),
            onPressed: _restablecerCampos,
            color: Color(colorPrincipal),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Avatar(
              image: _image,
              radius: 100.0,
              backgroundColor: Colors.grey[300]!,
              placeholderIcon:
                  const Icon(Icons.person, size: 150.0, color: Colors.white),
              onClear: () {
                setState(() {
                  _image = null;
                });
              },
            ),
            const SizedBox(height: 20.0),
            DefaultButton(
              text: 'Subir Foto',
              onPressed: _pickImage,
              color: Color(colorPrincipal),
            ),
            const SizedBox(height: 20.0),
            TextFieldDefault(
                label: 'Nickname',
                labelColor: Color(colorPrincipal),
                padding: const EdgeInsets.only(top: 10.0),
                controller: _nicknameController),
            const SizedBox(height: 20.0),
            TextFieldDefault(
                label: 'Contraseña',
                labelColor: Color(colorPrincipal),
                padding: const EdgeInsets.only(top: 10.0),
                obscureText: true,
                controller: _patronController),
            const SizedBox(height: 30.0),
            DefaultButton(
              text: 'Registrar',
              onPressed: () {
                _registrarProfesor(context);
              },
              color: Color(colorPrincipal),
            ),
          ],
        ),
      ),
    );
  }
}
