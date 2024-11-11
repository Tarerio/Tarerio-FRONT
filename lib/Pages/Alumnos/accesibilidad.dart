import 'package:flutter/material.dart';

class AccesibilidadPage extends StatelessWidget {
  final String nickname;

  const AccesibilidadPage({Key? key, required this.nickname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú de accesibilidad', style: TextStyle(color: const Color(0xFF2EC4B6), fontSize: 24, fontWeight: FontWeight.bold)),

      ),
      body: Center(
        child: Text('Página de accesibilidad para $nickname'),
      ),
    );
  }
}