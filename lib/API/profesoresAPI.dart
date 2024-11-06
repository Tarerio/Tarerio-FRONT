import 'dart:convert';
import 'package:http/http.dart' as http;

// API de Profesores
class ProfesoresAPI {
  static const String _baseUrl = 'http://localhost:3000';

  /// Método para obtener todos los profesores
  Future<List<dynamic>> obtenerProfesores() async {
    String url = '$_baseUrl/profesores';

    // Realizar la solicitud GET
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Decodificar la respuesta JSON
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['usuarios']; // Retorna la lista de profesores
    } else {
      // Lanzar una excepción si hay un error
      throw Exception('Error al cargar los profesores: ${response.statusCode}');
    }
  }
}
