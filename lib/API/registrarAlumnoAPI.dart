import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrarAlumnoAPI {
  static const String _baseUrl = 'http://localhost:3000';
  static const String _baseUrlTablet = 'http://10.0.2.2:3000';

  Future<Map<String, dynamic>> registrarAlumno(
      String nickname,
      String patron,
      bool texto,
      bool imagenes,
      bool pictograma,
      bool video,
      String image) async {
    String url = '$_baseUrl/alumnos/crear';

    var perfil = {
      'texto': texto,
      'imagenes': imagenes,
      'pictograma': pictograma,
      'video': video
    };

    final Map<String, dynamic> data = {
      'nickname': nickname,
      'patron': patron,
      'perfil': perfil,
      'image': image,
    };

    final String jsonBody = json.encode(data);

    print('Hacemos la petición');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );
    return json.decode(response.body);
  }
}
