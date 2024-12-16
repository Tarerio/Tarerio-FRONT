import 'package:flutter/material.dart';
import 'package:tarerio/Pages/home.dart';

class ExampleDestination {
  const ExampleDestination(
      this.label, this.icon, this.selectedIcon, this.route);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final String route;
}

const List<ExampleDestination> destinations = <ExampleDestination>[
  ExampleDestination(
      'Aulario', // Tareas
      Icon(Icons.class_),
      Icon(Icons.class_outlined),
      '/profesor/aulario'), // ruta
  ExampleDestination('Pedidos', Icon(Icons.question_mark),
      Icon(Icons.question_mark_outlined), '/profesor/pedidos'), // ruta
];

class Navbar extends StatefulWidget {
  const Navbar(
      {super.key,
      this.onLogout,
      required this.screenIndex,
      required this.nickname});

  final VoidCallback? onLogout;
  final int screenIndex;
  final String nickname;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ...destinations.asMap().entries.map((entry) {
            int index = entry.key;
            ExampleDestination destination = entry.value;
            bool isSelected =
                index == widget.screenIndex && widget.screenIndex != -1;

            return ListTile(
              leading: isSelected ? destination.selectedIcon : destination.icon,
              title: Text(
                destination.label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
              tileColor:
                  isSelected ? const Color(0xFF2EC4B6) : Colors.transparent,
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  destination.route,
                  arguments: widget.nickname, // Pasar el nickname
                );
              },
              contentPadding: const EdgeInsets.all(5.0),
            );
          }),
          const Divider(),
          const Spacer(),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
                (Route<dynamic> route) =>
                    false, // elimina todas las rutas anteriores
              );
            },
          ),
        ],
      ),
    );
  }
}
