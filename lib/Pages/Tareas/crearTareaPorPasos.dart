import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import 'package:tarerio/Pages/Tareas/tareas.dart';
import 'package:tarerio/Widgets/TextFieldDefault.dart';

import '../../Widgets/AppBarDefault.dart';
import '../../Widgets/Avatar.dart';
import '../../Widgets/DefaultButton.dart';
import '../../Widgets/ErrorModal.dart';
import '../../Widgets/SuccessModal.dart';
import '../../consts.dart';

// Modelo para la Subtarea
class Subtarea {
  String? texto;
  String? imagen;
  String? pictograma;
  String? video;

  Subtarea({this.texto, this.imagen, this.pictograma, this.video});
}

class CrearTareaPorPasos extends StatefulWidget {
  final int idAdministrador;

  const CrearTareaPorPasos({
    super.key,
    required this.idAdministrador});

  @override
  _CrearTareaPorPasosState createState() => _CrearTareaPorPasosState();
}

class _CrearTareaPorPasosState extends State<CrearTareaPorPasos> {
  final List<Subtarea> _subtareas = []; // Lista de subtareas

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  //Variables para la imagen
  File? _image;
  String _base64Image = '';

  final TareaPorPasosAPI _api = TareaPorPasosAPI();

  void _editSubtarea(int index) async {
    final subtareaActual = _subtareas[index];

    // Controladores para los campos de texto
    final textoController = TextEditingController(text: subtareaActual.texto);
    final imagenController = TextEditingController(text: subtareaActual.imagen);
    final pictogramaController = TextEditingController(text: subtareaActual.pictograma);
    final videoController = TextEditingController(text: subtareaActual.video);

    String? texto = subtareaActual.texto;

    final Subtarea? subtareaEditada = await showDialog<Subtarea>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Subtarea'),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textoController,
                    decoration: const InputDecoration(labelText: 'Texto de la Subtarea'),
                  ),
                  TextField(
                    controller: imagenController,
                    decoration: const InputDecoration(labelText: 'Imagen URL'),
                  ),
                  TextField(
                    controller: pictogramaController,
                    decoration: const InputDecoration(labelText: 'Pictograma URL'),
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
                      Subtarea(
                        texto: textoController.text.isEmpty ? 'No disponible' : textoController.text,
                        imagen: imagenController.text.isEmpty ? 'No disponible' : imagenController.text,
                        pictograma: pictogramaController.text.isEmpty ? 'No disponible' : pictogramaController.text,
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

    if (subtareaEditada != null) {
      setState(() {
        _subtareas[index] = subtareaEditada;
      });
    }
  }

  void _addSubtarea() async {
    final Subtarea? newSubtarea = await showDialog<Subtarea>(
      context: context,
      builder: (BuildContext context) {
        String? texto;
        String? imagen;
        String? pictograma;
        String? video;

        return AlertDialog(
          title: const Text('Añadir Subtarea'),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.8, // Ajusta el ancho
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => texto = value,
                    decoration: const InputDecoration(
                        labelText: 'Texto de la Subtarea'),
                  ),
                  TextField(
                    onChanged: (value) => imagen = value,
                    decoration: const InputDecoration(labelText: 'Imagen URL'),
                  ),
                  TextField(
                    onChanged: (value) => pictograma = value,
                    decoration:
                    const InputDecoration(labelText: 'Pictograma URL'),
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
                  Navigator.of(context).pop(Subtarea(
                      texto: texto,
                      imagen: imagen,
                      pictograma: pictograma,
                      video: video));
                }
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );

    if (newSubtarea != null) {
      setState(() {
        _subtareas.add(newSubtarea);
      });
    }
  }

  void _eliminarSubtarea(int index) {
    setState(() {
      _subtareas.removeAt(index);
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

  void _crearTareaPorPasos(BuildContext context) async {
    if (_tituloController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _subtareas.isEmpty) {
      _showErrorModal(context, 'Error al crear la tarea',
          'Por favor, llena todos los campos.');
      return;
    }
    try {
      // Capturamos la hora de creación actual
      DateTime fechaCreacion = DateTime.now();

      await _api.crearTareaPorPasos(
          _tituloController.text,
          _descripcionController.text,
          fechaCreacion,
          widget.idAdministrador,
          _subtareas, // Enviar la lista de subtareas
          _base64Image,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TareasPage(),
        ),
      );
      _showSuccessModal(context, 'Tarea creada',
          'La tarea por pasos ha sido creada exitosamente');
    } catch (e) {
      print('Error al crear la tarea por pasos: $e');
      _showErrorModal(context, 'Error al crear la tarea',
          'Ocurrió un error al crear la tarea por pasos');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

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
        title: 'Creación tarea por pasos',
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        ],
                      ),
                    ),
                    const SizedBox(width: 20), // Espaciado entre las secciones
                    // Sección derecha: Avatar y botones
                    Column(
                      children: [
                        Avatar(
                          size: 110,
                          base64Image: _base64Image,
                          radius: 80.0,
                          backgroundColor: Colors.grey[300]!,
                          placeholderIcon: const Icon(Icons.list_rounded,
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
                  'Subtareas',
                  style: TextStyle(
                      color: Color(0xFF2EC4B6),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Lista de subtareas
                Expanded(
                  child: ListView.builder(
                    itemCount: _subtareas.length,
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
                                    _subtareas[index].texto ?? 'Título de la subtarea',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Imagen: ${_subtareas[index].imagen ?? 'No disponible'}",
                              style: TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Pictograma: ${_subtareas[index].pictograma ?? 'No disponible'}",
                              style: TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Video: ${_subtareas[index].video ?? 'No disponible'}",
                              style: TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.teal),
                                  onPressed: () => _editSubtarea(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _eliminarSubtarea(index),
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
                      text: 'Añadir Subtarea',
                      onPressed: _addSubtarea,
                      color: const Color(0xFF2EC4B6),
                      colorText: Colors.white,
                      fontSize: 20,
                      upperCase: false,
                    ),
                    DefaultButton(
                      text: 'Crear Tarea',
                      onPressed: () {
                        _crearTareaPorPasos(context);
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