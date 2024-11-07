import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Pages/Tareas/crearTareaPorPasos.dart';
import 'package:tarerio/consts.dart';

// API de TareaPorPasos
class TareaPorPasosAPI {
  Future<Map<String, dynamic>?> crearTareaPorPasos(
      String titulo,
      String descripcion,
      DateTime fechaCreacion,
      DateTime dueDate,
      TimeOfDay dueTime,
      int idAdministrador,
      List<Subtarea> subtareas) async {
    String url = '$baseUrl/tareaPorPasos';

    final DateTime fullDueDateTime = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      dueTime.hour,
      dueTime.minute,
    );
    final String formattedDueDate = fullDueDateTime.toIso8601String();

    // Captura la hora de creación actual
    fechaCreacion = DateTime.now();
    final String formattedCreacionDate = fechaCreacion.toIso8601String();

    final Map<String, dynamic> body = {
      "Titulo": titulo,
      "Descripcion": descripcion,
      "Fecha_estimada_cierre": formattedDueDate,
      "Fecha_creacion": formattedCreacionDate,
      "creatorId": idAdministrador,
      "subtareas": subtareas
          .map((subtarea) => {
                "Texto": subtarea.texto,
                "Imagen": subtarea.imagen,
                "Pictograma": subtarea.pictograma,
                "Video": subtarea.video
              })
          .toList(), // Convertir cada subtarea en un mapa
    };

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to create task');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerTareas() async {
    String url = '$baseUrl/tareaPorPasos';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((tarea) => tarea as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  eliminarTarea(String id) {
    // impletementar logica de eliminar tarea
  }
}
