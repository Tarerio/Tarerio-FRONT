import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tarerio/consts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tarerio/Widgets/AppBarDefault.dart';
import 'package:tarerio/Widgets/Avatar.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/Widgets/InformationModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/TextFieldDefault.dart';
import 'package:tarerio/API/menusAPI.dart';
import 'package:tarerio/Pages/Menus/menus.dart';

class CrearMenu extends StatefulWidget {
  @override
  _CrearMenuState createState() => _CrearMenuState();
}

class _CrearMenuState extends State<CrearMenu> {
  //Clase para hacer peticiones a la API
  final MenusAPI _api = MenusAPI();

  // Controladores de texto para el nickname y la contraseña
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();

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

  Future<String> _confirmCreationMenu(BuildContext context) async {
    try {
      final response = await _api.crearMenu(
        _tipoController.text,
        _contenidoController.text,
        _base64Image,
      );

      if (response != null && response.containsKey("id_menu")) {
        return response["id_menu"].toString();
      } else {
        _showErrorModal(
          context,
          'Error en la respuesta',
          'La respuesta no contiene un id_menu válido.',
        );
        return '';
      }
    } catch (e) {
      _showErrorModal(
        context,
        'Error al crear el menú',
        'No ha sido posible crear el menú',
      );
      return '';
    }
  }

  void _crearMenu(BuildContext context) async {
    if (_tipoController.text.isEmpty || _contenidoController.text.isEmpty) {
      _showErrorModal(
          context,
          'Falta el tipo o el contenido',
          'Por favor, llena todos los campos.');
      return;
    } else {
      String menu = await _confirmCreationMenu(context);
      if (menu != '') {
        _showSuccessModal(context, 'Menu creado correctamente',
            'El menu ha sido creado correctamente.');
        _restablecerCampos();
      }
    }
  }

  void _restablecerCampos() {
    setState(() {
      _tipoController.clear();
      _contenidoController.clear();
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Creación de Menú',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenusPage()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldDefault(
                    label: 'Tipo de Menú',
                    padding: const EdgeInsets.only(top: 10.0, left: 100.0),
                    controller: _tipoController,
                    labelColor: Color(colorPrincipal),
                    labelFontSize: 30.0,
                    width: 500.0,
                  ),
                  const SizedBox(height: 20),
                  TextFieldDefault(
                    label: 'Contenido del Menú',
                    padding: const EdgeInsets.only(top: 10.0, left: 100.0),
                    controller: _contenidoController,
                    labelColor: Color(colorPrincipal),
                    labelFontSize: 30.0,
                    width: 500.0,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Segunda columna (derecha)
            Padding(
              padding: const EdgeInsets.only(right: 200.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Avatar(
                    base64Image: _base64Image,
                    radius: 100.0,
                    backgroundColor: Colors.grey[300]!,
                    placeholderIcon: const Icon(Icons.image,
                        size: 150.0, color: Colors.white),
                    onClear: () {
                      setState(() {
                        _image = null;
                        _base64Image = '';
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
                      _crearMenu(context);
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
