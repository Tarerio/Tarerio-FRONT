import 'package:flutter/material.dart';
import 'package:tarerio/Pages/Alumnos/registrarAlumno.dart';
import 'package:tarerio/Pages/Profesores/registrarProfesor.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/Widgets/Cards/AlumnoCard.dart';
import 'package:tarerio/consts.dart';
import '../../API/alumnosAPI.dart';

class AlumnosPage extends StatefulWidget {
  AlumnosPage({super.key});

  @override
  _AlumnosState createState() => _AlumnosState();
}

class _AlumnosState extends State<AlumnosPage> {
  List<dynamic> Alumnos = [];
  bool isLoading = true; // Indicador de carga
  AlumnosAPI _api = AlumnosAPI();

  // Filter alumnos
  final TextEditingController nicknameController = TextEditingController();
  String? categoriaSeleccionada;
  final Map<String, String> categorias = {
    'Texto': 'texto',
    'Imágenes': 'imagenes',
    'Pictograma': 'pictograma',
    'Vídeo': 'video',
    'Audio': 'audio',
  };

  @override
  void initState() {
    super.initState();
    fetchAlumnos(); // Llamar a la función para obtener los Alumnos
  }

  void _cleanFiltros(){
    setState(() {
      categoriaSeleccionada = null;
      nicknameController.text = '';
      fetchAlumnos();
    });
  }

  Future<void> fetchAlumnos() async {
    try {
      final response = await _api.getAlumnos();
      setState(() {
        Alumnos = response; // Actualiza la lista de tareas
        isLoading = false; // Cambia el estado de carga
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Cambia el estado de carga incluso si hay un error
      });
    }
  }

  Future<void> _filterAlumnos({String? nickname, String? categoria }) async {
    try {
      final response = await _api.getFilteredAlumnos(nickname, categoria);
      setState(() {
        Alumnos = response; // Actualiza la lista de alumnos
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
                SizedBox(width: 10),
                Container(
                  child: DropdownButton<String>(
                    alignment: Alignment.center,
                    hint: Text('Filtrar por categoria'),
                    value: categoriaSeleccionada,
                    items: categorias.entries.map((categoria) {
                      return DropdownMenuItem<String>(
                        value: categoria.value,
                        child: Text(categoria.key),
                        alignment: Alignment.center,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        categoriaSeleccionada = newValue;
                        _filterAlumnos(categoria: categoriaSeleccionada, nickname: nicknameController.text);

                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    underline: SizedBox.shrink(),
                    iconEnabledColor: Color(colorPrincipal),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 213,
                  child: TextField(
                    controller: nicknameController,
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
                      final response = await _api.getFilteredAlumnos(value, categoriaSeleccionada);
                      setState(() {
                        Alumnos = response;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0, // Space between cards horizontally
                runSpacing: 8.0, // Space between cards vertically
                children: Alumnos.map((alumno) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width > 800
                        ? 200
                        : 150, // Adjust width based on screen size
                    child: AlumnoCard(
                      id_usuario: alumno['id_usuario'],
                      imagenBase64: alumno['imagenBase64'] ?? '',
                      nickname: alumno["nickname"],
                      onEdit: () {
                        Navigator.pushNamed(
                            context, '/administrador/alumnos/editarAlumno',
                            arguments: alumno["id_usuario"]);
                      },
                      onDelete: () {},
                      onAccesibilidad: () {
                        Navigator.pushNamed(
                            context, '/administrador/alumnos/accesibilidad',
                            arguments: alumno["nickname"]);
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
            MaterialPageRoute(builder: (context) => RegistrarAlumno()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2EC4B6),
      ),
      drawer: Navbar(
        screenIndex: 4,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }
}
