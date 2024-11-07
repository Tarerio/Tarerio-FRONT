import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tarerio/Widgets/AppBarDefault.dart';
import 'package:tarerio/Widgets/Avatar.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/Widgets/InformationModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/TextFieldDefault.dart';

import 'package:tarerio/API/aulasAPI.dart';

class CrearAula extends StatefulWidget {

  @override
  _CrearAulaState createState() => _CrearAulaState();
}

class _CrearAulaState extends State<CrearAula> {
  final int colorPrincipal = 0xFF2EC4B6;

  //Clase para hacer peticiones a la API
  final AulasAPI _api = AulasAPI();

  // Controladores de texto para el nickname y la contraseña
  final TextEditingController _claveController = TextEditingController();
  final TextEditingController _cupoController = TextEditingController();

  //Variables para la imagen
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
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

  void _showInformationModal(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InformationModal(title: title, content: content);
      },
    );
  }

  Future<String> _testAula(BuildContext context) async {
    var jsonResponse = await _api.crearAula(_claveController.text, _cupoController.text);
    if (jsonResponse['status'] == 'error') {
      _showErrorModal(
          context, 'Error al crear aula', jsonResponse['message']);
    }
    return jsonResponse['aula']['clave_aula'];
  }

  void _crearAula(BuildContext context) async {

    if (_claveController.text.isEmpty || _cupoController.text.isEmpty) {
      _showErrorModal(context, 'Falta la clave o el cupo',
          'Por favor, llena todos los campos.');
    } else {
      String aula = await _testAula(context);
      if (aula != '') {
        _showSuccessModal(context, 'Aula creada correctamente',
            'El aula $aula ha sido creada correctamente.');
        _claveController.clear();
        _cupoController.clear();
      }
    }
  }

  void _restablecerCampos() {
    setState(() {
      _claveController.clear();
      _cupoController.clear();
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Creación de aula',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldDefault(
                  label: 'Clave del Aula',
                  padding: const EdgeInsets.only(top: 10.0, left: 100.0),
                  controller: _claveController,
                  labelColor: Color(colorPrincipal),
                  labelFontSize: 30.0,
                  width: 200.0,
                ),
                const SizedBox(height: 20),
                TextFieldDefault(
                  label: 'Cupo del Aula',
                  padding: const EdgeInsets.only(top: 10.0, left: 100.0),
                  controller: _cupoController,
                  labelColor: Color(colorPrincipal),
                  labelFontSize: 30.0,
                  width: 200.0,
                ),
                const SizedBox(height: 20),
              ],
            ),
            // Segunda columna (derecha)
            Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Avatar(
                    image: _image,
                    radius: 100.0,
                    backgroundColor: Colors.grey[300]!,
                    placeholderIcon: const Icon(Icons.image,
                        size: 150.0, color: Colors.white),
                    onClear: () {
                      setState(() {
                        _image = null;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DefaultButton(
                    text: 'Subir Foto',
                    onPressed: _pickImage,
                    color: Color(colorPrincipal),
                  ),
                  const SizedBox(height: 20),
                  DefaultButton(
                    text: 'Guardar',
                    onPressed: () {
                      _crearAula(context);
                    },
                    color: Color(colorPrincipal),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}