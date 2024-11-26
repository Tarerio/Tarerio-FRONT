import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Header.dart';
import 'package:tarerio/Models/menuAccesible.dart';

class TareaAlumno extends StatelessWidget {
  final String nickname;
  final String title;
  final String descripcion;
  final String image;
  final ColorPalette colorPalette;

  const TareaAlumno({
    super.key,
    required this.nickname,
    required this.title,
    required this.descripcion,
    required this.image,
    required this.colorPalette,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(nickname: nickname),
      backgroundColor: colorPalette.fondo,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 600;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                // Título de la tarea
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 36 : 28,
                    fontWeight: FontWeight.bold,
                    color: colorPalette.fuente,
                  ),
                ),
                const SizedBox(height: 24),
                // Imagen de la tarea
                Container(
                  height: isTablet ? constraints.maxHeight * 0.4 : constraints.maxHeight * 0.3,
                  width: isTablet ? constraints.maxWidth * 0.8 : constraints.maxWidth * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: MemoryImage(base64Decode(image)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Descripción de la tarea
                Text(
                  descripcion,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 16,
                    height: 1.6,
                    color: colorPalette.fuente,
                  ),
                ),
                const Spacer(),
                // Botón para comenzar tarea
                SizedBox(
                  width: double.infinity,
                  height: isTablet ? 80 : 60,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPalette.componentes,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'COMENZAR TAREA',
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 18,
                        fontWeight: FontWeight.bold,
                        color: colorPalette.fuente,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Botón para volver atrás
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'VOLVER ATRÁS',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
