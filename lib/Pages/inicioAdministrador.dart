import 'package:flutter/material.dart';

class InicioAdministrador extends StatelessWidget {
  const InicioAdministrador({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
      ),
      body: Center(
        child: SizedBox(
          width: 350, // Establece un ancho fijo para el Card
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
            ),
            elevation: 10, // Elevación para la sombra
            shadowColor: Colors.black.withOpacity(0.2), // Color de la sombra
            margin: const EdgeInsets.all(20.0),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
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
                  const SizedBox(height: 10), // Espacio entre el label y el campo

                  // Input 'Usuario'
                  TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200], // Fondo gris claro
                      filled: true, // Activa el fondo
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                        borderSide: const BorderSide(
                          color: Colors.black12, // Borde suave
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados al enfocar
                        borderSide: const BorderSide(
                          color: Colors.black12, // Borde suave al enfocar
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30), // Espacio entre los campos

                  // Etiqueta 'Contraseña'
                  const Text(
                    'Contraseña',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2EC4B6), // Color personalizado del label
                    ),
                  ),
                  const SizedBox(height: 10), // Espacio entre el label y el campo

                  // Input 'Contraseña'
                  TextField(
                    obscureText: true, // Campo de contraseña
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200], // Fondo gris claro
                      filled: true, // Activa el fondo
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                        borderSide: const BorderSide(
                          color: Colors.black12, // Borde suave
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados al enfocar
                        borderSide: const BorderSide(
                          color: Colors.black12, // Borde suave al enfocar
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30), // Espacio entre el campo y el botón

                  // Botón de Inicio de Sesión
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2EC4B6), // Color de fondo del botón
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Tamaño del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bordes redondeados del botón
                        ),
                      ),
                      onPressed: () {
                        // Lógica de inicio de sesión
                      },
                      child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18.0)),
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
