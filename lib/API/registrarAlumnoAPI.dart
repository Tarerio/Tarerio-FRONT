import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';

class RegistrarAlumnoAPI {
  Future<Map<String, dynamic>> registrarAlumno(
      String nickname,
      String patron,
      bool texto,
      bool imagenes,
      bool pictograma,
      bool video,
      String image) async {
    String url = '$baseUrl/alumnos/crear';

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
