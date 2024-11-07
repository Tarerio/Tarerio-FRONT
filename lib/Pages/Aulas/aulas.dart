import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Cards/AulaCard.dart';
import 'package:tarerio/Widgets/Avatar.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/API/aulasAPI.dart';
import 'package:tarerio/Pages/Aulas/crearAula.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/API/profesoresAPI.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';

class AulasPage extends StatefulWidget {
  AulasPage({super.key});

  @override
  _AulasPageState createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  List<dynamic> aulas = [];
  List<dynamic> profesores = [];
  bool isloadingAulas = true;
  bool isLoadingProfesores = true;

  @override
  void initState() {
    super.initState();
    fetchAulas();
    fetchProfesores();
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
      AulasAPI _api = AulasAPI();
      final response = await _api.obtenerAulas();
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
                Navigator.of(context).pop();
                await _borrarAula(id);
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
      AulasAPI _api = AulasAPI();
      await _api.eliminarAula(id);
      setState(() {
        aulas.removeWhere((aula) => aula['id'] == id);
      });
      _showSuccessModal(context, "Éxito", "Éxito al eliminar el aula");
    } catch (e) {
      print("Error al eliminar aula: $e");
      _showErrorModal(context, "Error", "Error al eliminar el aula");
    }
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
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: aulas.map((aula) {
            return SizedBox(
              width: MediaQuery.of(context).size.width > 800 ? 200 : 150,
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

  void _mostrarDialogProfesores(BuildContext context, int idAula) {
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
                        Navigator.pop(context);
                        _showSuccessModal(context, "Éxito",
                            "Profesor asignado exitosamente");
                      } catch (e) {
                        _showErrorModal(context, "Error", e.toString());
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
}
