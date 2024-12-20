import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';

// API de TareaJuego
class TareaJuegoAPI {
  Future<Map<String, dynamic>?> crearTareaJuego(
      String titulo,
      String descripcion,
      DateTime fechaCreacion,
      String urlJuego,
      int IdAdministrador,
      String imagen) async {
    String url = '$baseUrl/tareaJuego';

    // Captura la hora de creación actual
    fechaCreacion = DateTime.now();
    final String formattedCreacionDate = fechaCreacion.toIso8601String();

    final Map<String, dynamic> body = {
      "Titulo": titulo,
      "Descripcion": descripcion,
      "Fecha_creacion": formattedCreacionDate,
      "Enlace": urlJuego,
      "creatorId": IdAdministrador,
      "imagen": imagen,
    };

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerTareas() async {
    String url = '$baseUrl/tareaJuego';

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

  Future<List<Map<String, dynamic>>> getFilteredTareas(
      {String? nombreTarea}) async {
    String url = '$baseUrl/tareaJuego/filtered?nombreTarea=$nombreTarea';

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

  Future<Map<String, dynamic>> asignarAlumnoTarea(
      int idTarea, int idAlumno, DateTime dueDate, TimeOfDay dueTime) async {
    String url = '$baseUrl/tareaJuego/$idTarea/asignar';

    final DateTime fullDueDateTime = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      dueTime.hour,
      dueTime.minute,
    );
    final String formattedDueDate = fullDueDateTime.toIso8601String();

    final Map<String, dynamic> body = {
      "id_usuario": idAlumno,
      "Fecha_fin_asignacion": formattedDueDate
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

  Future<Map<String, dynamic>> obtenerTareaByID(int idTarea) async {
    String url = '$baseUrl/tareaJuego/$idTarea';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Map<String, dynamic>> updateTarea(
      int idTarea, Map<String, dynamic> tarea) async {
    String url = '$baseUrl/tareaJuego/$idTarea';

    final Map<String, dynamic> body = {
      "Titulo": tarea['Titulo'] ?? ' ',
      "Descripcion": tarea['Descripcion'],
      "imagen": tarea['imagenBase64'],
      "Enlace": tarea['Enlace'],
    };

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Aseguramos que la API responde con un 200 OK para una actualización exitosa
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update task');
    }
  }

  eliminarTarea(int id) async {
    String url = '$baseUrl/tareaJuego/$id';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception(response.body);
    }
  }

  obtenerAsignadasAlumno(String nickname, String? estado, String? fecha) async {
    String url = '$baseUrl/tareaJuego/$nickname/asignadas';

    // estado y fecha son query arguments, no path parameters

    if (estado != null) {
      url += '?estado=$estado';
    }

    if (fecha != null) {
      url += estado != null ? '&fecha=$fecha' : '?fecha=$fecha';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((tarea) => tarea as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> markAsDone(int idTarea, String idAlumno) async {
    String url = '$baseUrl/tareaJuego/marcarTarea/marcar';

    final Map<String, dynamic> body = {
      "nickname": idAlumno,
      "ID_tarea": idTarea,
      "completado": true,
      "revisado": true
    };

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to mark task as done');
    }
  }

  Future<void> markAsDoneByALumno(int idTarea, String idAlumno) async {
    String url = '$baseUrl/tareaJuego/marcarTarea/marcar';

    final Map<String, dynamic> body = {
      "nickname": idAlumno,
      "ID_tarea": idTarea,
      "completado": true,
      "revisado": false
    };

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to mark task as done');
    }
  }
}
