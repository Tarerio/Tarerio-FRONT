import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Cards/AulaCard.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/API/aulasAPI.dart';
import 'package:tarerio/Pages/Aulas/crearAula.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';

import 'alumnosDeAula.dart';

class AulasPage extends StatefulWidget {
  const AulasPage({super.key});

  @override
  _AulasPageState createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  List<dynamic> aulas = [];
  Map<String, dynamic> profesores = {};
  bool isloadingAulas = true;
  bool isLoadingProfesores = true;

  @override
  void initState() {
    super.initState();
    fetchAulas();
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

  Future<void> fetchAulas() async {
    try {
      AulasAPI api = AulasAPI();
      final response = await api.obtenerAulas();
      setState(() {
        aulas = response;
        isloadingAulas = false;
      });
    } catch (e) {
      print("Error al obtener aulas: $e");
      setState(() {
        isloadingAulas = false;
      });
    }
  }

  void _confirmarEliminacion(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este Aula?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {

                await _borrarAula(id);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AulasPage()));
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _borrarAula(String id) async {
    try {
      AulasAPI api = AulasAPI();
      await api.eliminarAula(id);
      setState(() {
        aulas.removeWhere((aula) => aula['id'] == id);
      });
      _showSuccessModal(context, "Éxito", "Éxito al eliminar el aula");
    } catch (e) {
      print("Error al eliminar aula: $e");
      _showErrorModal(context, "Error", "Error al eliminar el aula");
    }
  }

  Future<Map<String, dynamic>> fetchProfesores(int idAula) async {
    try {
      AulasAPI api = AulasAPI();
      final response = await api.obtenerProfesoresAsignados(idAula);
      setState(() {
        profesores = response;
        isLoadingProfesores = false;
      });
      return response;
    } catch (e) {
      print("Error al obtener aulas: $e");
      setState(() {
        isloadingAulas = false;
      });
      return {};
    }
  }

  void _mostrarDialogProfesores(BuildContext context, int idAula) async {
    await fetchProfesores(idAula);

    List<dynamic> asignados = profesores['asignados'];
    List<dynamic> noAsignados = profesores['noAsignados'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seleccionar Profesor'),
          content: isLoadingProfesores
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Lista de profesores asignados
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: asignados.length,
                        itemBuilder: (context, index) {
                          int idProfesor = asignados[index]['id_usuario'];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2EC4B6),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                  asignados[index]['nickname'] ?? 'Sin nombre'),
                              trailing: IconButton(
                                color: Colors.grey[100],
                                icon: const Icon(Icons.close),
                                onPressed: () async {
                                  try {
                                    await AulasAPI()
                                        .desasignarProfesor(idAula, idProfesor);
                                    Navigator.pop(context);
                                    _showSuccessModal(context, "Éxito",
                                        "Profesor desasignado exitosamente");
                                  } catch (e) {
                                    _showErrorModal(
                                        context, "Error", e.toString());
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      // ExpansionTile para mostrar los profesores no asignados
                      ExpansionTile(
                        title: const Text("Seleccionar profesor no asignado"),
                        children: noAsignados.map((profesor) {
                          return ListTile(
                            title: Text(profesor['nickname'] ?? 'Sin nombre'),
                            onTap: () async {
                              int idUsuario = profesor['id_usuario'];
                              try {
                                await AulasAPI()
                                    .asignarProfesorAula(idAula, idUsuario);
                                Navigator.pop(context);
                                _showSuccessModal(context, "Éxito",
                                    "Profesor asignado exitosamente");
                              } catch (e) {
                                _showErrorModal(context, "Error", e.toString());
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
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
        title: const Text(
          'Aulas',
          style: TextStyle(
            color: Color(0xFF2EC4B6),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isloadingAulas
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: aulas.map((aula) {
            return SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              height: 370,
              child: AulaCard(
                idUsuario: aula['id_aula'],
                claveAula: aula['clave_aula'],
                cupoAula: aula['cupo'],
                imagenAula: aula['imagenBase64'] ?? '',
                onEdit: () {
                  // Lógica para editar aula
                },
                onAssign: () {
                  _mostrarDialogProfesores(context, aula['id_aula']);
                },
                onDelete: () {
                  _confirmarEliminacion(aula['id_aula'].toString());
                },
                onSeeStudents: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlumnosDeAula(claveAula: aula['clave_aula'], aulaId: aula['id_aula'], cupoAula: aula['cupo']),),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CrearAula()),
          );
        },
        backgroundColor: const Color(0xFF2EC4B6),
        child: const Icon(Icons.add),
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
