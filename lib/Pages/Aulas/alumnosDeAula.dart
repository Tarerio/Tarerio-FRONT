import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../API/alumnosAPI.dart';
import '../../API/aulasAPI.dart';
import '../../Widgets/AppBarDefault.dart';
import '../../Widgets/Cards/AlumnoDeAulaCard.dart';
import '../../Widgets/ErrorModal.dart';
import '../../Widgets/SuccessModal.dart';
import 'aulas.dart';

class AlumnosDeAula extends StatefulWidget {
  final int aulaId;
  final String claveAula;
  final int cupoAula;

  AlumnosDeAula({required this.aulaId, required this.claveAula, required this.cupoAula});

  @override
  _AlumnosDeAulaState createState() => _AlumnosDeAulaState();
}

class _AlumnosDeAulaState extends State<AlumnosDeAula> {
  final int colorPrincipal = 0xFF2EC4B6;
  bool isLoading = true;
  List<dynamic> alumnos = [];
  List<dynamic> alumnosDisponibles = [];

  dynamic alumnoSeleccionado = null;

  @override
  void initState() {
    super.initState();
    fetchAlumnosAula(widget.aulaId);
  }

  //Clase para hacer peticiones a la API
  final AulasAPI _apiAulas = AulasAPI();
  final AlumnosAPI _apiAlumnos = AlumnosAPI();

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

  void fetchAlumnosAula(int aulaId) async {
    try {
      final responseAlumnos = await _apiAlumnos.getAlumnos(aula: aulaId);
      final responseAlumnosDisponibles = await _apiAlumnos.getAlumnos(aula: -1);
      setState(() {
        alumnos = responseAlumnos;
        alumnosDisponibles = responseAlumnosDisponibles;
        isLoading = false;
      });
    } catch (e) {
      print("Error al obtener alumnos de aula: $e");
    }
  }

  void aniadirAlumnoAula(int idAula, int idUsuario) async {
    try {
      await _apiAulas.asignarAlumnoAula(idAula, idUsuario);
      setState(() {
        isLoading = true;
        alumnoSeleccionado = null;
      });
      fetchAlumnosAula(widget.aulaId);
      _showSuccessModal(context, 'Alumno asignado', 'El alumno ha sido asignado correctamente');
    } catch (e) {
      _showErrorModal(context, 'Error al asignar alumno', e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void eliminarAlumnoAula(int idUsuario) async {
    try {
      await _apiAulas.eliminarAlumnoAula(idUsuario);
      setState(() => isLoading = true);
      fetchAlumnosAula(widget.aulaId);
      _showSuccessModal(context, 'Alumno eliminado', 'El alumno ha sido eliminado correctamente');
    } catch (e) {
      _showErrorModal(context, 'Error al eliminar alumno', e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _mostrarModalSeleccion(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecciona un alumno',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                isExpanded: true,
                isDense: true,
                value: alumnoSeleccionado,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide( color: Color(colorPrincipal) ),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: -100),
                  labelText: 'Elige un alumno',
                ),
                items: alumnosDisponibles.map((alumno) {
                  return DropdownMenuItem(
                    value: alumno,
                    child: Text(alumno['nickname']),
                  );
                }).toList(),
                onChanged: (dynamic newValue) {
                  setState(() {
                    alumnoSeleccionado = newValue;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (alumnoSeleccionado != null) {
                    aniadirAlumnoAula(widget.aulaId, alumnoSeleccionado!['id_usuario']);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Por favor, selecciona un alumno')),
                    );
                  }
                },
                child: Text('Aceptar'),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        alumnoSeleccionado = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Alumnos en ${widget.claveAula}',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AulasPage()),
          );
        },
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : alumnos.isEmpty
          ? Center(
        child: Text(
          'Aún no hay alumnos asignados',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0, // Space between cards horizontally
          runSpacing: 8.0, // Space between cards vertically
          children: alumnos.map((alumno) {
            return SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              height: 300,
              child: AlumnoDeAulaCard(
                id_usuario: alumno['id_usuario'],
                imagenBase64: alumno['imagenBase64'] ?? '',
                nickname: alumno["nickname"],
                onDelete: () {
                  eliminarAlumnoAula(alumno['id_usuario']);
                },
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: alumnos.length >= widget.cupoAula
            ? null
            : () { _mostrarModalSeleccion(context);},
        child: const Icon(Icons.add),
        backgroundColor: alumnos.length >= widget.cupoAula ? const Color(0xDDDDDDDD) : const Color(0xFF2EC4B6),
      ),
    );
  }
}