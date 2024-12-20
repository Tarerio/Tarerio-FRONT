import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Avatar.dart';

class AlumnoDeAulaCard extends StatelessWidget {
  final int id_usuario;
  final String imagenBase64;
  final String nickname;
  final VoidCallback onDelete;
  final bool showDeleteButton;

  const AlumnoDeAulaCard({
    Key? key,
    required this.id_usuario,
    required this.imagenBase64,
    required this.nickname,
    required this.onDelete,
    this.showDeleteButton = true, // Default value is true
  }) : super(key: key);

  void _navegarTareasAlumno(context) {
    Navigator.pushNamed(
        context, '/administrador/alumnos/tareas',
        arguments: nickname);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 400,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 15),
            imagenBase64.isNotEmpty
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: MemoryImage(base64Decode(imagenBase64)),
                  )
                : const Avatar(
                    size: 50,
                    placeholderIcon: Icon(Icons.school, color: Colors.white),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                nickname,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => _navegarTareasAlumno(context),
              icon: const Icon(Icons.assignment, color: Colors.teal),
              label: const Text('Sus tareas'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
              ),
            ),
            if (showDeleteButton)
              OverflowBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.deepOrange),
                    label: const Text('Eliminar'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}