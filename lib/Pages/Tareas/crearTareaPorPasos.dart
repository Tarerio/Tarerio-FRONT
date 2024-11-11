import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import 'package:tarerio/Pages/Tareas/tareas.dart';

import '../../Widgets/AppBarDefault.dart';
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

  CrearTareaPorPasos({required this.idAdministrador});

  @override
  _CrearTareaPorPasosState createState() => _CrearTareaPorPasosState();
}

class _CrearTareaPorPasosState extends State<CrearTareaPorPasos> {
  String? _titulo;
  String? _descripcion;
  List<Subtarea> _subtareas = []; // Lista de subtareas

  final TareaPorPasosAPI _api = TareaPorPasosAPI();

  void _setTitulo(String titulo) {
    setState(() {
      _titulo = titulo;
    });
  }

  void _setDescripcion(String descripcion) {
    setState(() {
      _descripcion = descripcion;
    });
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

  void _crearTareaPorPasos(BuildContext context) async {
    if (_titulo == null ||
        _titulo!.isEmpty ||
        _descripcion == null ||
        _descripcion!.isEmpty ||
        _subtareas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, completa todos los campos'),
            backgroundColor: Colors.red),
      );
      return;
    }
    try {
      // Capturamos la hora de creación actual
      DateTime fechaCreacion = DateTime.now();

      var jsonResponse = await _api.crearTareaPorPasos(
          _titulo!,
          _descripcion!,
          fechaCreacion,
          widget.idAdministrador,
          _subtareas // Enviar la lista de subtareas
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarea creada exitosamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), // Duración del SnackBar
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error al crear la tarea'),
            backgroundColor: Colors.red),
      );
    }
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
            bool isSmallScreen = constraints.maxWidth < 790;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Nombre de la actividad',
                  style: TextStyle(
                      color: Color(0xFF2EC4B6),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: isSmallScreen ? double.infinity : 500.0,
                  child: TextField(
                    onChanged: (String value) {
                      _setTitulo(value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nombre de la actividad',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Descripción de la actividad',
                  style: TextStyle(
                      color: Color(0xFF2EC4B6),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (String value) {
                    _setDescripcion(value);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Descripción',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Subtareas',
                  style: TextStyle(
                      color: Color(0xFF2EC4B6),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
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
                                        "${index + 1}. ", // Enumeración de las subtareas
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Flexible(
                                        child: Text(
                                          _subtareas[index].texto ??
                                              'Título de la subtarea',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Imagen: ${_subtareas[index].imagen ?? 'No disponible'}",
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Pictograma: ${_subtareas[index].pictograma ?? 'No disponible'}",
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Video: ${_subtareas[index].video ?? 'No disponible'}",
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                _eliminarSubtarea(index);
                              },
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
                    ElevatedButton(
                      onPressed: _addSubtarea,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2EC4B6),
                      ),
                      child: const Text('Añadir Subtarea',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _crearTareaPorPasos(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2EC4B6),
                      ),
                      child: const Text('Crear Tarea',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
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
