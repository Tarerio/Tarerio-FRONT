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
      'Tareas', // Tareas
      Icon(Icons.task_alt_outlined),
      Icon(Icons.task_alt_rounded),
      '/administrador/tareas'), // ruta
  ExampleDestination(
      'Menús',
      Icon(Icons.restaurant_menu),
      Icon(Icons.restaurant_menu_outlined),
      '/administrador/menus'), // ruta
  ExampleDestination(
      'Aulas',
      Icon(Icons.class_),
      Icon(Icons.class_outlined),
      '/administrador/aulas'), // ruta
  ExampleDestination(
      'Profesores',
      Icon(Icons.person),
      Icon(Icons.person_outline),
      '/administrador/profesores'), // ruta
  ExampleDestination(
      'Alumnos',
      Icon(Icons.school),
      Icon(Icons.school_outlined),
      '/administrador/alumnos'), // ruta
  ExampleDestination(
      'Ajustes',
      Icon(Icons.settings),
      Icon(Icons.settings_outlined),
      '/administrador/perfil'), // ruta
];

class Navbar extends StatefulWidget {
  const Navbar({super.key, this.onLogout, required this.screenIndex});

  final VoidCallback? onLogout;
  final int screenIndex;

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
                // Actualiza el índice de la pantalla activa
                Navigator.pushReplacementNamed(
                    context, destination.route); // Reemplaza la página actual
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
                MaterialPageRoute(builder: (context) => Home()),
                    (Route<dynamic> route) => false, // elimina todas las rutas anteriores
              );
            },
          ),
        ],
      ),
    );
  }
}
