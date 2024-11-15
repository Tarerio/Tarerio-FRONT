import 'package:flutter/material.dart';
import 'package:tarerio/Pages/Profesores/registrarProfesor.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/Widgets/Cards/ProfesorCard.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';


import '../../API/profesoresAPI.dart';
import '../../consts.dart';

class ProfesoresPage extends StatefulWidget {
  ProfesoresPage({super.key});

  @override
  _ProfesoresPageState createState() => _ProfesoresPageState();
}

class _ProfesoresPageState extends State<ProfesoresPage> {
  List<dynamic> profesores = [];
  bool isLoading = true; // Indicador de carga
  ProfesoresAPI _api = ProfesoresAPI();
  TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfesores(); // Llamar a la función para obtener los profesores
  }

  Future<void> fetchProfesores() async {
    try {
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

  Future<void> _eliminarProfesor(String idProfesor) async {
    try {
      await _api.eliminarProfesor(idProfesor);
    } catch (e) {
      print("Error al eliminar aula: $e");
    }
  }

  void _showSuccessModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessModal(title: title, content: content);
      },
    );
  }

  void _confirmarEliminacion(String idProfesor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este Profesor?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _eliminarProfesor(idProfesor);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProfesoresPage()));
                _showSuccessModal(context, 'Profesor eliminado',
                    'El profesor ha sido eliminado exitosamente');
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _cleanFiltros() {
    setState(() {
      _nicknameController.clear();
      fetchProfesores();
    });
  }

  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
        title: const Text('Profesores',
            style: TextStyle(
                color: const Color(0xFF2EC4B6),
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                      Icons.refresh_sharp,
                      color: Color(colorPrincipal),
                  ),
                  onPressed: () {
                    _cleanFiltros();
                  },
                ),
                const SizedBox(width: 10),
                const SizedBox(width: 10),
                Container(
                  width: 213,
                  child: TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      labelText: 'Buscar por nombre',
                      labelStyle: TextStyle(color: Color(colorPrincipal)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(colorPrincipal)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(colorPrincipal), width: 2.0),
                      ),
                      suffixIcon: Icon(Icons.search, color: Color(colorPrincipal)),
                    ),
                    onChanged: (value) async {
                      final response = await _api.filtrarProfesor(value);
                      setState(() {
                        profesores = response;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: profesores.map((profesor) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width > 800
                            ? 200
                            : 150,
                        child: ProfesorCard(
                            id_usuario: profesor['id_usuario'],
                            imagenBase64: profesor['imagenBase64'] ?? '',
                            nickname: profesor["nickname"],
                            onAssign: () {
                              // Lógica para asignar profesor
                            },
                            onDelete: () {
                              _confirmarEliminacion(profesor['id_usuario'].toString());
                            }),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistrarProfesor()),
        );
      },
      child: const Icon(Icons.add),
      backgroundColor: const Color(0xFF2EC4B6),
    ),
    drawer: Navbar(
      screenIndex: 3,
      onLogout: () {
        print("Cerrar sesión");
      },
    ),
  );
}
}