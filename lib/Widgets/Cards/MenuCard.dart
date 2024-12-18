import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Avatar.dart';

class MenuCard extends StatelessWidget {
  final int idMenu;
  final String tipoMenu;
  final String contenidoMenu;
  final String imagenMenu; // URL o ruta de la imagen
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MenuCard(
      {Key? key,
        required this.idMenu,
        required this.tipoMenu,
        required this.contenidoMenu,
        required this.imagenMenu,
        this.onEdit,
        this.onDelete,
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
            imagenMenu.isNotEmpty
                ? CircleAvatar(
              radius: 50, // Adjust the size as needed
              backgroundImage: MemoryImage(base64Decode(imagenMenu)),
            )
                : const Avatar(
              size: 50,
              placeholderIcon: Icon(Icons.fastfood,
                  color: Colors.white),
            ),
            // Tipo de menu
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tipoMenu,
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
                    icon: const Icon(Icons.edit, color: Colors.teal),
                    label: const Text('Editar Menu'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.teal,
                    ),
                  ),
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
