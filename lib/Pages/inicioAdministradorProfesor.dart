import 'package:flutter/material.dart';
import 'package:tarerio/API/inicioSesionAPI.dart';
import 'package:tarerio/Pages/principalAdministrador.dart';

import '../Widgets/AppBarDefault.dart';
import '../consts.dart';

class InicioAdministrador extends StatelessWidget {
  InicioAdministrador({super.key});

  final InicioSesionAPI _api = InicioSesionAPI();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  void _showErrorModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.error, size: 50, color: Colors.red),
          title: Text(title,
              style: const TextStyle(fontSize: 30, color: Colors.red)),
          content: Text(content, style: const TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('De acuerdo', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  Future<String> _testAdmin(BuildContext context) async {
    try {
      var jsonResponse = await _api.inicioSesionAdministrador(
          usuarioController.text, contrasenaController.text);
      return jsonResponse['administrador']['nickname'];
    } catch (e) {
      print('Request failed with error: $e');
      return '';
    }
  }

  Future<String> _testProfesor(BuildContext context) async {
    try {
      var jsonResponse = await _api.inicioSesionProfesor(
          usuarioController.text, contrasenaController.text);
      return jsonResponse['profesor']['nickname'];
    } catch (e) {
      print('Request failed with error: $e');
      return '';
    }
  }

  void _inicioSesionAdminProfesor(BuildContext context) async {
    // Primero verificar si es un administrador
    String admin = await _testAdmin(context);
    String profesor = await _testProfesor(context);

    //Si los campos vacíos
    if (usuarioController.text.isEmpty || contrasenaController.text.isEmpty) {
      _showErrorModal(context, 'Error al iniciar sesión',
          'Por favor, llena todos los campos.');
    } else if (admin != '') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PrincipalAdministrador()),
      );
    } else if (profesor != '') {
      print('Profesor');
    } else {
      _showErrorModal(context, 'Error al iniciar sesión',
          'Usuario o contraseña incorrectos.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
      title: 'Inicio de sesión',
      titleColor: Color(colorPrincipal),
      iconColor: Color(colorPrincipal),
    ),
      body: Center(
        child: SizedBox(
          width: 350, // Establece un ancho fijo para el Card
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
            ),
            elevation: 15,
            // Elevación para la sombra
            shadowColor: Colors.black.withOpacity(0.6),
            // Color de la sombra
            margin: const EdgeInsets.all(20.0),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                // Alinear a la izquierda
                children: <Widget>[
                  // Etiqueta 'Usuario'
                  const Text(
                    'Usuario',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2EC4B6), // Color personalizado del label
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Espacio entre el label y el campo

                  // Input 'Usuario'
                  TextField(
                    controller: usuarioController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      // Fondo gris claro
                      filled: true,
                      // Activa el fondo
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        // Bordes redondeados
                        borderSide: const BorderSide(
                          color: Colors.black12, // Borde suave
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        // Bordes redondeados al enfocar
                        borderSide: const BorderSide(
                          color: Colors.black12, // Borde suave al enfocar
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  // Espacio entre los campos

                  // Etiqueta 'Contraseña'
                  const Text(
                    'Contraseña',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2EC4B6), // Color personalizado del label
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Espacio entre el label y el campo

                  // Input 'Contraseña'
                  TextField(
                    controller: contrasenaController,
                    obscureText: true, // Campo de contraseña
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      // Fondo gris claro
                      filled: true,
                      // Activa el fondo
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        // Bordes redondeados
                        borderSide: const BorderSide(
                          color: Colors.black12, // Borde suave
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        // Bordes redondeados al enfocar
                        borderSide: const BorderSide(
                          color: Colors.black12, // Borde suave al enfocar
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  // Espacio entre el campo y el botón

                  // Botón de Inicio de Sesión
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2EC4B6),
                        // Color de fondo del botón
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        // Tamaño del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Bordes redondeados del botón
                        ),
                      ),
                      onPressed: () {
                        _inicioSesionAdminProfesor(context);
                      },
                      child: const Text('Iniciar Sesión',
                          style: TextStyle(fontSize: 18.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
