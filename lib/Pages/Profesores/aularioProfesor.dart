import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Cards/AlumnoDeAulaCard.dart';
import 'package:tarerio/Widgets/NavBarProfesor.dart';
import 'package:tarerio/API/profesoresAPI.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';

class AularioPage extends StatefulWidget {
  final String nickname;

  const AularioPage({super.key, required this.nickname});

  @override
  _AularioPageState createState() => _AularioPageState();
}

class _AularioPageState extends State<AularioPage> {
  Map<String, dynamic> aula = {};
  List<dynamic> alumnos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAulaYAlumnos();
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

  Future<void> fetchAulaYAlumnos() async {
    try {
      ProfesoresAPI api = ProfesoresAPI();
      final response = await api.obtenerAulaYAlumnos(widget.nickname);
      setState(() {
        aula = response['aula'] ?? {};
        alumnos = response['alumnos'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      print("Error al obtener datos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aulario de ${widget.nickname}',
          style: const TextStyle(
            color: Color(0xFF2EC4B6),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            aula.isEmpty
                ? Container(
              height: 200,
              color: Colors.teal,
              child: const Center(
                child: Text(
                  'El profesor no tiene aula asignada',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
                : Container(
              height: 200,
              decoration: BoxDecoration(
                color: aula['imagenBase64'] == null || aula['imagenBase64'] == "" ? Colors.teal : null,
                image: aula['imagenBase64'] != null && aula['imagenBase64'] != ""
                    ? DecorationImage(
                  image: MemoryImage(base64Decode(aula['imagenBase64'])),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        ' Aula: ${aula['clave_aula']} ',
                        style: const TextStyle(
                          color: Colors.white,
                          // Tienen un recuadro de fondo de color banco
                          backgroundColor: Colors.black54,
                          // Margen con el texto
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.people, size: 30, color: Colors.teal),
                const SizedBox(width: 8.0),
                Text(
                  'Alumnos: ( Nº alumnos ${alumnos.length} / ${aula['cupo'] ?? ('Cupo máx.')} )',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: alumnos.map((alumno) {
                return AlumnoDeAulaCard(
                  id_usuario: alumno['id_usuario'] ?? 0,
                  nickname: alumno['nickname'] ?? '',
                  imagenBase64: alumno['imagenBase64'] ?? '',
                  onDelete: () {},
                  showDeleteButton: false,
                );
              }).toList(),
            ),
          ],
        ),
      ),
      drawer: Navbar(
        screenIndex: 0,
        nickname: widget.nickname,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }
}