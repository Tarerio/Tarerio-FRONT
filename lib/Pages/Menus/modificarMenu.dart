import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

class ModificarMenu extends StatefulWidget {
  final int menuId;
  final String tipoMenu;
  final String contenidoMenu;
  final String imagenMenu;

  ModificarMenu({
    required this.menuId,
    required this.tipoMenu,
    required this.contenidoMenu,
    required this.imagenMenu});

  @override
  _ModificarMenuState createState() => _ModificarMenuState();
}

class _ModificarMenuState extends State<ModificarMenu> {

  //Clase para hacer peticiones a la API
  final MenusAPI _api = MenusAPI();

  // Controladores de texto para el nickname y la contraseña
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();

  //Variables para la imagen
  File? _image;
  String _base64Image = '';

  @override
  void initState() {
    super.initState();
    _tipoController.text = widget.tipoMenu;
    _contenidoController.text = widget.contenidoMenu;
    _base64Image = widget.imagenMenu;
  }

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

  Future<String> _confirmModificarMenu(BuildContext context) async {
    try {
      var response = await _api.modificarMenu(
        widget.menuId,
        _tipoController.text,
        _contenidoController.text,
        _base64Image,
      );

      return response["id_menu"].toString();

    } catch (e) {
      _showErrorModal(
        context,
        'Error al modificar el menú',
        'No ha sido posible modificar el menú',
      );
      return '';
    }
  }

  void _modificarMenu(BuildContext context) async {
    if (_tipoController.text.isEmpty || _contenidoController.text.isEmpty) {
      _showErrorModal(context, 'Falta el tipo o el contenido',
          'Por favor, llena todos los campos.');
    } else {
      String menu = await _confirmModificarMenu(context);
      if (menu != '') {
        _showSuccessModal(context, 'Menu modificado correctamente',
            'El menu ha sido modificado correctamente.');
        _restablecerCampos();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenusPage()),
      );
    }
  }

  void _restablecerCampos() {
    setState(() {
      _tipoController.text = widget.tipoMenu;
      _contenidoController.text = widget.contenidoMenu;
      _base64Image = widget.imagenMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Modificacion de menú',
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
                      _modificarMenu(context);
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