import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/AulaCard.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/API/AulasAPI.dart';
import 'package:tarerio/API/ProfesoresAPI.dart';
import 'package:tarerio/Pages/crearAula.dart';

class AulasPage extends StatefulWidget {
  const AulasPage({super.key});

  @override
  _AulasPageState createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  List<dynamic> aulas = [];
  List<dynamic> profesores = [];
  bool isLoadingAulas = true;
  bool isLoadingProfesores = true;

  @override
  void initState() {
    super.initState();
    fetchAulas();
    fetchProfesores();
  }

  Future<void> fetchAulas() async {
    try {
      final response = await AulasAPI().obtenerAulas();
      setState(() {
        aulas = response;
        isLoadingAulas = false;
      });
    } catch (e) {
      print("Error al obtener aulas: $e");
      setState(() => isLoadingAulas = false);
    }
  }

  Future<void> fetchProfesores() async {
    try {
      final response = await ProfesoresAPI().obtenerProfesores();
      setState(() {
        profesores = response;
        isLoadingProfesores = false;
      });
    } catch (e) {
      print("Error al obtener profesores: $e");
      setState(() => isLoadingProfesores = false);
    }
  }

  void mostrarDialogoProfesores(BuildContext context, int idAula) {
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
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 192, 184, 184),
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
                          title: Text(
                              profesores[index]['nickname'] ?? 'Sin nombre'),
                          onTap: () async {
                            int idUsuario = profesores[index]['id_usuario'];
                            try {
                              await AulasAPI()
                                  .asignarProfesorAula(idAula, idUsuario);                
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
                    imagenUrl: 'assets/images/aula.jpg',
                    onEdit: () {
                      // Lógica para editar aula
                    },
                    onAssign: () => {
                          mostrarDialogoProfesores(context, aula['id_aula']),
                        });
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
        onLogout: () => print("Cerrar sesión"),
      ),
    );
  }
}
