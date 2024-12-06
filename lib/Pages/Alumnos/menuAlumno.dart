import 'package:flutter/material.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/Pages/Alumnos/calendario.dart';
import 'package:tarerio/Pages/Alumnos/principalAlumno.dart';
import 'package:tarerio/Pages/home.dart';
import 'package:tarerio/Widgets/Header.dart';

class PanelAlumno extends StatefulWidget {
  final String nickname;
  final ColorPalette colorPalette;
  final double titleFontSize;
  final double textFontSize;

  const PanelAlumno({
    super.key,
    required this.nickname,
    required this.colorPalette,
    required this.titleFontSize,
    required this.textFontSize,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PanelAlumnoState createState() => _PanelAlumnoState();
}

class _PanelAlumnoState extends State<PanelAlumno> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        nickname: widget.nickname,
        colorPalette: widget.colorPalette,
        titleFontSize: widget.titleFontSize,
        textFontSize: widget.textFontSize,
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Padding general para todo el contenido
        child: Column(
          children: [
            // Botón Tareas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0), // Separación entre botones
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PrincipalAlumno(nickname: widget.nickname)),
                      (Route<dynamic> route) =>
                          false, // elimina todas las rutas anteriores
                    );
                  },
                  child: Container(
                    width: double.infinity, // Ocupa todo el ancho disponible
                    decoration: BoxDecoration(
                      color: widget.colorPalette.colorPrincipal,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'TAREAS',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Icon(
                          Icons.assignment,
                          size: 50,
                          color: widget.colorPalette.fondo,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Botón Horario
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0), // Separación entre botones
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalendarPage(
                              nickname: widget.nickname,
                              colorPalette: widget.colorPalette,
                              textFontSize: widget.textFontSize,
                              titleFontSize: widget.titleFontSize)),
                      (Route<dynamic> route) =>
                          false, // elimina todas las rutas anteriores
                    );
                  },
                  child: Container(
                    width: double.infinity, // Ocupa todo el ancho disponible
                    decoration: BoxDecoration(
                      color: widget.colorPalette.colorSecundario,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'HORARIO',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Icon(
                          Icons.calendar_today,
                          size: 50,
                          color: widget.colorPalette.fondo,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Botón Cerrar Sesión
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0), // Separación entre botones
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                      (Route<dynamic> route) =>
                          false, // elimina todas las rutas anteriores
                    );
                  },
                  child: Container(
                    width: double.infinity, // Ocupa todo el ancho disponible
                    decoration: BoxDecoration(
                      color: widget.colorPalette.componentes,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'CERRAR SESIÓN',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Icon(
                          Icons.exit_to_app,
                          size: 50,
                          color: widget.colorPalette.fondo,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
