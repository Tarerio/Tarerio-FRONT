import 'dart:convert';
import 'package:http/http.dart' as http;

// API de Profesores
class ProfesoresAPI {
  static const String _baseUrlTablet = 'http://10.0.2.2:3000';
  static const String _baseUrl =
      'http://localhost:3000'; // localhost un máquina no se quien es

  Future<List<dynamic>> obtenerProfesores() async {
    String url = '$_baseUrlTablet/profesores';

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

  cambiarContraseniaProfesor(
      int id, String contraseniaActual, String contraseniaNueva) async {
    String url = '$_baseUrlTablet/profesores/$id/cambiarContrasenia';

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
