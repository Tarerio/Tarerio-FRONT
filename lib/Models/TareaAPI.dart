import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TareaAPI {
  static const String _baseUrl = 'http://10.0.2.2:3000';

  Future<Map<String, dynamic>> crearTareaJuego(String titulo, String descripcion, String url, DateTime dueDate, TimeOfDay dueTime) async {
    String url = '$_baseUrl/tareaJuego';

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
      "Enlace": url,
      "creatorId": 1 // El ID del creador (esto podría cambiar si es dinámico)
    };

    final response = await http.post(
        Uri.parse(url),
        headers: { 'Content-Type': 'application/json'},
        body: jsonEncode(body)
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}