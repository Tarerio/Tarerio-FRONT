import 'package:flutter/material.dart';

class TareaPorPasosCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String horaCierre; // Nueva propiedad para la hora de cierre
  final VoidCallback onEdit;
  final VoidCallback onAssign;
  final VoidCallback onDelete;

  const TareaPorPasosCard({
    required this.titulo,
    required this.descripcion,
    required this.horaCierre, // Asegúrate de agregar este parámetro
    required this.onEdit,
    required this.onAssign,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Muestra el título
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Muestra la descripción
              Text(
                descripcion,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Muestra la hora de cierre
              Text(
                horaCierre,
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: onAssign,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
