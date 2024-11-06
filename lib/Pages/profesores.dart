import 'package:flutter/material.dart';
import 'package:tarerio/Pages/registrarProfesor.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/Widgets/ProfesorCard.dart';

import '../API/profesoresAPI.dart';
import '../consts.dart';


class ProfesoresPage extends StatefulWidget {
  ProfesoresPage({super.key});


  @override
  _ProfesoresPageState createState() => _ProfesoresPageState();
}
class _ProfesoresPageState extends State<ProfesoresPage> {
  List<dynamic> profesores = [];
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    fetchProfesores(); // Llamar a la función para obtener los profesores
  }

  Future<void> fetchProfesores() async {
    try {
      ProfesoresAPI _api = ProfesoresAPI();
      final response = await _api.obtenerProfesores();
      setState(() {
        profesores = response; // Actualiza la lista de tareas
        isLoading = false; // Cambia el estado de carga
      });

    } catch (e) {
      print("Error al obtener los profesores: $e");
      setState(() {
        isLoading = false; // Cambia el estado de carga incluso si hay un error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Educadores', style: TextStyle(color: const Color(0xFF2EC4B6), fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2, // Número de elementos por fila
          childAspectRatio: 1,
        ),
        itemCount: profesores.length,
        itemBuilder: (context, index) {
          final profesor = profesores[index];
          return ProfesorCard(
            id_usuario: profesor['id_usuario'],
            imagenBase64: profesor['imagenBase64'] ?? '',
            nickname: profesor["nickname"],
            onAssign: () {
              // Lógica para asignar profesor
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegistrarProfesor()
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2EC4B6),
      ),
      drawer: Navbar(
        screenIndex: 2,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }
}
