import 'package:flutter/material.dart';
import 'dart:convert';
import '../API/alumnosAPI.dart';
import '../Models/menuAccesible.dart'; // Assuming you have a ColorPalette model
import '../Pages/Alumnos/menuAlumno.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  final String nickname;
  final ColorPalette colorPalette;
  final double titleFontSize;
  final double textFontSize;

  const Header({
    super.key,
    required this.nickname,
    required this.colorPalette,
    required this.titleFontSize,
    required this.textFontSize,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HeaderState createState() => _HeaderState();

  @override
  Size get preferredSize =>
      const Size.fromHeight(100); // Define the size of the AppBar
}

class _HeaderState extends State<Header> {
  String? imageUrl;
  final AlumnosAPI _api = AlumnosAPI();

  @override
  void initState() {
    super.initState();
    _loadAlumnoData();
  }

  void _loadAlumnoData() async {
    try {
      final response = await _api.obtenerAlumno(widget.nickname);
      if (response['status'] == 'success') {
        final alumno = response['alumno'];
        if (alumno['imagenBase64'].isNotEmpty) {
          setState(() {
            imageUrl = alumno['imagenBase64'];
          });
        }
      }
    } catch (e) {
      // Handle error if needed
    }
  }

  Color _getColorFromInitial(String initial) {
    final int hash = initial.codeUnitAt(0);
    final int colorIndex = hash % Colors.primaries.length;
    return Colors.primaries[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    String initial =
        widget.nickname.isNotEmpty ? widget.nickname[0].toUpperCase() : 'U';
    Color avatarColor = _getColorFromInitial(initial);

    return AppBar(
      automaticallyImplyLeading: false, // Quita la flecha de volver atrás
      toolbarHeight: 100, // Adjust the height of the AppBar
      elevation: 4,
      shadowColor: Colors.black,
      backgroundColor: widget.colorPalette.componentes,
      title: Row(
        children: [
          // User image or initial with background color
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: imageUrl != null
                ? ClipOval(
                    child: Image.memory(
                      base64Decode(imageUrl!),
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: avatarColor,
                    child: Text(
                      initial,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.textFontSize,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 25),
          // Title of the AppBar
          Text(
            widget.nickname.toUpperCase(),
            style: TextStyle(
              fontSize: widget.titleFontSize,
              fontWeight: FontWeight.w600,
              color: widget.colorPalette.fuente,
            ),
          ),
          const Spacer(), // Pushes the menu icon to the right
          TextButton.icon(
            icon: Icon(Icons.menu_book,
                size: 30, color: widget.colorPalette.fuente),
            label: Text(
              'MENÚ',
              style: TextStyle(fontSize: 30, color: widget.colorPalette.fuente),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PanelAlumno(
                      nickname: widget.nickname,
                      colorPalette: widget.colorPalette,
                      titleFontSize: 24,
                      textFontSize: 16),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
