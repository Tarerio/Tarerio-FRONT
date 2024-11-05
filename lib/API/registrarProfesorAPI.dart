import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrarProfesorAPI {
  static const String _baseUrl = 'http://localhost:3000';
  static const String _baseUrlTablet = 'http://10.0.2.2:3000';

  Future<Map<String, dynamic>> registrarProfesor(
      String nickname, String patron, String image) async {
    String url = '$_baseUrlTablet/profesores/crear';

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
