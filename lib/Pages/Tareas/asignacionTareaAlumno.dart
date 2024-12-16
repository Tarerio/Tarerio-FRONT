import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/Pages/Tareas/tareas.dart';
import 'package:tarerio/Widgets/AppBarDefault.dart';
import 'package:tarerio/Widgets/Cards/AlumnoCard.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/consts.dart';

import '../../API/alumnosAPI.dart';
import '../../Widgets/ErrorModal.dart';
import '../../Widgets/SuccessModal.dart';

class NumericInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const NumericInputField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  _NumericInputFieldState createState() => _NumericInputFieldState();
}

class _NumericInputFieldState extends State<NumericInputField> {
  void _increment() {
    int currentValue = int.tryParse(widget.controller.text) ?? 0;
    setState(() {
      currentValue++;
      widget.controller.text = currentValue.toString();
    });
  }

  void _decrement() {
    int currentValue = int.tryParse(widget.controller.text) ?? 0;
    setState(() {
      if (currentValue > 0) {
        currentValue--;
        widget.controller.text = currentValue.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_drop_up),
              onPressed: _increment,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed: _decrement,
            ),
          ],
        ),
      ),
    );
  }
}

class AsignarTareaAlumno extends StatefulWidget {
  final int origen;
  final String tipoTarea;

  const AsignarTareaAlumno({
    super.key,
    required this.origen,
    required this.tipoTarea,
  });

  @override
  _AsignarTareaAlumnoState createState() => _AsignarTareaAlumnoState();
}

class _AsignarTareaAlumnoState extends State<AsignarTareaAlumno> {
  List<dynamic> Alumnos = [];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _stepsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarItems();
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

  Future<void> _cargarItems() async {
    AlumnosAPI api = AlumnosAPI();

    try {
      final alumnos = await api.getAlumnos();
      setState(() {
        Alumnos = alumnos;
      });
    } catch (e) {
      print("Error al cargar alumnos: $e");
    }
  }

  void _resetTimes() {
    _selectedTime = null;
    _selectedDate = null;
    _stepsController.clear();
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    return pickedDate;
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
    );

    return pickedTime;
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  void _showDialogAsignar(int alumnoSeleccionado) {
    _resetTimes();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Selecciona la fecha y hora de cierre para la tarea'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? pickedDate = await _selectDate(context);
                            if (pickedDate != null) {
                              setStateDialog(() {
                                _selectedDate = pickedDate;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2EC4B6),
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
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await _selectTime(context);
                            if (pickedTime != null) {
                              setStateDialog(() {
                                _selectedTime = pickedTime;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2EC4B6),
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
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  if (widget.tipoTarea == TAREA_POR_PASOS ||
                      widget.tipoTarea == TAREA_PETICION)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: SizedBox(
                        width: 300, // Set the desired width
                        child: NumericInputField(
                          controller: _stepsController,
                          labelText: widget.tipoTarea == TAREA_POR_PASOS
                              ? 'Pasos por página'
                              : 'Enunciados por página',
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DefaultButton(
                  text: 'Cerrar',
                  onPressed: () {
                    _resetTimes();
                    Navigator.of(context).pop();
                  },
                  color: Color(colorPrincipal),
                ),
                DefaultButton(
                  text: 'Aceptar',
                  onPressed: () async {
                    if (_selectedDate != null && _selectedTime != null) {
                      int? stepsPerPage = int.tryParse(_stepsController.text);
                      if (stepsPerPage == null &&
                          widget.tipoTarea != TAREA_JUEGO) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AsignarTareaAlumno(
                                    origen: widget.origen,
                                    tipoTarea: widget.tipoTarea)));

                        _showErrorModal(context, 'Error',
                            'Por favor ingrese un número válido.');

                        return;
                      }

                      try {
                        switch (widget.tipoTarea) {
                          case TAREA_PETICION:
                            TareaPeticionAPI peticionAPI = TareaPeticionAPI();
                            await peticionAPI.asignarAlumnoTarea(
                              widget.origen,
                              alumnoSeleccionado,
                              _selectedDate!,
                              _selectedTime!,
                              stepsPerPage!,
                            );
                            break;
                          case TAREA_POR_PASOS:
                            TareaPorPasosAPI porPasosAPI = TareaPorPasosAPI();
                            await porPasosAPI.asignarAlumnoTarea(
                              widget.origen,
                              alumnoSeleccionado,
                              _selectedDate!,
                              _selectedTime!,
                              stepsPerPage!,
                            );
                            break;
                          case TAREA_JUEGO:
                            TareaJuegoAPI juegoAPI = TareaJuegoAPI();
                            await juegoAPI.asignarAlumnoTarea(
                              widget.origen,
                              alumnoSeleccionado,
                              _selectedDate!,
                              _selectedTime!,
                            );
                            break;
                        }
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AsignarTareaAlumno(
                                    origen: widget.origen,
                                    tipoTarea: widget.tipoTarea)));
                        _showSuccessModal(
                            context, 'Éxito', 'Tarea asignada con éxito');
                      } catch (e) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AsignarTareaAlumno(
                                    origen: widget.origen,
                                    tipoTarea: widget.tipoTarea)));
                        _showErrorModal(
                            context, 'Error', 'Error al asignar la tarea');
                      }

                      _resetTimes();
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AsignarTareaAlumno(
                                  origen: widget.origen,
                                  tipoTarea: widget.tipoTarea)));
                      _showErrorModal(context, 'Error',
                          'Por favor selecciona una fecha y hora');
                    }
                  },
                  color: Color(colorPrincipal),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = Alumnos.map<Widget>((alumno) {
      return SizedBox(
        width: MediaQuery.of(context).size.width > 800 ? 200 : 150,
        child: AlumnoCard(
          id_usuario: alumno['id_usuario'],
          imagenBase64: alumno['imagenBase64'] ?? '',
          nickname: alumno["nickname"],
          onSelect: () {
            _showDialogAsignar(alumno['id_usuario']);
          },
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBarDefault(
        title: 'Asignar Alumno a Tarea',
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widgetList,
            ),
          ],
        ),
      ),
    );
  }
}
