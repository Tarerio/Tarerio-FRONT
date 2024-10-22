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
}