
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/TextFieldDefault.dart';

import '../API/profesoresAPI.dart';
import '../Widgets/ErrorModal.dart';
import '../Widgets/SuccessModal.dart';

class EditarContraseniaProfesor extends StatefulWidget {
  const EditarContraseniaProfesor({Key? key}) : super(key: key);

  @override
  _EditarContraseniaProfesorState createState() => _EditarContraseniaProfesorState();
}

class _EditarContraseniaProfesorState extends State<EditarContraseniaProfesor> {
  final _formKey = GlobalKey<FormState>();
  final _contraseniaActualController = TextEditingController();
  final _contraseniaNuevaController = TextEditingController();
  final ProfesoresAPI profesoresAPI = ProfesoresAPI();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _contraseniaActualController.dispose();
    _contraseniaNuevaController.dispose();
    super.dispose();
  }

  Future<void> _cambiarContrasenia(int id) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await profesoresAPI.cambiarContraseniaProfesor(
        id,
        _contraseniaActualController.text,
        _contraseniaNuevaController.text,
      );
      // Si la contraseña se cambió con éxito, mostrar un mensaje o redirigir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contraseña cambiada exitosamente'),
          backgroundColor: Colors.green, // Cambia el color de fondo del mensaje
          duration: Duration(seconds: 2), // Duración del SnackBar
        ),
      );
      Navigator.pop(context); // Regresa a la pantalla anterior
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int idUsuario = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFieldDefault(
                  label: "Contraseña actual",
                  controller: _contraseniaActualController,
                  labelColor: Color(0xFF2EC4B6),
                  padding: const EdgeInsets.only(top: 10.0)
              ),
              const SizedBox(height: 16.0),
              TextFieldDefault(
                label: "Nueva Contraseña",
                controller: _contraseniaNuevaController,
                labelColor: Color(0xFF2EC4B6),
                padding: const EdgeInsets.only(top: 10.0)
              ),
              const SizedBox(height: 24.0),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _cambiarContrasenia(idUsuario);
                      }
                    },
                    //Establecer color de fondo del botón Color(0xFF2EC4B6)
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2EC4B6)),
                    child: const Text('Cambiar Contraseña', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                  ),
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}