import 'package:flutter/material.dart';

class Header    extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onAccessibilityPressed;
  final VoidCallback onCalendarPressed;
  final VoidCallback onLogoutPressed;

  const Header   ({
    super.key,
    required this.title,
    required this.onAccessibilityPressed,
    required this.onCalendarPressed,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100, // Ajusta la altura del AppBar
      elevation: 4,
      shadowColor: Colors.black,
      title: Row(
        children: [
          // Imagen del usuario
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.account_circle, color: Colors.cyan,size: 60.0),
          ),
          const SizedBox(width: 10),
          // Título del AppBar
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(), // Empuja los íconos hacia la derecha
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5, // Mitad de la pantalla para íconos
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye uniformemente los íconos
              children: [
                IconButton(
                  icon: const Icon(Icons.accessibility_new_sharp, color: Colors.green, size: 40),
                  onPressed: onAccessibilityPressed,
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month, color: Colors.blue, size: 40),
                  onPressed: onCalendarPressed,
                ),
                IconButton(
                  icon: const Icon(Icons.list, color: Colors.orange, size: 40),
                  onPressed: onCalendarPressed,
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red, size: 40),
                  onPressed: onLogoutPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100); // Define el tamaño del AppBar
}
