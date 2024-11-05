import 'dart:convert';
import 'package:http/http.dart' as http;

class InicioSesionAPI {
  static const String _baseUrl = 'http://localhost:3000';
  static const String _baseUrlTablet = 'http://10.0.2.2:3000';

  // A GET request to fetch all students from the system.
  Future<List<dynamic>> getAlumnos() async {
    String url = '$_baseUrl/alumnos';
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
    String url = '$_baseUrl/alumnos/inicioSesionAlumno';
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
    String url = '$_baseUrl/administradores/inicioSesionAdministrador';
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
    String url = '$_baseUrl/profesores/inicioSesionProfesor';
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
