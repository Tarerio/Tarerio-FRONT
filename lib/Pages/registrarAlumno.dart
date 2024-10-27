import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarerio/API/registrarAlumnoAPI.dart';
import 'package:tarerio/Widgets/AppBarDefault.dart';
import 'package:tarerio/Widgets/Avatar.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/Widgets/InformationModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/DefaultSwitch.dart';
import 'package:tarerio/Widgets/TextFieldDefault.dart';

class RegistrarAlumno extends StatefulWidget {
  const RegistrarAlumno({super.key});

  @override
  _RegistrarAlumnoState createState() => _RegistrarAlumnoState();
}

class _RegistrarAlumnoState extends State<RegistrarAlumno> {
  final int colorPrincipal = 0xFF2EC4B6;

  //Clase para hacer peticiones a la API
  final RegistrarAlumnoAPI _api = RegistrarAlumnoAPI();

  // Controladores de texto para el nickname y la contraseña
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _patronController = TextEditingController();

  //Variables para la imagen
  File? _image;

  // Variables para almacenar los estados de los checkboxes
  bool _texto = false;
  bool _imagenes = false;
  bool _pictograma = false;
  bool _video = false;

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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void _restablecerCampos() {
    setState(() {
      _nicknameController.clear();
      _patronController.clear();
      _image = null;
      _texto = false;
      _imagenes = false;
      _pictograma = false;
      _video = false;
    });
  }

  Future<String> _testAlumno(BuildContext context) async {
    var jsonResponse = await _api.registrarAlumno(_nicknameController.text,
        _patronController.text, _texto, _imagenes, _pictograma, _video);
    if (jsonResponse['status'] == 'error') {
      _showErrorModal(
          context, 'Error al registrar alumno', jsonResponse['message']);
    }
    return jsonResponse['alumno']['nickname'];
  }

  void _registrarAlumno(BuildContext context) async {
    if (_nicknameController.text.isEmpty || _patronController.text.isEmpty) {
      _showErrorModal(context, 'Falta el nickname o el patrón',
          'Por favor, llena todos los campos.');
    } else if (_texto == false &&
        _imagenes == false &&
        _pictograma == false &&
        _video == false) {
      _showErrorModal(context, 'Falta perfil de alumno',
          'Por favor, selecciona minimo un tipo de perfil para el alumno.');
    } else {
      String alumno = await _testAlumno(context);
      if (alumno != '') {
        _showSuccessModal(context, 'Alumno creado correctamente',
            'El alumno $alumno ha sido creado correctamente.');
        _nicknameController.clear();
        _patronController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Registrar Alumno',
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
                  label: 'Nombre de usuario',
                  padding: const EdgeInsets.only(top: 10.0, left: 100.0),
                  controller: _nicknameController,
                  labelColor: Color(colorPrincipal),
                  labelFontSize: 30.0,
                  width: 350.0,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0, top: 20.0),
                      child: Text(
                        'Patrón del alumno',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                          color: Color(colorPrincipal),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.help,
                          size: 30.0,
                          color: Color(0xFF2EC4B6),
                        ),
                        onPressed: () {
                          _showInformationModal(context, 'Patrón del alumno', 'El patrón del alumno es una secuencia de 4 imágenes que el alumno deberá ingresar para acceder a su perfil.');
                        },
                      ),
                    ),
                  ],
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
                    placeholderIcon: const Icon(Icons.person,
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
                  Padding(
                      padding: const EdgeInsets.only(top: 20.0, right: 10.0),
                      child: Text(
                        'Tipo de Interfaz',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                          color: Color(colorPrincipal),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        DefaultSwitch(
                          label: 'Texto:',
                          value: _texto,
                          activeColor: Colors.white,
                          activeTrackColor: Color(colorPrincipal),
                          onChanged: (bool value) {
                            setState(() {
                              _texto = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        DefaultSwitch(
                          label: 'Pictogramas:',
                          value: _pictograma,
                          activeColor: Colors.white,
                          activeTrackColor: Color(colorPrincipal),
                          onChanged: (bool value) {
                            setState(() {
                              _pictograma = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        DefaultSwitch(
                          label: 'Video:',
                          value: _video,
                          activeColor: Colors.white,
                          activeTrackColor: Color(colorPrincipal),
                          onChanged: (bool value) {
                            setState(() {
                              _video = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        DefaultSwitch(
                          label: 'Imagenes:',
                          value: _imagenes,
                          activeColor: Colors.white,
                          activeTrackColor: Color(colorPrincipal),
                          onChanged: (bool value) {
                            setState(() {
                              _imagenes = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  DefaultButton(
                    text: 'Guardar',
                    onPressed: () {
                      _registrarAlumno(context);
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
