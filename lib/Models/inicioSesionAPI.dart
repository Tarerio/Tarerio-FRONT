import 'dart:convert';
import 'package:http/http.dart' as http;

class InicioSesionAPI {
  static const String _baseUrl = 'http://10.0.2.2:3000';

  Future<Map<String, dynamic>> inicioSesionAlumno(String patron) async {
    String url = '$_baseUrl/usuarios/inicioSesionAlumno?patron=$patron';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Una petición POST para ver si un usuario se encuentra en la tabla administrador
  Future<Map<String, dynamic>> inicioSesionAdministrador(String nickname, String contrasenia) async {
    String url = '$_baseUrl/usuarios/inicioSesionAdministrador';
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
  Future<Map<String, dynamic>> inicioSesionProfesor(String nickname, String contrasenia) async {
    String url = '$_baseUrl/usuarios/inicioSesionProfesor';
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