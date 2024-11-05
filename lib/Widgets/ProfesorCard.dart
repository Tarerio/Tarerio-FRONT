import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Avatar.dart';

class ProfesorCard extends StatelessWidget {
  final int id_usuario;
  final String imagenBase64; // URL o ruta de la imagen
  final String nickname;
  final VoidCallback onAssign;
  const ProfesorCard({
    Key? key,
    required this.id_usuario,
    required this.imagenBase64,
    required this.nickname,
    required this.onAssign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( // Establecer el ancho deseado aquí
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
              radius: 100, // Adjust the size as needed
              backgroundImage: MemoryImage(base64Decode(imagenBase64))
            )
            : Avatar(image: null, size: 150),
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
                // Botón de Editar
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/administrador/profesores/editarContrasenia', arguments: id_usuario);
                  },
                  icon: const Icon(Icons.key , color: Colors.teal),
                  label: const Text('Editar Contraseña'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
                // Botón de Asignar
                TextButton.icon(
                  onPressed: onAssign,
                  icon: const Icon(Icons.person_add, color: Colors.teal),
                  label: const Text('Asignar'),
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
