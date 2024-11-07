import 'package:flutter/material.dart';
import '../home.dart'; //

import '../../Widgets/Header.dart';

class PrincipalAlumno extends StatelessWidget {
  final String nickname;

  const PrincipalAlumno({super.key, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: nickname , onAccessibilityPressed: () => {}, onCalendarPressed: () => {} , onLogoutPressed: () => {}),
      body: Center(
        child: Text(
          'Bienvenido, $nickname!',
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}