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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _titulo;
  String? _descripcion;
  List<Subtarea> _subtareas = []; // Lista de subtareas

  final TareaPorPasosAPI _api = TareaPorPasosAPI();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

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
        _selectedDate == null ||
        _selectedTime == null ||
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
          _selectedDate!,
          _selectedTime!,
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

      // Espera a que el SnackBar desaparezca antes de regresar
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context); // Vuelve a la página anterior
      });
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
                  'Fecha y Hora estimada de cierre',
                  style: TextStyle(
                      color: Color(0xFF2EC4B6),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Layout de Fecha y Hora
                isSmallScreen
                    ? Column(
                        children: [
                          _buildDateSelection(),
                          const SizedBox(height: 10),
                          _buildTimeSelection(),
                        ],
                      )
                    : Row(
                        children: [
                          _buildDateSelection(),
                          const SizedBox(width: 40),
                          _buildTimeSelection(),
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

// Widgets para selección de fecha y hora
  Widget _buildDateSelection() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            _selectDate(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2EC4B6),
          ),
          child: const SizedBox(
            width: 120,
            child: Text(
              'Seleccionar fecha',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 20),
        const Icon(Icons.calendar_today),
        const SizedBox(width: 10),
        Text(
          _selectedDate != null
              ? DateFormat('dd-MM').format(_selectedDate!)
              : 'Selecciona una fecha',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            _selectTime(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2EC4B6),
          ),
          child: const SizedBox(
            width: 120,
            child: Text(
              'Seleccionar hora',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 20),
        const Icon(Icons.access_time),
        const SizedBox(width: 10),
        Text(
          _selectedTime != null
              ? _formatTime(_selectedTime!)
              : 'Selecciona una hora',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
