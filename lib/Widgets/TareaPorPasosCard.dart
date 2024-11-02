import 'package:flutter/material.dart';

class TareaCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String tipo;
  final String imagenUrl;
  final VoidCallback onEdit;
  final VoidCallback onAssign;

  const TareaCard({
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    required this.imagenUrl,
    required this.onEdit,
    required this.onAssign,
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
              Image.network(
                imagenUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                descripcion,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.assignment),
                    onPressed: onAssign,
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
