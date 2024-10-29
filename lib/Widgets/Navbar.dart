import 'package:flutter/material.dart';

class ExampleDestination {
  const ExampleDestination(this.label, this.icon, this.selectedIcon, this.route);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final String route;
}

const List<ExampleDestination> destinations = <ExampleDestination>[
  ExampleDestination('Tareas', Icon(Icons.task_alt_outlined), Icon(Icons.task_alt_rounded), ''),
  ExampleDestination('Menús', Icon(Icons.restaurant_menu), Icon(Icons.restaurant_menu_outlined), ''),
  ExampleDestination('Aulas', Icon(Icons.class_), Icon(Icons.class_outlined), '/administrador/registrarAula'),
  ExampleDestination('Educadores', Icon(Icons.person), Icon(Icons.person_outline),'/administrador/registrarProfesor' ),
  ExampleDestination('Alumnos', Icon(Icons.school), Icon(Icons.school_outlined), '/administrador/registrarAlumno'),
  ExampleDestination('Ajustes', Icon(Icons.settings), Icon(Icons.settings), '/administrador/perfil'),

];

class Navbar extends StatefulWidget {
  const Navbar({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ...destinations.asMap().entries.map((entry) {
            int index = entry.key;
            ExampleDestination destination = entry.value;
            bool isSelected = index == screenIndex;

            return ListTile(
              leading: isSelected ? destination.selectedIcon : destination.icon,
              title: Text(
                destination.label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
              tileColor: isSelected ? const Color(0xFF2EC4B6) : Colors.transparent,
              onTap: () =>  Navigator.pushNamed(context, destination.route),
              contentPadding: const EdgeInsets.all(5.0),
            );
          }),
          const Divider(),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: widget.onLogout,
          ),
        ],
      ),
    );
  }
}
