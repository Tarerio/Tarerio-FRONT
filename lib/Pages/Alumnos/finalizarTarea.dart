import 'package:flutter/material.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/Pages/Alumnos/principalAlumno.dart';
import 'package:tarerio/Widgets/Header.dart';
import 'package:confetti/confetti.dart';

class FinalizarTareaPage extends StatefulWidget {
  final String nickname;
  final ColorPalette colorPalette;
  final double titleFontSize;
  final double textFontSize;

  const FinalizarTareaPage({
    super.key,
    required this.nickname,
    required this.colorPalette,
    required this.titleFontSize,
    required this.textFontSize,
  });

  @override
  _FinalizarTareaPageState createState() => _FinalizarTareaPageState();
}

class _FinalizarTareaPageState extends State<FinalizarTareaPage> {
  late ConfettiController controller;

  @override
  void initState() {
    super.initState();
    controller = ConfettiController(); 
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: Header(
            nickname: widget.nickname,
            colorPalette: widget.colorPalette,
            titleFontSize: widget.titleFontSize,
            textFontSize: widget.textFontSize,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Reproducir el confeti
                    controller.play();

                    // Esperar 3 segundos antes de redirigir
                    Future.delayed(const Duration(seconds: 5), () {
                      // Detener el confeti y navegar a la página siguiente
                      controller.stop();
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrincipalAlumno(nickname: widget.nickname),
                        ),
                      );
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: widget.colorPalette.componentes,
                    elevation: 0,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Image.asset('assets/images/tareaCompletada.png',
                      width: 300, height: 300),
                ),
                const SizedBox(height: 50),
                Text(
                  "!Enhorabuena ${widget.nickname}!\nHas completado todos los pasos".toUpperCase(),
                  style: TextStyle(
                      fontSize: widget.titleFontSize,
                      color: widget.colorPalette.fuente,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: controller,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          numberOfParticles: 30,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange],
        ),
      ],
    );
  }
}
