import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarerio/API/profesoresAPI.dart';
import 'package:tarerio/Pages/Profesores/profesores.dart';
import 'package:tarerio/Widgets/AppBarDefault.dart';
import 'package:tarerio/Widgets/Avatar.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/Widgets/TextFieldDefault.dart';

class EditarProfesor extends StatefulWidget {
  const EditarProfesor({super.key});

  @override
  _EditarProfesorState createState() => _EditarProfesorState();
}

class _EditarProfesorState extends State<EditarProfesor> {
  final int colorPrincipal = 0xFF2EC4B6;

  //Clase para hacer peticiones a la API
  final ProfesoresAPI _api = ProfesoresAPI();

  // Controlador de texto para el nickname
  final TextEditingController _nicknameController = TextEditingController();

  var _profesor;
  bool _fetched = false;

  //Variables para la imagen
  File? _image;
  String _base64Image = '';

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    _image = File(pickedFile.path);
    final bytes = await _image!.readAsBytes();

    setState(() {
      _base64Image = base64Encode(bytes);
    });

  }

  void _editarProfesor(BuildContext context) async {
    final int idUsuario = ModalRoute.of(context)!.settings.arguments as int;
    if (_nicknameController.text.isEmpty) {
      _showErrorModal(context, 'Falta el nickname',
          'Por favor, llena todos los campos.');
    } else {
      try {
        var result = await _api.editarProfesor(
          idUsuario,
          _nicknameController.text,
          _base64Image,
        );
        _showSuccessModal(context, 'Exito', 'Profesor editado correctamente');
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfesoresPage()),
          );
        });
      } catch (e) {
        print("Error: $e");
        _showErrorModal(context, 'Error', 'Error al editar el profesor');
      }
    }
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

  void _getProfesor(int id) async {
    if (_fetched) return;
    try {
      _profesor = await _api.getProfesor(id);
      setState(() {
        _nicknameController.text = _profesor['nickname'];
        _base64Image = _profesor['imagenBase64'];
        _fetched = true;
      });
    } catch (e) {
      print("Error: $e");
      _showErrorModal(context, 'Error', 'Error al obtener el profesor');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int idUsuario = ModalRoute.of(context)!.settings.arguments as int;
    _getProfesor(idUsuario);
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Editar Profesor ${idUsuario.toString()}',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfesoresPage()),
          );
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Avatar(
              base64Image: _base64Image,
              radius: 100.0,
              backgroundColor: Colors.grey[300]!,
              placeholderIcon:
              const Icon(Icons.person, size: 150.0, color: Colors.white),
              onClear: () {
                setState(() {
                  _base64Image = '';
                });
              },
            ),
            const SizedBox(height: 20.0),
            DefaultButton(
              text: 'Cambiar Foto',
              onPressed: _pickImage,
              color: Color(colorPrincipal),
            ),
            const SizedBox(height: 20.0),
            TextFieldDefault(
                label: 'Nickname',
                labelColor: Color(colorPrincipal),
                padding: const EdgeInsets.only(top: 10.0),
                controller: _nicknameController
            ),
            const SizedBox(height: 30.0),
            DefaultButton(
              text: 'Editar',
              onPressed: () {
                _editarProfesor(context);
              },
              color: Color(colorPrincipal),
            ),
          ],
        ),
      ),
    );
  }
}
