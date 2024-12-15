import 'package:flutter/material.dart';
import 'package:tarerio/Models/menuAccesible.dart';
import 'package:tarerio/Widgets/Header.dart';

class FinalizarTareaPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        nickname: nickname,
        colorPalette: colorPalette,
        titleFontSize: titleFontSize,
        textFontSize: textFontSize,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: colorPalette.componentes,
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Image.asset('assets/images/tareaCompletada.png',
                  width: 300, height: 300),
            ),
            const SizedBox(height: 50),
            Text(
              "¡Has completado todos los pasos!".toUpperCase(),
              style: TextStyle(
                  fontSize: textFontSize,
                  color: colorPalette.fuente,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
