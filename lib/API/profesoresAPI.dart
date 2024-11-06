import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';

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
      throw Exception('Failed to load data');
    }
  }

  cambiarContraseniaProfesor(
      int id, String contraseniaActual, String contraseniaNueva) async {
    String url = '$baseUrl/profesores/$id/cambiarContrasenia';

    final Map<String, dynamic> data = {
      "contraseniaActual": contraseniaActual,
      "contraseniaNueva": contraseniaNueva,
    };

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to change password: ' +
          json.decode(response.body)['message']);
    }
  }
}
