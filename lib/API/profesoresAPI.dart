import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';

// API de Profesores
class ProfesoresAPI {
  Future<List<dynamic>> obtenerProfesores() async {
    String url = '$baseUrl/profesores';

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

  cambiarContraseniaProfesor (int id, String contraseniaActual, String contraseniaNueva) async {
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
