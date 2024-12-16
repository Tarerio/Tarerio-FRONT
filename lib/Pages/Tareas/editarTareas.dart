import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarerio/Pages/Tareas/tareas.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/Widgets/TextFieldDefault.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import 'package:tarerio/Widgets/AppBarDefault.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/consts.dart';

import '../../Widgets/Avatar.dart';

class Respuesta {
  String? respuesta;
  bool? realizado;

  Respuesta({this.respuesta, this.realizado});
}

class Enunciado {
  String? texto;
  String? imagen;
  String? video;
  Respuesta? respuesta;

  Enunciado({this.texto, this.imagen, this.video});
}

class Subtarea {
  String? texto;
  String? imagen;
  String? pictograma;
  String? video;

  Subtarea({this.texto, this.imagen, this.pictograma, this.video});
}

class EditarTareas extends StatefulWidget {
  final String tipoTarea;
  final int idTarea;

  const EditarTareas({
    super.key,
    required this.tipoTarea,
    required this.idTarea,
  });

  @override
  _EditarTareasState createState() => _EditarTareasState();
}

class _EditarTareasState extends State<EditarTareas> {
  late Map<String, dynamic> tarea;
  List<dynamic>? _enunciados = [];
  List<dynamic>? _subtareas = [];
  bool isLoading = true;

  final TareaPeticionAPI _peticionAPI = TareaPeticionAPI();
  final TareaPorPasosAPI _porPasosAPI = TareaPorPasosAPI();
  final TareaJuegoAPI _juegoAPI = TareaJuegoAPI();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  //Variables para la imagen
  File? _image;
  String _base64Image = '';

  @override
  void initState() {
    super.initState();
    loadTarea(widget.idTarea, widget.tipoTarea); // Obtener tarea
  }

  Future<void> loadTarea(int idTarea, String tipoTarea) async {
    try {
      switch (tipoTarea) {
        case TAREA_PETICION:
          tarea = await _peticionAPI.obtenerTareaByID(idTarea);
          _enunciados = tarea['Enunciados'] ?? [];

          break;
        case TAREA_POR_PASOS:
          tarea = await _porPasosAPI.obtenerTareaByID(idTarea);
          _subtareas = tarea['Subtareas'] ?? [];
          break;
        case TAREA_JUEGO:
          tarea = await _juegoAPI.obtenerTareaByID(idTarea);
          break;
      }

      _tituloController.text = tarea['Titulo'];
      _descripcionController.text = tarea['Descripcion'];
      _base64Image = tarea['imagenBase64'];

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error al obtener la tarea: $e");
    }
  }

  // Imagen
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final bytes = await File(pickedFile.path).readAsBytes();

    setState(() {
      _image = File(pickedFile.path);
      _base64Image = base64Encode(bytes);
    });
  }

  // Enunciados
  void _eliminarEnunciado(int index) {
    setState(() {
      _enunciados?.removeAt(index);
    });
  }

  void _editEnunciado(int index) async {
    final enunciadoActual = _enunciados?[index];

    if (enunciadoActual == null) return;

    String? texto = enunciadoActual['Texto'];
    String? imagen = enunciadoActual['Imagen'];
    String? video = enunciadoActual['Video'];

    final Enunciado? enunciadoEditado = await showDialog<Enunciado>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Enunciado'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => texto = value,
                    controller: TextEditingController(text: texto),
                    decoration:
                        const InputDecoration(labelText: 'Texto del enunciado'),
                  ),
                  TextField(
                    onChanged: (value) => imagen = value,
                    controller: TextEditingController(text: imagen),
                    decoration: const InputDecoration(labelText: 'Imagen URL'),
                  ),
                  TextField(
                    onChanged: (value) => video = value,
                    controller: TextEditingController(text: video),
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
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (enunciadoEditado != null) {
      setState(() {
        _enunciados?[index] = {
          'Texto': enunciadoEditado.texto,
          'Imagen': enunciadoEditado.imagen,
          'Video': enunciadoEditado.video,
        };
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
            child: SizedBox(
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
        _enunciados ??= [];

        _enunciados!.add({
          'Texto': newEnunciado.texto,
          'Imagen': newEnunciado.imagen,
          'Video': newEnunciado.video,
        });
      });
    }
  }

  Widget _buildTareaPeticion() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            'Enunciados',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color(0xFF2EC4B6),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 295, // Limitar el contenido
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _enunciados?.length ?? 0,
              itemBuilder: (context, index) {
                return _buildEnunciado(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnunciado(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF2EC4B6)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            _enunciados?[index]['Texto'] ??
                                'Título del enunciado',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Imagen: ${_enunciados?[index]['Imagen'] ?? 'No disponible'}",
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Video: ${_enunciados?[index]['Video'] ?? 'No disponible'}",
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.teal),
                    onPressed: () => _editEnunciado(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _eliminarEnunciado(index),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Subtareas
  void _eliminarSubtarea(int index) {
    setState(() {
      _subtareas?.removeAt(index);
    });
  }

  void _editSubtarea(int index) async {
    final subtareaActual = _subtareas?[index];

    if (subtareaActual == null) return;

    String? texto = subtareaActual['Texto'];
    String? imagen = subtareaActual['Imagen'];
    String? pictograma = subtareaActual['Pictograma'];
    String? video = subtareaActual['Video'];

    final Subtarea? subtareaEditada = await showDialog<Subtarea>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Subtarea'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => texto = value,
                    controller: TextEditingController(text: texto),
                    decoration: const InputDecoration(
                        labelText: 'Texto de la Subtarea'),
                  ),
                  TextField(
                    onChanged: (value) => imagen = value,
                    controller: TextEditingController(text: imagen),
                    decoration: const InputDecoration(labelText: 'Imagen URL'),
                  ),
                  TextField(
                    onChanged: (value) => pictograma = value,
                    controller: TextEditingController(text: pictograma),
                    decoration:
                        const InputDecoration(labelText: 'Pictograma URL'),
                  ),
                  TextField(
                    onChanged: (value) => video = value,
                    controller: TextEditingController(text: video),
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
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (subtareaEditada != null) {
      setState(() {
        _subtareas?[index] = {
          'Texto': subtareaEditada.texto,
          'Imagen': subtareaEditada.imagen,
          'Pictograma': subtareaEditada.pictograma,
          'Video': subtareaEditada.video,
        };
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho
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
        _subtareas ??= [];

        _subtareas!.add({
          'Texto': newSubtarea.texto,
          'Imagen': newSubtarea.imagen,
          'Pictograma': newSubtarea.pictograma,
          'Video': newSubtarea.video,
        });
      });
    }
  }

  Widget _buildTareaPorPasos() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            'Subtareas',
            style: TextStyle(
              color: Color(0xFF2EC4B6),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 295, // Limitar el contenido
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _subtareas?.length ?? 0,
              itemBuilder: (context, index) {
                return _buildSubtarea(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtarea(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF2EC4B6)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            _subtareas?[index]['Texto'] ??
                                'Título de la subtarea',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Imagen: ${_subtareas?[index]['Imagen'] ?? 'No disponible'}",
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Pictograma: ${_subtareas?[index]['Pictograma'] ?? 'No disponible'}",
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Video: ${_subtareas?[index]['Video'] ?? 'No disponible'}",
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.teal),
                    onPressed: () => _editSubtarea(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _eliminarSubtarea(index),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Juegos
  Widget _buildTareaJuego(String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Url del juego/aplicación',
          style: TextStyle(
              color: Color(0xFF2EC4B6),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          onChanged: (String value) {
            tarea['Enlace'] = value;
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: url,
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¿Desea confirmar los cambios?"),
          // se podrían añadir los campos cambiados
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceAround, // Distribuye los botones de manera uniforme
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red, // Color de fondo del botón
                    foregroundColor: Colors.white, // Color del texto
                  ),
                  child: const Text("Rechazar"),
                ),
                TextButton(
                  onPressed: () {
                    _acceptChanges();
                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green, // Color de fondo del botón
                    foregroundColor: Colors.white, // Color del texto
                  ),
                  child: const Text("Aceptar"),
                ),
              ],
            ),
          ],
        );
      },
    );
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

  void _acceptChanges() async {
    tarea['Titulo'] = _tituloController.text;
    tarea['Descripcion'] = _descripcionController.text;
    tarea['imagenBase64'] = _base64Image;

    try {
      if (widget.tipoTarea == TAREA_PETICION) {
        await _peticionAPI.updateTarea(widget.idTarea, tarea);
      } else if (widget.tipoTarea == TAREA_POR_PASOS) {
        await _porPasosAPI.updateTarea(widget.idTarea, tarea);
      } else if (widget.tipoTarea == TAREA_JUEGO) {
        await _juegoAPI.updateTarea(widget.idTarea, tarea);
      }

      _showSuccessModal(context, 'Tarea editada correctamente',
          'Campos modificados correctamene');
    } catch (e) {
      _showErrorModal(context, 'Error al editar la tarea', '');
      print("Error al obtener tareas: $e");
    }
  }

  Icon _getIconForTipoTarea(String tipo) {
    switch (tipo) {
      case TAREA_JUEGO:
        return const Icon(Icons.games, color: Colors.white);
      case TAREA_PETICION:
        return const Icon(Icons.question_answer, color: Colors.white);
      case TAREA_POR_PASOS:
        return const Icon(Icons.list_rounded, color: Colors.white);
      default:
        return const Icon(Icons.edit_square,
            color: Colors.white); // Icono por defecto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Editar ${widget.tipoTarea}',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TareasPage()),
          );
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(
                left: 48.0,
                top: 16.0,
                right: 48.0,
                bottom: 16.0,
              ),
              child: SingleChildScrollView(
                // Añadido para poder hacer scroll si la pantalla es pequeña
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Columna con los campos de nombre y descripción
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                              ),
                              const SizedBox(height: 20),
                              TextFieldDefault(
                                width: 800,
                                label: 'Descripción de la actividad',
                                controller: _descripcionController,
                                labelColor: Color(colorPrincipal),
                                labelFontSize: 18,
                                hintText: 'Descripción',
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            width: 20), // Espaciado entre las secciones
                        // Columna con el Avatar y el botón para subir imagen
                        Column(
                          children: [
                            Avatar(
                              size: 100,
                              base64Image: _base64Image,
                              radius: 80.0,
                              backgroundColor: Colors.grey[300]!,
                              placeholderIcon:
                                  _getIconForTipoTarea(widget.tipoTarea),
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

                    // Condiciones para mostrar diferentes secciones según el tipo de tarea
                    if (widget.tipoTarea == TAREA_PETICION)
                      _buildTareaPeticion(),
                    if (widget.tipoTarea == TAREA_POR_PASOS)
                      _buildTareaPorPasos(),
                    if (widget.tipoTarea == TAREA_JUEGO)
                      _buildTareaJuego(tarea['Enlace'] ?? 'No disponible'),

                    const SizedBox(height: 30),

                    // Filas con botones de acción
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón "Añadir Subtarea" si es "Tarea Por Pasos"
                        if (widget.tipoTarea == TAREA_POR_PASOS)
                          DefaultButton(
                            width: 250,
                            text: 'Añadir Subtarea',
                            onPressed: _addSubtarea,
                            color: const Color(0xFF2EC4B6),
                            colorText: Colors.white,
                            fontSize: 20,
                            upperCase: false,
                          ),

                        // Botón "Añadir Enunciado" si es "Tarea Peticion"
                        if (widget.tipoTarea == TAREA_PETICION)
                          DefaultButton(
                            width: 250,
                            text: 'Añadir Enunciado',
                            onPressed: _addEnunciado,
                            color: const Color(0xFF2EC4B6),
                            colorText: Colors.white,
                            fontSize: 20,
                            upperCase: false,
                          ),

                        const SizedBox(width: 10), // Espacio entre los botones
                        // Botón "Modificar Tarea"
                        DefaultButton(
                          width: 250,
                          text: 'Modificar Tarea',
                          onPressed: () {
                            _showConfirmationDialog(context);
                          },
                          color: const Color(0xFF2EC4B6),
                          colorText: Colors.white,
                          fontSize: 20,
                          upperCase: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
