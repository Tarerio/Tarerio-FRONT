import 'package:flutter/material.dart';
import '../home.dart';
import '../../Widgets/Navbar.dart';

class PrincipalAdministrador extends StatelessWidget {
  const PrincipalAdministrador({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            iconSize: 30,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/tarerio.png'),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Bienvenido, Administrador!',
          style: TextStyle(fontSize: 40),
        ),
      ),
      drawer: Navbar(
        screenIndex: -1,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }
}
