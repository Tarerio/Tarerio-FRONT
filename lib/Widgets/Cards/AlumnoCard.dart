import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Avatar.dart';

class AlumnoCard extends StatefulWidget {
  final int id_usuario;
  final String imagenBase64; // URL o ruta de la imagen
  final String nickname;
  final VoidCallback? onEdit;
  final VoidCallback? onAssign;
  final VoidCallback? onDelete;
  final VoidCallback? onSelect;
  final VoidCallback? onAccesibilidad;
  final VoidCallback? onGetTasks;
  final VoidCallback? onStatistics;

  const AlumnoCard({
    Key? key,
    required this.id_usuario,
    required this.imagenBase64,
    required this.nickname,
    this.onEdit,
    this.onAssign,
    this.onDelete,
    this.onSelect,
    this.onAccesibilidad,
    this.onGetTasks,
    this.onStatistics,
  }) : super(key: key);

  _AlumnoCardState createState() => _AlumnoCardState();
}

class _AlumnoCardState extends State<AlumnoCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Set the desired width
      height: 340, // Set the desired height
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
            widget.imagenBase64.isNotEmpty
                ? CircleAvatar(
                    radius: 50, // Adjust the size as needed
                    backgroundImage:
                        MemoryImage(base64Decode(widget.imagenBase64)),
                  )
                : const Avatar(
                    size: 50,
                    placeholderIcon: Icon(Icons.school, color: Colors.white),
                  ),
            // Nombre del aula
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.nickname,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            // Botones de Editar, Asignar y Eliminar si se especifican
            if (widget.onEdit != null ||
                widget.onAssign != null ||
                widget.onDelete != null ||
                widget.onSelect != null)
              OverflowBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Botón de Editar alumno
                  if (widget.onEdit != null)
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/administrador/alumnos/editarAlumno',
                          arguments: widget.id_usuario,
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.teal),
                      label: const Text('Editar alumno'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                      ),
                    ),
                  // Accesibilidad
                  if (widget.onAccesibilidad != null)
                    TextButton.icon(
                      onPressed: widget.onAccesibilidad,
                      icon: const Icon(Icons.accessibility, color: Colors.teal),
                      label: const Text('Accesibilidad'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                      ),
                    ),
                  // Botón de Asignar tarea solo si onAssign no es null
                  if (widget.onAssign != null)
                    TextButton.icon(
                      onPressed: widget.onAssign,
                      icon:
                          const Icon(Icons.person_add_alt, color: Colors.teal),
                      label: const Text('Asignar tarea'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                      ),
                    ),
                  if (widget.onGetTasks != null)
                    TextButton.icon(
                      onPressed: widget.onGetTasks,
                      icon: const Icon(Icons.assignment, color: Colors.teal),
                      label: const Text('Sus tareas'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                      ),
                    ),
                  if (widget.onStatistics != null)
                    TextButton.icon(
                      onPressed: widget.onStatistics,
                      icon: const Icon(Icons.bar_chart, color: Colors.teal),
                      label: const Text('Estadisticas'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                      ),
                    ),
                  // Botón de Eliminar solo si onDelete no es null
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
                      icon:
                          const Icon(Icons.assignment_add, color: Colors.teal),
                      label: const Text('Seleccionar'),
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
