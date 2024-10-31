import 'package:flutter/material.dart';

class AulaCard extends StatelessWidget {
  final String nombreAula;
  final String imagenUrl; // URL o ruta de la imagen
  final VoidCallback onEdit;
  final VoidCallback onAssign;

  const AulaCard({
    Key? key,
    required this.nombreAula,
    required this.imagenUrl,
    required this.onEdit,
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
          children: <Widget>[
            // Imagen del aula
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
              child: Image.network(
                imagenUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Nombre del aula
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                nombreAula,
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
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.teal),
                  label: const Text('Editar'),
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
