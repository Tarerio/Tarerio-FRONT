import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Avatar.dart';

class AulaCard extends StatelessWidget {
  final int idUsuario;
  final String imagenAula; // URL o ruta de la imagen
  final String claveAula;
  final int cupoAula;
  final VoidCallback onAssign;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSeeStudents;

  const AulaCard(
      {Key? key,
        required this.idUsuario,
        required this.imagenAula,
        required this.claveAula,
        required this.cupoAula,
        required this.onAssign,
        required this.onEdit,
        required this.onDelete,
        required this.onSeeStudents,
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
            const SizedBox(height: 15),
            // Imagen del profesor
            imagenAula.isNotEmpty ? CircleAvatar(
              radius: 50, // Adjust the size as needed
              backgroundImage: MemoryImage(base64Decode(imagenAula)),
            )
                : const Avatar(
                  image: null, 
                  size: 50,
                  placeholderIcon: Icon(
                    Icons.table_restaurant_rounded,
                      color: Colors.white
                    ),
                ),
            // Nombre del aula
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                claveAula,
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
                  icon: const Icon(Icons.edit, color: Colors.teal),
                  label: const Text('Editar Aula'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
                // Boton Asignar Profesor
                TextButton.icon(
                  onPressed: onAssign,
                  icon: const Icon(Icons.person_add_alt, color: Colors.teal),
                  label: const Text('Profesores'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
                // Botón de Eliminar
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.teal),
                  label: const Text('Eliminar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
                // Botón de Ver Alumnos
                TextButton.icon(
                  onPressed: onSeeStudents,
                  icon: const Icon(Icons.people, color: Colors.teal),
                  label: const Text('Ver Alumnos'),
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
