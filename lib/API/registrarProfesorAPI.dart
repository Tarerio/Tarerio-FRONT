import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';

class RegistrarProfesorAPI {
  Future<Map<String, dynamic>> registrarProfesor(
      String nickname, String patron, String image) async {
    String url = '$baseUrl/profesores/crear';

    final Map<String, dynamic> data = {
      'nickname': nickname,
      'patron': patron,
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
