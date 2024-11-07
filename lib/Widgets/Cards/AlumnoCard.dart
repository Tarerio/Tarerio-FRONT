import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Avatar.dart';

class AlumnoCard extends StatelessWidget {
  final int id_usuario;
  final String imagenBase64; // URL o ruta de la imagen
  final String nickname;
  final VoidCallback onAssign;

  const AlumnoCard({
    Key? key,
    required this.id_usuario,
    required this.imagenBase64,
    required this.nickname,
    required this.onAssign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Set the desired width
      height: 300, // Set the desired height
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
            // Imagen del profesor
            imagenBase64 != null && imagenBase64.isNotEmpty
                ? CircleAvatar(
                    radius: 50, // Adjust the size as needed
                    backgroundImage: MemoryImage(base64Decode(imagenBase64)),
                  )
                : Avatar(image: null, size: 50),
            // Nombre del aula
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
            // Botones de Editar y Asignar
            OverflowBar(
              alignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // Botón de Editar alumno del alumno
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/administrador/alumnos/editarAlumno',
                        arguments: id_usuario);
                  },
                  icon: const Icon(Icons.key, color: Colors.teal),
                  label: const Text('Editar alumno'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
                // Botón de Eliminar
                TextButton.icon(
                  onPressed: onAssign,
                  icon: const Icon(Icons.delete, color: Colors.teal),
                  label: const Text('Eliminar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
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
