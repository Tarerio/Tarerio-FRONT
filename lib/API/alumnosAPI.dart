import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';

class AlumnosAPI {
// A GET request to fetch all students from the system.
  Future<List<dynamic>> getAlumnos({int? aula}) async {
    String url = '$baseUrl/alumnos';
    if (aula != null) {
      url += '?aula=$aula';
    }
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

  // A GET request to fetch a student by its ID.
  Future<Map<String, dynamic>> getAlumnoById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/alumnos/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

// Una petición POST para ver si un usuario se encuentra en la tabla alumno.
  Future<Map<String, dynamic>> inicioSesionAlumno(
      String nickname, String patron) async {
    String url = '$baseUrl/alumnos/inicioSesionAlumno';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'nickname': nickname,
        'patron': patron,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> registrarAlumno(
      String nickname,
      String patron,
      bool texto,
      bool imagenes,
      bool pictograma,
      bool video,
      bool audio,
      String porDefecto,
      String image) async {
    const String url = '$baseUrl/alumnos/create';
    const String urlAccesibilidad = '$baseUrl/menuAccesible';

    var perfil = {
      'texto': texto,
      'imagenes': imagenes,
      'pictograma': pictograma,
      'video': video,
      'audio': audio,
      'porDefecto': porDefecto
    };

    final Map<String, dynamic> data = {
      'nickname': nickname,
      'patron': patron,
      'perfil': perfil,
      'image': image,
    };

    final String jsonBody = json.encode(data);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data2 = {
        'nickname': nickname,
        'texto_titulo': "MEDIANO",
        'texto_descripcion': "MEDIANO",
        'paleta_colores': "TARERIO"
      };

      final String jsonBody2 = json.encode(data2);

      final response2 = await http.post(
        Uri.parse(urlAccesibilidad),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody2,
      );

      return json.decode(response.body);
    } else {
      throw Exception('Failed to register student');
    }
  }

  Future<Map<String, dynamic>> editarAlumno(
      String nickname,
      String patron,
      bool texto,
      bool imagenes,
      bool pictograma,
      bool video,
      bool audio,
      String porDefecto,
      String image,
      int idAlumno) async {
    final String url = '$baseUrl/alumnos/$idAlumno';

    var perfil = {
      'texto': texto,
      'imagenes': imagenes,
      'pictograma': pictograma,
      'video': video,
      'audio': audio,
      'porDefecto': porDefecto
    };

    final Map<String, dynamic> data = {
      'nickname': nickname,
      'patron': patron,
      'perfil': perfil,
      'image': image,
    };

    final String jsonBody = json.encode(data);

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update student');
    }
  }

  Future<Map<String, dynamic>> crearModificarMenuAccesible(String nickname,
      String textoTitulo, String textoDescripcion, String paletaColores) async {
    const String urlCrear = '$baseUrl/menuAccesible';
    final String urlModificarObtener = '$baseUrl/menuAccesible/$nickname';

    // Primero se verifica si el menú accesible ya existe

    final response = await http.get(Uri.parse(urlModificarObtener));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = {
        'texto_titulo': textoTitulo,
        'texto_descripcion': textoDescripcion,
        'paleta_colores': paletaColores
      };

      final String jsonBody = json.encode(data);

      final response2 = await http.put(
        Uri.parse(urlModificarObtener),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      return json.decode(response2.body);
    } else {
      final Map<String, dynamic> data = {
        'nickname': nickname,
        'texto_titulo': textoTitulo,
        'texto_descripcion': textoDescripcion,
        'paleta_colores': paletaColores
      };

      final String jsonBody = json.encode(data);

      final response2 = await http.post(
        Uri.parse(urlCrear),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      return json.decode(response2.body);
    }
  }

  Future<Map<String, dynamic>> obtenerMenuAccesible(String nickname) async {
    final String url = '$baseUrl/menuAccesible/$nickname';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> obtenerAlumno(String nickname) async {
    final String url = '$baseUrl/alumnos/nickname/$nickname';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> getFilteredAlumnos(
      String? nickname, String? categoria) async {
    String url = '$baseUrl/alumnos/filtered';

    if (nickname != null && categoria != null) {
      url += '?categoria=$categoria&nickname=$nickname';
    } else if (nickname != null) {
      url += '?nickname=$nickname';
    } else if (categoria != null) {
      url += '?categoria=$categoria';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
<<<<<<< HEAD
=======

  eliminarAlumno(String id) async {
    String url = '$baseUrl/alumnos/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete data');
    }
  }

>>>>>>> develop
}
