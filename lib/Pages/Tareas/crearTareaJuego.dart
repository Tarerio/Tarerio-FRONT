import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/Pages/Tareas/tareas.dart';

import '../../Widgets/AppBarDefault.dart';
import '../../consts.dart';

class CrearTareaJuego extends StatefulWidget {
  final int IdAdministrador;

  CrearTareaJuego({required this.IdAdministrador});

  @override
  _CrearTareaJuegoState createState() => _CrearTareaJuegoState();
}

class _CrearTareaJuegoState extends State<CrearTareaJuego> {
  String? _titulo;
  String? _descripcion;
  String? _url;

  final TareaJuegoAPI _api = TareaJuegoAPI();

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
        _url == null || _url!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return ;
    }

    try {
      DateTime fechaCreacion = DateTime.now();

      var jsonResponse = await _api.crearTareaJuego(_titulo!, _descripcion!,fechaCreacion, _url!, widget.IdAdministrador);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarea creada exitosamente'),
          backgroundColor: Colors.green, // Cambia el color de fondo del mensaje
          duration: Duration(seconds: 2), // Duración del SnackBar
        ),
      );

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
      appBar: AppBarDefault(
        title: 'Creación tarea juego',
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