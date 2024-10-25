import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarerio/API/TareaJuegoAPI.dart';

class CrearTareaJuego extends StatefulWidget {
  final int IdAdministrador;

  CrearTareaJuego({required this.IdAdministrador});

  @override
  _CrearTareaJuegoState createState() => _CrearTareaJuegoState();
}

class _CrearTareaJuegoState extends State<CrearTareaJuego> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _titulo;
  String? _descripcion;
  String? _url;

  final TareaAPI _api = TareaAPI();


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
      initialTime: const TimeOfDay(hour:0, minute: 0),
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

  void _setUrl(String url) {
    setState(() {
      _url = url;
    });
  }

  void _crearTarea(BuildContext context) async {
    if(_titulo == null || _titulo!.isEmpty ||
        _descripcion == null || _descripcion!.isEmpty ||
        _url == null || _url!.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return ;
    }

    try {
      var jsonResponse = await _api.crearTareaJuego(_titulo!, _descripcion!, _url!, _selectedDate!, _selectedTime!, widget.IdAdministrador);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarea creada exitosamente'),
          backgroundColor: Colors.green, // Cambia el color de fondo del mensaje
          duration: Duration(seconds: 2), // Duración del SnackBar
        ),
      );

      // Espera a que el SnackBar desaparezca antes de regresar
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context); // Vuelve a la página anterior
      });
    } catch (e) {
      print('Request failed with error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al crear la tarea'),
          backgroundColor: Colors.red, // Color rojo para el error
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Creando Tarea Juego'),
        iconTheme: const IconThemeData(
          color: Color(0xFF2EC4B6),
          size: 48,
        ),
        titleTextStyle: const TextStyle(
          color: Color(0xFF2EC4B6),
          fontSize: 48,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 48.0,
          top: 16.0,
          right: 48.0,
          bottom: 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Nombre de la actividad',
                style: TextStyle(color: Color(0xFF2EC4B6), fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 500.0,
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
                style: TextStyle(color: Color(0xFF2EC4B6),fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (String value) {
                  _setDescripcion(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Fecha y Hora estimada de cierre',
                style: TextStyle(color: Color(0xFF2EC4B6),fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                children: <Widget>[
                  Row(
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
                      SizedBox(width: 20),
                      Icon(Icons.calendar_today),
                      SizedBox(width: 10),
                      Text(
                        _selectedDate != null
                            ? DateFormat('dd-MM').format(_selectedDate!)
                            : 'Selecciona una fecha',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
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
                          child:Text(
                            'Seleccionar hora',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ),
                      SizedBox(width: 20),
                      Icon(Icons.access_time),
                      SizedBox(width: 10),
                      Text(
                        _selectedTime != null
                            ? _formatTime(_selectedTime!)
                            : 'Selecciona una hora',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Url del juego/aplicación',
                style: TextStyle(color: Color(0xFF2EC4B6), fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (String value) {
                  _setUrl(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _crearTarea(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2EC4B6),
                    ),
                    child: const Text('Crear Tarea', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}