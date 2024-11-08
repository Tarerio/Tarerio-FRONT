import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/Navbar.dart';
//import 'package:tarerio/Widgets/MenuCard.dart';
//import 'package:tarerio/API/menusAPI.dart';

class MenusPage extends StatefulWidget {
  MenusPage({super.key});

  @override
  _MenusPageState createState() => _MenusPageState();
}

class _MenusPageState extends State<MenusPage> {
  List<dynamic> menus = [];
  bool isLoadingMenus = true;


  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    try {
      isLoadingMenus = false; // borrar
      /*
      MenusAPI _api = MenusAPI();
      final response = await _api.obtenerMenus();
      setState(() {
        menus = response;
        isLoadingMenus = false;
      });
       */
    } catch (e) {
      print("Error al obtener menús: $e");
      setState(() {
        isLoadingMenus = false;
      });
    }
  }

  void _confirmarEliminacion(String id) {
    // Muestra un cuadro de diálogo para confirmar la eliminación de un menú
  }

  Future<void> _borrarMenu(String id) async {
    // Método para borrar un menú usando la API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menús',
          style: TextStyle(
            color: Color(0xFF2EC4B6),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoadingMenus
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: menus.map((menu) {
            return SizedBox(
              width: MediaQuery.of(context).size.width > 800 ? 200 : 150,
              /*child: MenuCard(
                idMenu: menu['id_menu'],
                nombreMenu: menu['nombre'],
                imagenMenu: menu['imagenBase64'] ?? '',
                onEdit: () {
                  // Lógica para editar menú
                },
                onAssign: () {
                  // Lógica para asignar algún recurso al menú
                },
                onDelete: () {
                  _confirmarEliminacion(menu['id_menu'].toString());
                },
              ),*/
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegación para crear un nuevo menú
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2EC4B6),
      ),
      drawer: Navbar(
        screenIndex: 1,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }

  void _mostrarDialogRecursos(BuildContext context, int idMenu) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seleccionar Recurso'),
          content: isLoadingMenus
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: 0,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 192, 184, 184),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text('Recurso $index'), // Muestra el nombre del recurso
                    onTap: () {
                      // Lógica para asignar recurso al menú
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
