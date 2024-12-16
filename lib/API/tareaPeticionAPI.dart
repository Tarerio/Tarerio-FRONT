import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';
import 'package:tarerio/Models/enunciado.dart';
import 'package:tarerio/API/profesoresAPI.dart';

// API de TareaPeticion
class TareaPeticionAPI {

  ProfesoresAPI profesoresAPI = ProfesoresAPI();

  Future<Map<String, dynamic>?> crearTareaPeticion(
      String titulo,
      String descripcion,
      DateTime fechaCreacion,
      int idAdministrador,
      List<Enunciado> enunciados,
      String imagen) async {
    String url = '$baseUrl/tareaPeticion';

    // Captura la hora de creación actual
    fechaCreacion = DateTime.now();
    final String formattedCreacionDate = fechaCreacion.toIso8601String();

    final Map<String, dynamic> body = {
      "Titulo": titulo,
      "Descripcion": descripcion,
      "Fecha_creacion": formattedCreacionDate, // Solo la fecha de creación
      "creatorId": idAdministrador,
      "enunciados": enunciados
          .map((enunciado) => {
        "Texto": enunciado.texto,
        "Imagen": enunciado.imagen,
        "Video": enunciado.video
      })
          .toList(), // Convertir cada enunciado en un mapa
      "imagen" : imagen,
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
    String url = '$baseUrl/tareaPeticion';

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

  Future<List<Map<String, dynamic>>> getFilteredTareas({String? nombreTarea}) async {
    String url = '$baseUrl/tareaPeticion/filtered?nombreTarea=$nombreTarea';

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

  eliminarTarea(int id) async {
    String url = '$baseUrl/tareaPeticion/$id';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception(response.body);
    }
  }


  Future<Map<String, dynamic>> asignarAlumnoTarea(int idTarea, int idAlumno, DateTime dueDate, TimeOfDay dueTime, int stepPage) async {
    String url = '$baseUrl/tareaPeticion/$idTarea/asignar';

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
      "Fecha_fin_asignacion": formattedDueDate,
      "pasosPagina": stepPage
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

  Future<Map<String, dynamic>> obtenerTareaByID(int idTarea) async{
    String url = '$baseUrl/tareaPeticion/$idTarea';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Map<String, dynamic>> updateTarea(int idTarea, Map<String, dynamic> tarea) async
  {
    String url = '$baseUrl/tareaPeticion/$idTarea';

    final Map<String, dynamic> body = {
      "Titulo": tarea['Titulo'],
      "Descripcion": tarea['Descripcion'],
      "imagen" : tarea['imagenBase64'],
      "enunciados": tarea['Enunciados']
          .map((enunciado) =>
      {
        "Texto": enunciado['Texto'],
        "Imagen": enunciado['Imagen'],
        "Video": enunciado['Video'],
      })
          .toList(), // Convertir cada enunciado en un mapa
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
      throw Exception('Failed to update task');
    }
  }

  obtenerAsignadasAlumno(String nickname, String? estado, String? fecha) async {
    String url = '$baseUrl/tareaPeticion/$nickname/asignadas';

    if (estado != null) {
      url += '?estado=$estado';
    }

    if (fecha != null) {
      url += estado != null ? '&fecha=$fecha' : '?fecha=$fecha';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((tarea) => tarea as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> createAndAssignTask(
      String titulo,
      String descripcion,
      DateTime fechaCreacion,
      int idAdministrador,
      List<Enunciado> enunciados,
      String imagen,
      int idAlumno,
      DateTime dueDate,
      int id_pedido
      ) async {
    try {

      // Create the task
      final taskResponse = await crearTareaPeticion(
          titulo,
          descripcion,
          fechaCreacion,
          idAdministrador,
          enunciados,
          imagen
      );

      print( 'Task created with ID: ' + taskResponse.toString());

      if (taskResponse != null) {
        final int idTarea = taskResponse['ID_tarea'];

        // Assign the task to the student
        final TimeOfDay dueTime = TimeOfDay(hour: 20, minute: 0); // 8 PM
        final int stepPage = 3;

        await asignarAlumnoTarea(idTarea, idAlumno, dueDate, dueTime, stepPage);

        await profesoresAPI.marcarPedidoRecibido(id_pedido);
      } else {
        throw Exception('Failed to create task');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to create and assign task');
    }
  }

  Future<void> markAsDone(int idTarea, String idAlumno) async {
    String url = '$baseUrl/tareaPeticion/marcarTarea/marcar';

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

  Future<void> markAsDoneByAlumno(int idTarea, String idAlumno) async {
    String url = '$baseUrl/tareaPeticion/marcarTarea/marcar';

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