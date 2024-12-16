import 'package:flutter/material.dart';
import 'package:tarerio/Pages/Alumnos/finalizarTarea.dart';
import 'package:tarerio/Widgets/Header.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/API/alumnosAPI.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';

class TareaAlumnoPeticion extends StatefulWidget {
  final String nickname;
  final ColorPalette colorPalette;
  final double titleFontSize;
  final double textFontSize;
  final int idTarea;

  const TareaAlumnoPeticion({
    super.key,
    required this.nickname,
    required this.colorPalette,
    required this.titleFontSize,
    required this.textFontSize,
    required this.idTarea,
  });
  @override
  // ignore: library_private_types_in_public_api
  _TareaAlumno createState() => _TareaAlumno();
}

class _TareaAlumno extends State<TareaAlumnoPeticion> {
  final AlumnosAPI _api = AlumnosAPI();
  final TareaPeticionAPI _tareaPeticionAPI = TareaPeticionAPI();

  int pasoActual = 0; // Paso actual de la tarea
  List<dynamic> enunciados = [];

  @override
  void initState() {
    super.initState();
    cargarEnunciadosTarea();
  }

  void cargarEnunciadosTarea() async {
    try {
      Map<String, dynamic> infoTarea =
          await _tareaPeticionAPI.obtenerTareaByID(widget.idTarea);
      setState(() {
        enunciados = List.from(infoTarea['Enunciados'].reversed.toList());
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    // Simulación de pasos de la tarea
  }

  void cambiarPaso(int incremento) {
    setState(() {
      final nuevoPaso = pasoActual + incremento;
      if (nuevoPaso >= 0 && nuevoPaso < enunciados.length) {
        pasoActual = nuevoPaso;
      } else if (nuevoPaso == enunciados.length) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinalizarTareaPage(
              nickname: widget.nickname,
              colorPalette: widget.colorPalette,
              titleFontSize: widget.titleFontSize,
              textFontSize: widget.textFontSize,
            ),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        nickname: widget.nickname,
        colorPalette: widget.colorPalette,
        titleFontSize: widget.titleFontSize,
        textFontSize: widget.textFontSize,
      ),
      body: enunciados.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new,
                          color: widget.colorPalette.componentes, size: 90),
                      onPressed: () => cambiarPaso(-1), // Retroceder paso
                    ),
                    Expanded(
                      child:
                          Center(child: Text(enunciados[pasoActual]['Texto'])),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios,
                          color: widget.colorPalette.componentes, size: 90),
                      onPressed: () => cambiarPaso(1), // Avanzar paso
                    ),
                  ],
                ))
              ],
            ),
    );
  }
}
