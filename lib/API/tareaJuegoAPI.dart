import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';

class TareaAPI {
  Future<Map<String, dynamic>?> crearTareaJuego(
      String titulo,
      String descripcion,
      String urlJuego,
      DateTime dueDate,
      TimeOfDay dueTime,
      int IdAdministrador) async {
    String url = '$baseUrl/tareaJuego';

    final DateTime fullDueDateTime = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      dueTime.hour,
      dueTime.minute,
    );

    final String formattedDueDate = fullDueDateTime.toIso8601String();

    final Map<String, dynamic> body = {
      "Titulo": titulo,
      "Descripcion": descripcion,
      "Fecha_estimada_cierre": formattedDueDate,
      "Enlace": urlJuego,
      "creatorId": IdAdministrador
    };

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
