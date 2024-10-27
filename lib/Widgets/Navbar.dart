import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  
  final int colorPrincipal = 0xFF2EC4B6;

  final List<String> listElements;
  
  const Navbar({
    super.key,
    required this.listElements,
  });
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(colorPrincipal),
            ),
            child: const Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          for (var element in listElements)
            ListTile(
              title: Text(element),
              onTap: () {
                // Navegar a la página correspondiente
                Navigator.pushNamed(context, element);
              },
            ),
        ],
      ),
    );
  }

  
}