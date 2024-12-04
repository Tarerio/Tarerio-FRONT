import 'dart:convert';
import 'package:tarerio/consts.dart';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Avatar.dart';

class TareaCard extends StatefulWidget {
  final int ID_tarea;
  final String titulo;
  final String descripcion;
  final String imagenBase64;
  final String tipo;
  final VoidCallback? onEdit;
  final VoidCallback? onAssign;
  final VoidCallback? onDelete;
  final VoidCallback? onSelect;
  final VoidCallback? onRevisar;

  const TareaCard({
    Key? key,
    required this.ID_tarea,
    required this.titulo,
    required this.descripcion,
    required this.imagenBase64,
    required this.tipo,
    this.onEdit,
    this.onAssign,
    this.onDelete,
    this.onSelect,
    this.onRevisar,
  }) : super(key: key);

  @override
  _TareaCardState createState() => _TareaCardState();
}

class _TareaCardState extends State<TareaCard> {

  Icon _getIconForTipoTarea(String tipo) {
    switch (tipo) {
      case TAREA_JUEGO:
        return const Icon(Icons.games, color: Colors.white);
      case TAREA_PETICION:
        return const Icon(Icons.question_answer, color: Colors.white);
      case TAREA_POR_PASOS:
        return const Icon(Icons.list_rounded, color: Colors.white);
      default:
        return const Icon(Icons.edit_square, color: Colors.white); // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Set the desired width
      height: 330, // Set the desired height
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
                widget.tipo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Task image
            widget.imagenBase64.isNotEmpty
                ? CircleAvatar(
              radius: 50,
              backgroundImage: MemoryImage(base64Decode(widget.imagenBase64)),
            )
                : Avatar(
              size: 50,
              placeholderIcon: _getIconForTipoTarea(widget.tipo),
            ),
            // Task title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            // Buttons for Edit, Assign, Delete, Select, and Review
            if (widget.onEdit != null ||
                widget.onAssign != null ||
                widget.onDelete != null ||
                widget.onSelect != null ||
                widget.onRevisar != null)
              OverflowBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (widget.onEdit != null)
                    TextButton.icon(
                      onPressed: widget.onEdit,
                      icon: const Icon(Icons.edit, color: Colors.teal),
                      label: const Text('Editar Tarea'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                      ),
                    ),
                  if (widget.onAssign != null)
                    TextButton.icon(
                      onPressed: widget.onAssign,
                      icon: const Icon(Icons.person_add_alt, color: Colors.teal),
                      label: const Text('Asignar a Alumno'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                      ),
                    ),
                  if (widget.onDelete != null)
                    TextButton.icon(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete, color: Colors.deepOrange),
                      label: const Text('Eliminar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepOrange,
                      ),
                    ),
                  if (widget.onSelect != null)
                    TextButton.icon(
                      onPressed: widget.onSelect,
                      icon: const Icon(Icons.assignment_add, color: Colors.teal),
                      label: const Text('Seleccionar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                      ),
                    ),
                  if (widget.onRevisar != null)
                    TextButton.icon(
                      onPressed: widget.onRevisar,
                      icon: const Icon(Icons.check, color: Colors.teal),
                      label: const Text('Revisar' , style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 20)),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.teal,
                        elevation: 4,
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
