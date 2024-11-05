import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';

class InicioSesionAPI {
  // A GET request to fetch all students from the system.
  Future<List<dynamic>> getAlumnos() async {
    String url = '$baseUrl/alumnos';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('usuarios') && data['usuarios'] != null) {
        return data['usuarios'];
      } else {
        throw Exception('Key "usuarios" not found or is null');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

// Una petición POST para ver si un usuario se encuentra en la tabla alumno.
  Future<Map<String, dynamic>> inicioSesionAlumno(
      String nickname, String patron) async {
    String url = '$baseUrl/alumnos/inicioSesionAlumno';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'nickname': nickname,
        'patron': patron,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Una petición POST para ver si un usuario se encuentra en la tabla administrador
  Future<Map<String, dynamic>> inicioSesionAdministrador(
      String nickname, String contrasenia) async {
    String url = '$baseUrl/administradores/inicioSesionAdministrador';
    final response = await http.post(Uri.parse(url), body: {
      'nickname': nickname,
      'contrasenia': contrasenia,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Una petición POST para ver si un usuario se encuentra en la tabla profesor.
  Future<Map<String, dynamic>> inicioSesionProfesor(
      String nickname, String contrasenia) async {
    String url = '$baseUrl/profesores/inicioSesionProfesor';
    final response = await http.post(Uri.parse(url), body: {
      'nickname': nickname,
      'contrasenia': contrasenia,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
