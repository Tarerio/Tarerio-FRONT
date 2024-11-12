import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/Pages/Tareas/tareas.dart';
import '../../Widgets/AppBarDefault.dart';
import '../../consts.dart';

class Respuesta {
  String? respuesta;
  bool? realizado;

  Respuesta({this.respuesta, this.realizado});
}

class Enunciado {
  String? texto;
  String? imagen;
  String? video;
  Respuesta? respuesta;

  Enunciado({this.texto, this.imagen, this.video});
}

class CrearTareaPeticion extends StatefulWidget {
  final int idAdministrador;

  CrearTareaPeticion({required this.idAdministrador});

  @override
  _CrearTareaPeticionState createState() => _CrearTareaPeticionState();
}

class _CrearTareaPeticionState extends State<CrearTareaPeticion> {
  String? _titulo;
  String? _descripcion;
  List<Enunciado> _enunciados = []; // Lista de enunciados

  final TareaPeticionAPI _api = TareaPeticionAPI();

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

  void _addEnunciado() async {
    final Enunciado? newEnunciado = await showDialog<Enunciado>(
      context: context,
      builder: (BuildContext context) {
        String? texto;
        String? imagen;
        String? video;

        return AlertDialog(
          title: const Text('Añadir Enunciado'),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => texto = value,
                    decoration:
                    const InputDecoration(labelText: 'Texto del enunciado'),
                  ),
                  TextField(
                    onChanged: (value) => imagen = value,
                    decoration: const InputDecoration(labelText: 'Imagen URL'),
                  ),
                  TextField(
                    onChanged: (value) => video = value,
                    decoration: const InputDecoration(labelText: 'Video URL'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (texto != null) {
                  Navigator.of(context).pop(
                      Enunciado(texto: texto, imagen: imagen, video: video));
                }
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );

    if (newEnunciado != null) {
      setState(() {
        _enunciados.add(newEnunciado);
      });
    }
  }

  void _eliminarEnunciado(int index) {
    setState(() {
      _enunciados.removeAt(index);
    });
  }

  Future<void> _crearTareaPeticion(BuildContext context) async {
    if (_titulo == null ||
        _titulo!.isEmpty ||
        _descripcion == null ||
        _descripcion!.isEmpty ||
        _enunciados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, completa todos los campos'),
            backgroundColor: Colors.red),
      );
      return;
    }

    try {
      // Capturamos la hora de creación actual
      DateTime fechaCreacion = DateTime.now();

      await _api.crearTareaPeticion(
          _titulo!,
          _descripcion!,
          fechaCreacion,
          widget.idAdministrador,
          _enunciados // Enviar la lista de enunciados
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarea creada exitosamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), // Duración del SnackBar
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al crear la tarea de petición'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Creación tarea petición',
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isSmallScreen = constraints.maxWidth < 790;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Nombre de la actividad',
                  style: TextStyle(
                      color: Color(0xFF2EC4B6),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: isSmallScreen ? double.infinity : 500.0,
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
                  style: TextStyle(
                      color: Color(0xFF2EC4B6),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (String value) {
                    _setDescripcion(value);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Descripción',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enunciados',
                  style: TextStyle(
                      color: Color(0xFF2EC4B6),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                // Lista de enunciados
                Expanded(
                  child: ListView.builder(
                    itemCount: _enunciados.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF2EC4B6)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${index + 1}. ", // Enumeración de los enunciados
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Flexible(
                                        child: Text(
                                          _enunciados[index].texto ??
                                              'Título del enunciado',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Imagen: ${_enunciados[index].imagen ?? 'No disponible'}",
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Video: ${_enunciados[index].video ?? 'No disponible'}",
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                _eliminarEnunciado(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _addEnunciado,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFF2EC4B6)),
                      ),
                      child: const Text('Añadir Enunciado'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _crearTareaPeticion(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFF2EC4B6)),
                      ),
                      child: const Text('Crear Tarea'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}