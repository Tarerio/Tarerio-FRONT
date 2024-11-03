import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/AulaCard.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/API/AulasAPI.dart';
import 'package:tarerio/API/ProfesoresAPI.dart'; // Asegúrate de importar ProfesoresAPI
import 'package:tarerio/Pages/crearAula.dart';

class AulasPage extends StatefulWidget {
  AulasPage({super.key});

  @override
  _AulasPageState createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  List<dynamic> aulas = []; // Lista para almacenar las aulas
  List<dynamic> profesores = []; // Lista para almacenar los profesores
  bool isLoadingAulas = true; // Indicador de carga de aulas
  bool isLoadingProfesores = true; // Indicador de carga de profesores

  @override
  void initState() {
    super.initState();
    fetchAulas(); // Llamar a la función para obtener las aulas
    fetchProfesores(); // Llamar a la función para obtener los profesores
  }

  Future<void> fetchAulas() async {
    try {
      AulasAPI _api = AulasAPI();
      final response = await _api.obtenerAulas();
      setState(() {
        aulas = response; // Actualiza la lista de aulas
        isLoadingAulas = false; // Cambia el estado de carga de aulas
      });
    } catch (e) {
      print("Error al obtener aulas: $e");
      setState(() {
        isLoadingAulas =
            false; // Cambia el estado de carga incluso si hay un error
      });
    }
  }

  Future<void> fetchProfesores() async {
    try {
      ProfesoresAPI _api = ProfesoresAPI();
      final response = await _api.obtenerProfesores();
      setState(() {
        profesores = response; // Actualiza la lista de profesores
        isLoadingProfesores = false; // Cambia el estado de carga de profesores
      });
    } catch (e) {
      print("Error al obtener profesores: $e");
      setState(() {
        isLoadingProfesores =
            false; // Cambia el estado de carga incluso si hay un error
      });
    }
  }

  void mostrarDialogoProfesores(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Seleccionar Profesor'),
        content: isLoadingProfesores
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: profesores.length,
                  itemBuilder: (context, index) {
                    // Variable para controlar el color de fondo
                    Color backgroundColor = Colors.white;

                    return MouseRegion(
                      onEnter: (_) {
                        // Cambia el color al pasar el ratón
                        backgroundColor = Color(0xFFE0F7FA); // Color claro al pasar el ratón
                      },
                      onExit: (_) {
                        // Restaura el color original al salir
                        backgroundColor = Colors.white;
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0), // Espacio entre los elementos
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(profesores[index]['nickname'] ?? 'Sin nombre'),
                          onTap: () {
                            // Acción de selección del profesor
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aulas'),
      ),
      body: isLoadingAulas
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: aulas.length,
              itemBuilder: (context, index) {
                final aula = aulas[index];
                return AulaCard(
                  claveAula: aula['clave_aula'] ?? "Sin clave",
                  cupoAula: aula['cupo'] ?? 0,
                  imagenUrl: 'assets/images/aula.jpg', // aula['imagenUrl']!
                  onEdit: () {
                    // Lógica para editar aula
                  },
                  onAssign: () {
                    mostrarDialogoProfesores(
                        context); // Mostrar diálogo de selección de profesores
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearAula(),
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
