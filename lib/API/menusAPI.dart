import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarerio/consts.dart';

// API de Menu
class MenusAPI {
  Future<Map<String, dynamic>?> crearMenu(
      String tipo,
      String contenido,
      String imagen) async {
    String url = '$baseUrl/menu/create';

    final Map<String, dynamic> body = {
      "tipo": tipo,
      "contenido": contenido,
      "imagenBase64" : imagen,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        throw Exception('Solicitud incorrecta: ${response.body}');
      } else {
        throw Exception('Error inesperado: ${response.body}');
      }
    } catch (e) {
      print("Error en crearMenu: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> obtenerMenus() async {
    String url = '$baseUrl/menu';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((menu) => menu as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load menus');
    }
  }

  Future<List> obtenerMenuById(int id) async{
    String url = '$baseUrl/menu/$id';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load menus');
    }
  }

  Future<Map<String, dynamic>> modificarMenu(int id, String tipo, String contenido, String imagen) async{
    String url = '$baseUrl/menu/$id';

    final Map<String, dynamic> body = {
      "tipo": tipo,
      "contenido": contenido,
      "imagenBase64" : imagen,
    };

    final response = await http.put(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  eliminarMenu(int id) async {
    String url = '$baseUrl/menu/$id';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception(response.body);
    }
  }

}