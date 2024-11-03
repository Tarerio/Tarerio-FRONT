import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import '../Pages/crearAula.dart';

// API de Aulas
class AulasAPI {
  static const String _baseUrl = 'http://localhost:3000'; // localhost un máquina no se quien es

  // Añadir imagen y funcionalidad extra para asignar alumnos
  Future<Map<String, dynamic>?> crearAula(
      String clave,
      int cupo) async {

    String url = '$_baseUrl/aulas/crear';

    final Map<String, dynamic> body = {
      "clave_aula": clave,
      "cupo": cupo,
    };

    final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body)
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to create classroom');
    }
  }

  Future<List<dynamic>> obtenerAulas() async {
    String url = '$_baseUrl/aulas';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('aulas') && data['aulas'] != null) {
        return data['aulas'];
      } else {
        throw Exception('Key "aulas" not found or is null');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  eliminarAula(String id) {
    // impletementar logica de eliminar tarea
  }
}
