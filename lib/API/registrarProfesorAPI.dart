import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrarProfesorAPI {
  static const String _baseUrl = 'http://localhost:3000';

  Future<Map<String, dynamic>> registrarProfesor(String nickname, String patron) async {
    String url = '$_baseUrl/profesores/crear';

    final Map<String, dynamic> data = {
      'nickname': nickname,
      'patron': patron,
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
