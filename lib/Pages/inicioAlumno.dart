import 'package:flutter/material.dart';
import 'package:tarerio/API/inicioSesionAPI.dart';
import 'package:tarerio/Pages/patronAlumno.dart';

class InicioAlumno extends StatefulWidget {
  const InicioAlumno({super.key});

  @override
  _InicioAlumnoState createState() => _InicioAlumnoState();
}

class _InicioAlumnoState extends State<InicioAlumno> {
  final InicioSesionAPI _api = InicioSesionAPI();
  List<dynamic> alumnos = [];
  bool isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text('Inicio de sesión', style: TextStyle(fontSize: 30)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: alumnos.length,
        itemBuilder: (context, index) {
          var alumno = alumnos[index];
          String nickname = alumno['nickname'] ?? 'Unknown';
          String password = alumno['contrasenia'] ?? '';
          String initial = nickname.isNotEmpty ? nickname[0] : 'U';
          Color avatarColor = _getColorFromInitial(initial);
          String label = _getLabelFromPassword(password);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: avatarColor,
                        child: Text(
                          initial,
                          style: const TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        nickname,
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  onTap: () {
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}