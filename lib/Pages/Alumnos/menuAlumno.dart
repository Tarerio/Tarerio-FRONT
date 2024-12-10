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
  _PanelAlumnoState createState() => _PanelAlumnoState();
}

class _PanelAlumnoState extends State<PanelAlumno> {
  @override
  Widget build(BuildContext context) {
    final colorPalette = widget.colorPalette;
    final textFontSize = widget.textFontSize;
    final titleFontSize = widget.titleFontSize;

    return Scaffold(
      appBar: Header(
        nickname: widget.nickname,
        colorPalette: colorPalette,
        titleFontSize: titleFontSize,
        textFontSize: textFontSize,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PrincipalAlumno(nickname: widget.nickname)),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorPalette.componentes,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'TAREAS',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: colorPalette.fuente,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Icon(
                          Icons.assignment,
                          size: 50,
                          color: colorPalette.fuente,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalendarPage(
                              nickname: widget.nickname,
                              colorPalette: colorPalette,
                              textFontSize: textFontSize,
                              titleFontSize: titleFontSize)),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorPalette.colorSecundario,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'CALENDARIO',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: colorPalette.fuente,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Icon(
                          Icons.calendar_view_week_sharp,
                          size: 50,
                          color: colorPalette.fuente,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorPalette.componentes,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'CERRAR SESIÓN',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: colorPalette.fuente,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Icon(
                          Icons.exit_to_app,
                          size: 50,
                          color: colorPalette.fuente,
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