import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/Widgets/TextFieldDefault.dart';

import '../../API/profesoresAPI.dart';
import '../../Widgets/AppBarDefault.dart';
import '../../Widgets/ErrorModal.dart';
import '../../Widgets/SuccessModal.dart';
import '../../consts.dart';

class EditarContraseniaProfesor extends StatefulWidget {
  const EditarContraseniaProfesor({Key? key}) : super(key: key);

  @override
  _EditarContraseniaProfesorState createState() =>
      _EditarContraseniaProfesorState();
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
      /*ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contraseña cambiada exitosamente'),
          backgroundColor: Colors.green, // Cambia el color de fondo del mensaje
          duration: Duration(seconds: 2), // Duración del SnackBar
        ),
      );*/
      setState(() {
        _showSuccessModal(context, "Exito", "Contraseña cambiada exitosamente");
      });
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context);
      });
      //Navigator.pop(context); // Regresa a la pantalla anterior
    } catch (e) {
      setState(() {
        //_errorMessage = e.toString();
        _showErrorModal(context, "ERROR", e.toString());
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorModal(title: title, content: content);
      },
    );
  }

  void _showSuccessModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessModal(title: title, content: content);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int idUsuario = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBarDefault(
        title: 'Editar contraseña educador',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFieldDefault(
                label: "Contraseña actual",
                controller: _contraseniaActualController,
                labelColor: Color(0xFF2EC4B6),
                padding: const EdgeInsets.only(top: 10.0),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextFieldDefault(
                label: "Nueva Contraseña",
                controller: _contraseniaNuevaController,
                labelColor: Color(0xFF2EC4B6),
                padding: const EdgeInsets.only(top: 10.0),
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 8.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _isLoading
                    ? CircularProgressIndicator()
                    : DefaultButton(
                        text: "Cambiar Contraseña",
                        onPressed: () {
                          _cambiarContrasenia(idUsuario);
                        },
                        color: Color(0xFF2EC4B6),
                        width: 400,
                      ),
                /*: ElevatedButton(
                    onPressed: () {
                      _cambiarContrasenia(idUsuario);
                    },
                    //Establecer color de fondo del botón Color(0xFF2EC4B6)
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2EC4B6)),
                    child: const Text('Cambiar Contraseña', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                  ),*/
              ])
            ],
          ),
        ),
      ),
    );
  }
}
