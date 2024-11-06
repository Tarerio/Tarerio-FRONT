import 'package:flutter/material.dart';
import 'package:tarerio/Pages/registrarAlumno.dart';
import 'package:tarerio/Pages/registrarProfesor.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/Widgets/AlumnoCard.dart';
import '../API/inicioSesionAPI.dart';
import '../consts.dart';

class AlumnosPage extends StatefulWidget {
  AlumnosPage({super.key});

  @override
  _AlumnosState createState() => _AlumnosState();
}

class _AlumnosState extends State<AlumnosPage> {
  List<dynamic> Alumnos = [];
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    fetchAlumnos(); // Llamar a la función para obtener los Alumnos
  }

  Future<void> fetchAlumnos() async {
    try {
      InicioSesionAPI _api = InicioSesionAPI();
      final response = await _api.getAlumnos();
      setState(() {
        Alumnos = response; // Actualiza la lista de tareas
        isLoading = false; // Cambia el estado de carga
      });
    } catch (e) {
      print("Error al obtener los Alumnos: $e");
      setState(() {
        isLoading = false; // Cambia el estado de carga incluso si hay un error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alumnos',
            style: TextStyle(
                color: const Color(0xFF2EC4B6),
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0, // Space between cards horizontally
                runSpacing: 8.0, // Space between cards vertically
                children: Alumnos.map((profesor) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width > 800
                        ? 200
                        : 150, // Adjust width based on screen size
                    child: AlumnoCard(
                      id_usuario: profesor['id_usuario'],
                      imagenBase64: profesor['imagenBase64'] ?? '',
                      nickname: profesor["nickname"],
                      onAssign: () {},
                    ),
                  );
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrarAlumno()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2EC4B6),
      ),
      drawer: Navbar(
        screenIndex:
            3, // Asegúrate de que este índice sea el correcto para la página de Alumnos
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }
}
