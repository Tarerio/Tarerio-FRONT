import 'package:flutter/material.dart';
import 'package:tarerio/API/inicioSesionAPI.dart';
import 'package:tarerio/Pages/Alumnos/patronAlumno.dart';
import '../../Widgets/AppBarDefault.dart'; // Import the AppBarDefault component
import 'package:tarerio/consts.dart';
import 'dart:convert'; // Import for Base64 decoding

class InicioAlumno extends StatefulWidget {
  const InicioAlumno({super.key});

  @override
  _InicioAlumnoState createState() => _InicioAlumnoState();
}

class _InicioAlumnoState extends State<InicioAlumno> {
  final InicioSesionAPI _api = InicioSesionAPI();
  List<dynamic> alumnos = [];
  bool isLoading = true;
  int currentPage = 0;
  final int itemsPerPage = 8;

  @override
  void initState() {
    super.initState();
    _fetchAlumnos();
  }

  Future<void> _fetchAlumnos() async {
    try {
      final data = await _api.getAlumnos();
      setState(() {
        alumnos = data;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Color _getColorFromInitial(String initial) {
    final int hash = initial.codeUnitAt(0);
    final int colorIndex = hash % Colors.primaries.length;
    return Colors.primaries[colorIndex];
  }

  String _getLabelFromPassword(String password) {
    if (password.isEmpty) return 'Unknown';
    switch (password[0].toUpperCase()) {
      case 'S':
        return 'superheroes';
      case 'I':
        return 'insectos';
      case 'F':
        return 'formas';
      case 'D':
        return 'dinosaurios';
      default:
        return 'Unknown';
    }
  }

  void _previousPage() {
    setState(() {
      if (currentPage > 0) {
        currentPage--;
      }
    });
  }

  void _nextPage() {
    setState(() {
      if ((currentPage + 1) * itemsPerPage < alumnos.length) {
        currentPage++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage < alumnos.length)
        ? startIndex + itemsPerPage
        : alumnos.length;
    List<dynamic> currentAlumnos = alumnos.sublist(startIndex, endIndex);

    return Scaffold(
      appBar: AppBarDefault(
        title: 'Inicio de sesión',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: Color(colorSecundario), size: 90),
                      onPressed: _previousPage,
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: currentAlumnos.map((alumno) {
                        String nickname = alumno['nickname'] ?? 'Unknown';
                        String password = alumno['contrasenia'] ?? '';
                        String initial =
                            nickname.isNotEmpty ? nickname[0] : 'U';
                        Color avatarColor = _getColorFromInitial(initial);
                        String label = _getLabelFromPassword(password);
                        String? imagenBase64 = alumno['imagenBase64'];

                        return SizedBox(
                          width: 150,
                          height: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatronAlumno(
                                    label: label,
                                    nickname: nickname,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(20),
                              shadowColor: Colors.black,
                              elevation: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: avatarColor,
                                  child: imagenBase64 != null
                                      ? ClipOval(
                                          child: Image.memory(
                                            base64Decode(imagenBase64),
                                            fit: BoxFit.cover,
                                            width: 60,
                                            height: 60,
                                          ),
                                        )
                                      : Text(
                                          initial,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 30),
                                        ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  nickname,
                                  style: const TextStyle(fontSize: 20),
                                  maxLines: 1, // Limita a una sola línea
                                  overflow: TextOverflow.ellipsis, // Aplica elipsis en caso de overflow
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward,
                          color: Color(colorSecundario), size: 90),
                      onPressed: _nextPage,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
