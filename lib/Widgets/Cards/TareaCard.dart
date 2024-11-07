import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Avatar.dart';

class TareaCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String imagenbase64;
  final String tipo;
  final VoidCallback onEdit;
  final VoidCallback onAssign;
  final VoidCallback onDelete;

  const TareaCard({
    Key? key,
    required this.titulo,
    required this.descripcion,
    required this.imagenbase64,
    required this.tipo,
    required this.onEdit,
    required this.onAssign,
    required this.onDelete,
  })
      : super(key: key);

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
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                tipo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Imagen de la tarea
            imagenbase64.isNotEmpty
                ? CircleAvatar(
              radius: 50, // Adjust the size as needed
              backgroundImage: MemoryImage(base64Decode(imagenbase64)),
            )
                : const Avatar(image: null, size: 50),
            // Nombre de la tarea
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                TextButton.icon(
                  onPressed: () => {},
                  icon: const Icon(Icons.key, color: Colors.teal),
                  label: const Text('Editar Tarea'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
                // Boton Asignar Profesor
                TextButton.icon(
                  onPressed: onAssign,
                  icon: const Icon(Icons.person_add_alt, color: Colors.teal),
                  label: const Text('Asignar a Alumno'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
                // Botón de Eliminar
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.teal),
                  label: const Text('Elimnar'),
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
