import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';

// API de Aulas
class AulasAPI {
  // Añadir imagen y funcionalidad extra para asignar alumnos
  Future<Map<String, dynamic>> crearAula(String clave, String cupo, String imagenBase64) async {
    String url = '$baseUrl/aulas/create';

    final Map<String, dynamic> data = {
      "clave": clave,
      "capacidad": cupo,
      "image": imagenBase64,
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
  
  Future<List<dynamic>> filteredObtenerAulas(String claveAula) async {
    String url = '$baseUrl/aulas/filtered?claveAula=$claveAula';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    }else{
      throw Exception('Failed to filter classrooms');
    }
  }
  
  Future<Map<String, dynamic>> modificarAula(String id, String clave, String cupo, String imagenBase64) async {
    String url = '$baseUrl/aulas/$id';

    final Map<String, dynamic> data = {
      "clave": clave,
      "capacidad": cupo,
      "image": imagenBase64,
    };

    final String jsonBody = json.encode(data);

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );
    return json.decode(response.body);
  }
  
  eliminarAula(String id) async {
    String url = '$baseUrl/aulas/$id';

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
    String url = '$baseUrl/aulas/asignar-profesor';
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
      throw Exception('Error al asignar profesor al aula');
    }
  }

  Future<Map<String, dynamic>> obtenerProfesoresAsignados(int idAula) async {
    String url = '$baseUrl/aulas/$idAula/profesores';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al recuperar los profesores asignados al aula');
    }
  }

  Future<Map<String, dynamic>> desasignarProfesor(
      int idAula, int idProfesor) async {
    String url = '$baseUrl/aulas/desasignar-profesor';

    final Map<String, dynamic> data = {
      "id_aula": idAula,
      "id_profesor": idProfesor,
    };

    final jsonBody = json.encode(data);

    try {
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
        return {
          "status": "error",
          "message": "Error en la desasignación: ${response.statusCode}",
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Error de conexión: $e",
      };
    }
  }

  asignarAlumnoAula(int idAula, int idUsuario) async {
    String url = '$baseUrl/aulas/asignar-alumno';
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
      return;
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  eliminarAlumnoAula(int idUsuario) async {
    String url = '$baseUrl/aulas/desasignar-alumno';
    final Map<String, dynamic> data = {
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
      return;
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
