import 'dart:convert';
import 'package:http/http.dart' as http;
//import '../Pages/crearAula.dart';
import 'package:tarerio/consts.dart';

// API de Aulas
class AulasAPI {
  static const String _baseUrl =
      'http://localhost:3000'; // localhost un máquina no se quien es


  // Añadir imagen y funcionalidad extra para asignar alumnos
  Future<Map<String, dynamic>> crearAula(String clave, String cupo) async {
    String url = '$baseUrl/aulas/crear';

    final Map<String, dynamic> data = {
      "clave": clave,
      "capacidad": cupo,
    };

    final String jsonBody = json.encode(data);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );
    return json.decode(response.body);
  }

  Future<List<dynamic>> obtenerAulas() async {
    String url = '$baseUrl/aulas';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('aulas') && data['aulas'] != null) {
        return data['aulas'];
      } else {
        throw Exception('Key "aulas" not found or is null');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  eliminarAula(String id) async {
    String url = '$_baseUrl/aulas/$id';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete data');
    }
  }

  //Asignar profesor a aula
  Future<Map<String, dynamic>> asignarProfesorAula(
      int idAula, int idUsuario) async {
    String url = '$_baseUrl/aulas/asignar-profesor';
    final Map<String, dynamic> data = {
      "id_aula": idAula,
      "id_usuario": idUsuario,
    };

    final String jsonBody = json.encode(data);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al asignar profesor al aula API');
    }
  }
}
