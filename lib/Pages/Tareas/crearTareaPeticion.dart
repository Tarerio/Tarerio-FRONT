import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/Pages/Tareas/tareas.dart';
import '../../Widgets/AppBarDefault.dart';
import '../../Widgets/Avatar.dart';
import '../../Widgets/DefaultButton.dart';
import '../../Widgets/ErrorModal.dart';
import '../../Widgets/SuccessModal.dart';
import '../../Widgets/TextFieldDefault.dart';
import '../../consts.dart';
import 'package:tarerio/Models/enunciado.dart';

class CrearTareaPeticion extends StatefulWidget {
  final int idAdministrador;

  CrearTareaPeticion({required this.idAdministrador});

  @override
  _CrearTareaPeticionState createState() => _CrearTareaPeticionState();
}

class _CrearTareaPeticionState extends State<CrearTareaPeticion> {
  List<Enunciado> _enunciados = []; // Lista de enunciados

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();


  //Variables para la imagen
  File? _image;
  String _base64Image = '';

  final TareaPeticionAPI _api = TareaPeticionAPI();

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

  void _editEnunciado(int index) async {
    final enunciadoActual = _enunciados[index];

    final textoController = TextEditingController(text: enunciadoActual.texto);
    final imagenController = TextEditingController(text: enunciadoActual.imagen);
    final videoController = TextEditingController(text: enunciadoActual.video);

    String? texto = enunciadoActual.texto;

    final Enunciado? enunciadoEditado = await showDialog<Enunciado>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Enunciado'),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textoController,
                    decoration: const InputDecoration(labelText: 'Texto del enunciado'),
                  ),
                  TextField(
                    controller: imagenController,
                    decoration: const InputDecoration(labelText: 'Imagen URL'),
                  ),
                  TextField(
                    controller: videoController,
                    decoration: const InputDecoration(labelText: 'Video URL'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (texto != null) {
                  Navigator.of(context).pop(
                      Enunciado(
                        texto: textoController.text.isEmpty ? 'No disponible' : textoController.text,
                        imagen: imagenController.text.isEmpty ? 'No disponible' : imagenController.text,
                        video: videoController.text.isEmpty ? 'No disponible' : videoController.text,
                      ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (enunciadoEditado != null) {
      setState(() {
        _enunciados[index] = enunciadoEditado;
      });
    }
  }

  void _addEnunciado() async {
    final Enunciado? newEnunciado = await showDialog<Enunciado>(
      context: context,
      builder: (BuildContext context) {
        String? texto;
        String? imagen;
        String? video;

        return AlertDialog(
          title: const Text('Añadir Enunciado'),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => texto = value,
                    decoration:
                    const InputDecoration(labelText: 'Texto del enunciado'),
                  ),
                  TextField(
                    onChanged: (value) => imagen = value,
                    decoration: const InputDecoration(labelText: 'Imagen URL'),
                  ),
                  TextField(
                    onChanged: (value) => video = value,
                    decoration: const InputDecoration(labelText: 'Video URL'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (texto != null) {
                  Navigator.of(context).pop(
                      Enunciado(texto: texto, imagen: imagen, video: video));
                }
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );

    if (newEnunciado != null) {
      setState(() {
        _enunciados.add(newEnunciado);
      });
    }
  }

  void _eliminarEnunciado(int index) {
    setState(() {
      _enunciados.removeAt(index);
    });
  }

  Future<void> _crearTareaPeticion(BuildContext context) async {
    if (_tituloController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _enunciados.isEmpty) {
      _showErrorModal(context, 'Error al crear tarea',
          'Por favor, llena todos los campos y añade al menos un enunciado');
      return;
    }

    try {
      // Capturamos la hora de creación actual
      DateTime fechaCreacion = DateTime.now();

      await _api.crearTareaPeticion(
          _tituloController.text,
          _descripcionController.text,
          fechaCreacion,
          widget.idAdministrador,
          _enunciados, // Enviar la lista de enunciados
          _base64Image,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TareasPage()));
      _showSuccessModal(context, 'Tarea creada',
          'La tarea de petición se ha creado exitosamente');

    } catch (e) {
      _showErrorModal(context, 'Error al crear tarea',
          'Ha ocurrido un error al crear la tarea de petición');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Creación tarea petición',
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Sección izquierda: Nombre y descripción
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Avatar(
                          size: 90,
                          base64Image: _base64Image,
                          radius: 80.0,
                          backgroundColor: Colors.grey[300]!,
                          placeholderIcon: const Icon(
                              Icons.question_answer,
                              color: Colors.white),
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
                const SizedBox(height: 20),
                const Text(
                  'Enunciados',
                  style: TextStyle(
                      color: Color(0xFF2EC4B6),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _enunciados.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF2EC4B6)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${index + 1}. ",
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Flexible(
                                  child: Text(
                                    _enunciados[index].texto ?? 'Título del enunciado',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Imagen: ${_enunciados[index].imagen ?? 'No disponible'}",
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Video: ${_enunciados[index].video ?? 'No disponible'}",
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.teal),
                                  onPressed: () => _editEnunciado(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _eliminarEnunciado(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultButton(
                      width: 250,
                      text: 'Añadir Enunciado',
                      onPressed: _addEnunciado,
                      color: const Color(0xFF2EC4B6),
                      colorText: Colors.white,
                      fontSize: 20,
                      upperCase: false,
                    ),
                    DefaultButton(
                      text: 'Crear Tarea',
                      onPressed: () {
                        _crearTareaPeticion(context);
                      },
                      color: const Color(0xFF2EC4B6),
                      fontSize: 20,
                      colorText: Colors.white,
                      upperCase: false,
                    ),
                  ],
                ),
              ],
            );

          },
        ),
      ),
    );
  }
}