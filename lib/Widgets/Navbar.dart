import 'package:flutter/material.dart';

class ExampleDestination {
  const ExampleDestination(
      this.label, this.icon, this.selectedIcon, this.route);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final String route;
}

const List<ExampleDestination> destinations = <ExampleDestination>[
  ExampleDestination('Tareas', Icon(Icons.task_alt_outlined),
      Icon(Icons.task_alt_rounded), '/administrador/tareas'), // Asigna rutas válidas
  ExampleDestination('Menús', Icon(Icons.restaurant_menu),
      Icon(Icons.restaurant_menu_outlined), '/menus'), // Asigna rutas válidas
  ExampleDestination('Aulas', Icon(Icons.class_), Icon(Icons.class_outlined),
      '/administrador/aulas'),
  ExampleDestination('Educadores', Icon(Icons.person),
      Icon(Icons.person_outline), '/administrador/registrarProfesor'),
  ExampleDestination('Alumnos', Icon(Icons.school), Icon(Icons.school_outlined),
      '/administrador/registrarAlumno'),
  ExampleDestination('Ajustes', Icon(Icons.settings), Icon(Icons.settings),
      '/administrador/perfil'),
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
            bool isSelected = index == widget.screenIndex;

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
              onTap: () { // Actualiza el índice de la pantalla activa
                Navigator.pushReplacementNamed(context, destination.route); // Reemplaza la página actual
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
              widget.onLogout?.call(); // Llama a la función de cierre de sesión
              Navigator.pushReplacementNamed(context, '/home'); // Cambia '/home' por la ruta de tu página de inicio
            },
          ),
        ],
      ),
    );
  }
}
