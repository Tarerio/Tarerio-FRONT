import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarerio/API/registrarAlumnoAPI.dart';

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
  final ImagePicker _picker = ImagePicker();

  // Variables para almacenar los estados de los checkboxes
  bool texto = false;
  bool imagenes = false;
  bool pictograma = false;
  bool video = false;

  void _showErrorModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.error, size: 50, color: Colors.red),
          title: Text(title,
              style: const TextStyle(fontSize: 30, color: Colors.red)),
          content: Text(content, style: const TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('De acuerdo', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.check, size: 50, color: Colors.green),
          title: Text(title,
              style: const TextStyle(fontSize: 30, color: Colors.green)),
          content: Text(content, style: const TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('De acuerdo', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    // Llama al método que permite seleccionar una imagen de la galería
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    // Si el usuario no selecciona una imagen, no hacemos nada
    if (pickedFile == null) return;

    // Actualiza el estado de la imagen seleccionada
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future<String> _testAlumno(BuildContext context) async {
    try {
      var jsonResponse = await _api.registrarAlumno(_nicknameController.text,
          _patronController.text, texto, imagenes, pictograma, video);
      return jsonResponse['alumno']['nickname'];
    } catch (e) {
      print('Request failed with error: $e');
      return '';
    }
  }

  void _registrarAlumno(BuildContext context) async {
    if (_nicknameController.text.isEmpty || _patronController.text.isEmpty) {
      _showErrorModal(context, 'Falta el nickname o el patrón',
          'Por favor, llena todos los campos.');
    } else if (texto == false &&
        imagenes == false &&
        pictograma == false &&
        video == false) {
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
        appBar: AppBar(
          title: const Text('Registrar Alumno'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Distribuye las columnas a izquierda y derecha
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primera columna (izquierda)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 100.0, top: 30.0, bottom: 10.0),
                    child: Text(
                      'Nombre de usuario',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                        color: Color(colorPrincipal),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 100.0, top: 0.0, bottom: 10.0),
                    child: SizedBox(
                      width: 350.0, // Ajusta el ancho según tu necesidad
                      child: TextField(
                        controller: _nicknameController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey[200],
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 100.0, top: 60.0, bottom: 10.0),
                    child: Text(
                      'Contraseña',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                        color: Color(colorPrincipal),
                      ),
                    ),
                  ),
                ],
              ),

              // Segunda columna (derecha)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.0, right: 50.0),
                    child: CircleAvatar(
                      radius: 100.0,
                      backgroundColor: Colors.grey[300], // Color de fondo si no hay imagen subida
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(
                              Icons.person,
                              size: 150.0,
                              color: Colors.white
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, right: 50.0),
                    child: SizedBox(
                      width: 200, // Ancho fijo del botón
                      height: 40, // Altura fija del botón
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Remueve el padding para usar el tamaño definido
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                          backgroundColor: Color(colorPrincipal), // Color del botón
                        ),
                        onPressed: _pickImage,
                        child: Center( // Centra el texto dentro del botón
                          child: Text(
                            'Subir Foto',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, right: 50.0),
                    child: Text(
                      'Tipo de Interfaz',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                        color: Color(colorPrincipal),
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, right: 70),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Texto:',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Switch(
                              value: texto, 
                              activeColor: Colors.white,
                              activeTrackColor: Color(colorPrincipal),
                              onChanged: (bool value) {
                                setState(() {
                                  texto = value;
                                });
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Pictogramas:',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Switch(
                              value: pictograma, 
                              activeColor: Colors.white,
                              activeTrackColor: Color(colorPrincipal),
                              onChanged: (bool value) {
                                setState(() {
                                  pictograma = value;
                                });
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Video:',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Switch(
                              value: video, 
                              activeColor: Colors.white,
                              activeTrackColor: Color(colorPrincipal),
                              onChanged: (bool value) {
                                setState(() {
                                  video = value;
                                });
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Imagenes:',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Switch(
                              value: imagenes, 
                              activeColor: Colors.white,
                              activeTrackColor: Color(colorPrincipal),
                              onChanged: (bool value) {
                                setState(() {
                                  imagenes = value;
                                });
                              }
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25.0),
                          child: SizedBox(
                            width: 200, // Ancho fijo del botón
                            height: 40, // Altura fija del botón
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero, // Remueve el padding para usar el tamaño definido
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                backgroundColor: Color(colorPrincipal), // Color del botón
                              ),
                              onPressed: () {
                                _registrarAlumno(context);
                              },
                              child: Center( // Centra el texto dentro del botón
                                child: Text(
                                  'Guardar',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
