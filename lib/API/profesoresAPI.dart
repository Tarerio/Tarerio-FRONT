import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';

// API de Profesores
class ProfesoresAPI {
  //Método para registrar un profesor
  Future<Map<String, dynamic>> registrarProfesor(
      String nickname, String patron, String image) async {
    String url = '$baseUrl/profesores/crear';

    final Map<String, dynamic> data = {
      'nickname': nickname,
      'patron': patron,
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

    return json.decode(response.body);
  }

  Future<List<dynamic>> filtrarProfesor(String nickname) async {
    String url = '$baseUrl/profesores/filtered?nickname=$nickname';

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
      throw Exception('Failed to filter profesor');
    }
  }

  /// Método para obtener todos los profesores
  Future<List<dynamic>> obtenerProfesores() async {
    String url = '$baseUrl/profesores';

    // Realizar la solicitud GET
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Decodificar la respuesta JSON
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['usuarios']; // Retorna la lista de profesores
    } else {
      throw Exception('Failed to load data');
    }
  }

  cambiarContraseniaProfesor(
      int id, String contraseniaActual, String contraseniaNueva) async {
    String url = '$baseUrl/profesores/$id/cambiarContrasenia';

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

   eliminarProfesor(String idProfesor) async {
    String url = '$baseUrl/profesores/$idProfesor';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete data');
    }
  }

  Future<Map<String, dynamic>> obtenerAulaYAlumnos(String nickname) async {
    final response = await http.get(Uri.parse('$baseUrl/profesores/aulario/obtener/$nickname'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener datos del aula y alumnos');
    }
  }

  //profesores/pedidoMaterial/obtener/{nickname}
  Future<Map<String, dynamic>> obtenerPedidos(String nickname) async {
    final response = await http.get(Uri.parse('$baseUrl/profesores/pedidoMaterial/obtener/$nickname'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener pedidos de material');
    }
  }

  Future<Map<String, dynamic>> crearPedidoMaterial(String nickname, List<Map<String, dynamic>> materiales) async {
    final Map<String, dynamic> data = {
      'nickname': nickname,
      'materiales': materiales,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/profesores/pedidoMaterial/crear'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear pedido de material');
    }
  }

  Future<Map<String, dynamic>> marcarPedidoRecibido(int idPedido) async {
    final response = await http.put(Uri.parse('$baseUrl/profesores/pedidoMaterial/marcarPedido/$idPedido'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al marcar pedido como recibido');
    }
  }
}
