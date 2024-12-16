import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/Pages/Profesores/profesores.dart';
import 'package:tarerio/Widgets/Avatar.dart';
import 'package:tarerio/API/profesoresAPI.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';

class ProfesorCard extends StatefulWidget {
  final int id_usuario;
  final String imagenBase64; // URL o ruta de la imagen
  final String nickname;
  final VoidCallback onDelete;
  final VoidCallback? onPedidosMaterial;

  const ProfesorCard({
    super.key,
    required this.id_usuario,
    required this.imagenBase64,
    required this.nickname,
    required this.onDelete,
    this.onPedidosMaterial,
  });

  @override
  _ProfesorCardState createState() => _ProfesorCardState();
}

class _ProfesorCardState extends State<ProfesorCard> {
  bool hasPendingPedidos = false;

  @override
  void initState() {
    super.initState();
    fetchPedidos();
  }

  Future<void> fetchPedidos() async {
    try {
      ProfesoresAPI api = ProfesoresAPI();
      final response = await api.obtenerPedidos(widget.nickname);
      final List<dynamic> allPedidos = response['pedidos'] ?? [];

      setState(() {
        hasPendingPedidos =
            allPedidos.any((pedido) => pedido['estado'] == 'Pendiente');
      });
    } catch (e) {
      print("Error al obtener pedidos: $e");
    }
  }

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
            widget.imagenBase64.isNotEmpty
                ? CircleAvatar(
                    radius: 50, // Adjust the size as needed
                    backgroundImage:
                        MemoryImage(base64Decode(widget.imagenBase64)),
                  )
                : const Avatar(
                    size: 50,
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
            // Botones de Editar y Asignar
            OverflowBar(
              alignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // Botón de Editar
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/administrador/profesores/editarProfesor',
                        arguments: widget.id_usuario);
                  },
                  icon: const Icon(Icons.edit, color: Colors.teal),
                  label: const Text('Editar Profesor'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
                // Botón de Editar
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/administrador/profesores/editarContrasenia',
                        arguments: widget.id_usuario);
                  },
                  icon: const Icon(Icons.key, color: Colors.teal),
                  label: const Text('Editar Contraseña'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
                if (widget.onPedidosMaterial != null)
                  TextButton.icon(
                    onPressed: widget.onPedidosMaterial,
                    icon: const Icon(Icons.list, color: Colors.teal),
                    label: Row(
                      children: [
                        const Text('Pedidos Material'),
                        if (hasPendingPedidos)
                          Container(
                            margin: const EdgeInsets.only(left: 8.0),
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.deepOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.teal,
                    ),
                  ),
                TextButton.icon(
                  onPressed: widget.onDelete,
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
