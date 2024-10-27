import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrarAlumnoAPI {
  static const String _baseUrl = 'http://localhost:3000';

  Future<Map<String, dynamic>> registrarAlumno(String nickname, String patron, bool texto, bool imagenes, bool pictograma, bool video) async {
    String url = '$_baseUrl/alumnos/crear';

    var perfil = {'texto': texto, 'imagenes': imagenes, 'pictograma': pictograma, 'video': video};

    final Map<String, dynamic> data = {
      'nickname': nickname,
      'patron': patron,
      'perfil': perfil,
    };

    final String jsonBody = json.encode(data);

    print('Hacemos la petición');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body:  jsonBody,
    );
    return json.decode(response.body);
  }
}