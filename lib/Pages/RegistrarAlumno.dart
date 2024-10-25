import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tarerio/Models/registrarAlumnoAPI.dart';

class RegistrarAlumno extends StatefulWidget {
  const RegistrarAlumno({super.key});

  @override
  _RegistrarAlumnoState createState() => _RegistrarAlumnoState();
}

class _RegistrarAlumnoState extends State<RegistrarAlumno> {

  final RegistrarAlumnoAPI _api = RegistrarAlumnoAPI();
  // Controladores de texto para el nickname y la contraseña
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _patronController = TextEditingController();

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

  Future<String> _testAlumno(BuildContext context) async {
    try {
      var jsonResponse = await _api.registrarAlumno(
          _nicknameController.text, _patronController.text, texto, imagenes, pictograma, video);
      return jsonResponse['alumno']['nickname'];
    } catch (e) {
      print('Request failed with error: $e');
      return '';
    }
  }


  void _registrarAlumno(BuildContext context) async {
      if (_nicknameController .text.isEmpty || _patronController.text.isEmpty) {
        _showErrorModal(context, 'Falta el nickname o el patrón',
            'Por favor, llena todos los campos.');
      }else if(texto == false && imagenes == false && pictograma == false && video == false){
        _showErrorModal(context, 'Falta perfil de alumno',
            'Por favor, selecciona minimo un tipo de perfil para el alumno.');
      }else {
        String alumno = await _testAlumno(context);
        if(alumno != ''){
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo para el nickname
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nickname',
              ),
            ),
            const SizedBox(height: 16.0),
            // Campo para el patron
            TextField(
              controller: _patronController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Patrón',
              ),
            ),
            const SizedBox(height: 16.0),
            // Row para los checkboxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Espacio uniforme
              children: [
                // Checkbox 1
                Row(
                  children: [
                    Checkbox(
                      value: texto,
                      onChanged: (bool? value) {
                        setState(() {
                          texto = value ?? false;
                        });
                      },
                    ),
                    const Text('Texto'),
                  ],
                ),
                // Checkbox 2
                Row(
                  children: [
                    Checkbox(
                      value: imagenes,
                      onChanged: (bool? value) {
                        setState(() {
                          imagenes = value ?? false;
                        });
                      },
                    ),
                    const Text('Imágenes'),
                  ],
                ),
                // Checkbox 3
                Row(
                  children: [
                    Checkbox(
                      value: pictograma,
                      onChanged: (bool? value) {
                        setState(() {
                          pictograma = value ?? false;
                        });
                      },
                    ),
                    const Text('Pictograma'),
                  ],
                ),
                // Checkbox 4
                Row(
                  children: [
                    Checkbox(
                      value: video,
                      onChanged: (bool? value) {
                        setState(() {
                          video = value ?? false;
                        });
                      },
                    ),
                    const Text('Video'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _registrarAlumno(context);
              },
              child: const Text('Registrar Alumno'),
            ),
          ],
        ),
      ),
    );
  }
}
