import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Avatar.dart';

class AulaCard extends StatelessWidget {
  final int idUsuario;
  final String imagenAula; // URL o ruta de la imagen
  final String claveAula;
  final int cupoAula;
  final VoidCallback? onAssign;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AulaCard(
      {Key? key,
        required this.idUsuario,
        required this.imagenAula,
        required this.claveAula,
        required this.cupoAula,
        this.onAssign,
        this.onEdit,
        this.onDelete
      })
      : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    // Intentar decodificar la imagen base64
    try {
      imageProvider = MemoryImage(base64Decode(imagenAula));
    } catch (e) {
      // Si falla la decodificación, usa una imagen de marcador de posición
      print('Error al decodificar imagen: $e');
      imageProvider = null;
    }

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
            // Imagen del profesor o marcador de posición
            imageProvider != null
                ? CircleAvatar(
              radius: 50,
              backgroundImage: imageProvider,
            )
                : const Avatar(
              image: null,
              size: 50,
              placeholderIcon: Icon(
                Icons.table_restaurant_rounded,
                color: Colors.white,
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
            // Botones de Editar, Asignar, Eliminar
            OverflowBar(
              alignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.key, color: Colors.teal),
                  label: const Text('Editar Aula'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
                TextButton.icon(
                  onPressed: onAssign,
                  icon: const Icon(Icons.person_add_alt, color: Colors.teal),
                  label: const Text('Asignar Profesor'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
                TextButton.icon(
                  onPressed: onDelete,
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
