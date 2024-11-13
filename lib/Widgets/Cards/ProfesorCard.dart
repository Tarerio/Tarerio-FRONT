import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/Pages/Profesores/profesores.dart';
import 'package:tarerio/Widgets/Avatar.dart';
import 'package:tarerio/API/profesoresAPI.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';

class ProfesorCard extends StatelessWidget {
  final int id_usuario;
  final String imagenBase64; // URL o ruta de la imagen
  final String nickname;
  final VoidCallback onAssign;
  final VoidCallback onDelete;
  
  const ProfesorCard({
    Key? key,
    required this.id_usuario,
    required this.imagenBase64,
    required this.nickname,
    required this.onAssign,
    required this.onDelete,
  }) : super(key: key);

  // Future<void> _borrarAula(String idProfesor) async {
  //   try {
  //     AulasAPI api = AulasAPI();
  //     await api.eliminarAula(idProfesor);
  //     setState(() {
  //       aulas.removeWhere((aula) => aula['id'] == id);
  //     });
  //     SuccessModal(
  //       content: "Profesor Eliminado Correctamente",
  //       title: "Exito",
  //       key: idProfesor,
  //     );
  //   } catch (e) {
  //     print("Error al eliminar aula: $e");
  //     _showErrorModal(context, "Error", "Error al eliminar el aula");
  //   }
  // }

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
            imagenBase64.isNotEmpty
                ? CircleAvatar(
                    radius: 50, // Adjust the size as needed
                    backgroundImage: MemoryImage(base64Decode(imagenBase64)),
                  )
                : const Avatar(
                    image: null,
                    size: 50,
                  ),
            // Nombre del aula
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                nickname,
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
                        context, '/administrador/profesores/editarContrasenia',
                        arguments: id_usuario);
                  },
                  icon: const Icon(Icons.key, color: Colors.teal),
                  label: const Text('Editar Contraseña'),
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
