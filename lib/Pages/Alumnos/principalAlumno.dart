import 'package:flutter/material.dart';
import '../home.dart'; //
import '../../Widgets/Header.dart';

class PrincipalAlumno extends StatelessWidget {
  final String nickname;

  const PrincipalAlumno({super.key, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(nickname: nickname),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Este es un título',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorCircle(Colors.blue, 'Primario'),
                _buildColorCircle(Colors.green, 'Secundario'),
                _buildColorCircle(Colors.orange, 'Componentes'),
                _buildColorCircle(Colors.black, 'Texto'),
                _buildColorCircle(Colors.grey, 'Fondo'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color color, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
        ),
        const SizedBox(height: 10),
        Text(label),
      ],
    );
  }
}