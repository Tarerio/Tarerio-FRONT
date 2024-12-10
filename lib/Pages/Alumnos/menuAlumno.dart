import 'package:flutter/material.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/Pages/Alumnos/calendario.dart';
import 'package:tarerio/Pages/Alumnos/perfilAlumno.dart';
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
      body: Container(
        color: colorPalette.fondo,
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 340.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.0, // Ensures the items are square
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _buildMenuOption(
                    context,
                    'TAREAS',
                    Icons.assignment,
                    colorPalette.colorSecundario,
                        () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PrincipalAlumno(nickname: widget.nickname)),
                            (Route<dynamic> route) => false,
                      );
                    },
                  );
                case 1:
                  return _buildMenuOption(
                    context,
                    'CALENDARIO',
                    Icons.calendar_view_week_sharp,
                    colorPalette.colorSecundario,
                        () {
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
                  );
                case 2:
                  return _buildMenuOption(
                    context,
                    'MI PERFIL',
                    Icons.person,
                    colorPalette.colorSecundario,
                        () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder:
                            (context) => PerfilAlumno(nickname: widget.nickname
                            , colorPalette: colorPalette,
                            titleFontSize: titleFontSize,
                            textFontSize: textFontSize)),
                            (Route<dynamic> route) => false,
                      );
                    },
                  );
                case 3:
                  return _buildMenuOption(
                    context,
                    'CERRAR SESIÓN',
                    Icons.exit_to_app,
                    colorPalette.componentes,
                        () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    final colorPalette = widget.colorPalette;
    final titleFontSize = widget.titleFontSize;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 200,
        width: 200,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: colorPalette.fuente,
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                icon,
                size: 50,
                color: colorPalette.fuente,
              ),
            ],
          ),
        ),
      ),
    );
  }
}