import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Avatar.dart';

class AlumnoDeAulaCard extends StatelessWidget {
  final int id_usuario;
  final String imagenBase64; // URL o ruta de la imagen
  final String nickname;
  final VoidCallback onDelete;

  const AlumnoDeAulaCard({
    Key? key,
    required this.id_usuario,
    required this.imagenBase64,
    required this.nickname,
    required this.onDelete,
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
            imagenBase64.isNotEmpty
                ? CircleAvatar(
                    radius: 50, // Adjust the size as needed
                    backgroundImage: MemoryImage(base64Decode(imagenBase64)),
                  )
                : const Avatar(
                    size: 50,
                    placeholderIcon: Icon(Icons.school, color: Colors.white),
                  ),
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
                // Botón de Eliminar
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
