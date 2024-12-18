import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/Navbar.dart';
import 'package:tarerio/consts.dart';
import 'package:tarerio/Widgets/Cards/MenuCard.dart';
import 'package:tarerio/API/menusAPI.dart';
import 'package:tarerio/Pages/Menus/crearMenu.dart';

import 'modificarMenu.dart';

class MenusPage extends StatefulWidget {
  MenusPage({super.key});

  @override
  _MenusPageState createState() => _MenusPageState();
}

class _MenusPageState extends State<MenusPage> {
  List<dynamic> menus = [];
  bool isLoadingMenus = true;

  final MenusAPI _api = MenusAPI();

  String? tipoMenuSeleccionado;
  final TextEditingController nombreTareaController = TextEditingController();

  // No pinta ni con cola esto aqu
  final Map<String, String> categorias = {
    'Tareas de Juegos': TAREA_JUEGO,
    'Tareas Por Pasos': TAREA_POR_PASOS,
    'Tareas de Petición': TAREA_PETICION,
  };


  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    try {
      final response = await _api.obtenerMenus();
      setState(() {
        menus = response;
        isLoadingMenus = false;
      });
    } catch (e) {
      print("Error al obtener menús: $e");
      setState(() {
        isLoadingMenus = false;
      });
    }
  }

  // TO DO
  Future<void> _filterMenus({String? nombreTarea, String? tipoTarea}) async {
    /*try {
      setState(() {
        isLoading = true; // Mostrar indicador de carga
      });

      List<Map<String, dynamic>>? tareasPorPasos = [];
      List<Map<String, dynamic>>? tareasPeticion = [];
      List<Map<String, dynamic>>? tareasJuego = [];

      print(nombreTarea);

      if (tipoTarea != null) {
        switch (tipoTarea) {
          case TAREA_POR_PASOS:
            tareasPorPasos = await _porPasosAPI.getFilteredTareas(nombreTarea: nombreTarea);
            break;

          case TAREA_PETICION:
            tareasPeticion = await _peticionAPI.getFilteredTareas(nombreTarea: nombreTarea);
            break;

          case TAREA_JUEGO:
            tareasJuego = await _juegoAPI.getFilteredTareas(nombreTarea: nombreTarea);
            break;
        }
      } else{
        tareasPorPasos = await _porPasosAPI.getFilteredTareas(nombreTarea: nombreTarea);
        tareasPeticion = await _peticionAPI.getFilteredTareas(nombreTarea: nombreTarea);
        tareasJuego = await _juegoAPI.getFilteredTareas(nombreTarea: nombreTarea);
      }

      setState(() {
        Tareas = [
          ...?tareasPorPasos?.map((tarea) => {'tipo': TAREA_POR_PASOS, ...tarea}),
          ...?tareasPeticion?.map((tarea) => {'tipo': TAREA_PETICION, ...tarea}),
          ...?tareasJuego?.map((tarea) => {'tipo': TAREA_JUEGO, ...tarea}),
        ];
        isLoading = false; // Oculta indicador de carga
      });

    } catch (e) {
      print("Error al obtener tareas: $e");
      setState(() {
        isLoading = false; // Oculta indicador de carga en caso de error
      });
    }*/
  }

  void _showErrorModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorModal(title: title, content: content);
      },
    );
  }

  void _showSuccessModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessModal(title: title, content: content);
      },
    );
  }

  void _confirmarEliminacion(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content:
          const Text('¿Estás seguro de que deseas eliminar este Menú?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {

                await _borrarMenu(id);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MenusPage()));
                _showSuccessModal(context, 'Menú eliminado',
                    'El menú ha sido eliminado exitosamente');
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _borrarMenu(int id) async{
     try {
          await _api.eliminarMenu(id);
          setState(() {
            menus.removeWhere((menu) => menu['id'] == id); // Filtrar el menú eliminado
          });
     } catch (e) {
          _showErrorModal(context, 'Error al eliminar',
              'No ha sido posible eliminar el menú');
     }
  }

  void _cleanFiltros(){
    setState(() {
      tipoMenuSeleccionado = null;
      nombreTareaController.text = '';
      fetchMenus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menús',
            style: TextStyle(
                color: const Color(0xFF2EC4B6),
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.refresh_sharp,
                    color: Color(colorPrincipal),
                  ),
                  onPressed: () {
                    _cleanFiltros();
                  },
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  alignment: Alignment.center,
                  hint: const Text('Filtrar por categoria'),
                  value: tipoMenuSeleccionado,
                  items: categorias.entries.map((tiposMenu) {
                    return DropdownMenuItem<String>(
                      value: tiposMenu.value,
                      alignment: Alignment.center,
                      child: Text(tiposMenu.key),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      tipoMenuSeleccionado = newValue;
                      _filterMenus(tipoTarea: tipoMenuSeleccionado, nombreTarea: nombreTareaController.text);
                    });
                  },
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  underline: SizedBox.shrink(),
                  iconEnabledColor: Color(colorPrincipal),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 213,
                  child: TextField(
                    controller: nombreTareaController,
                    decoration: InputDecoration(
                      labelText: 'Buscar por nombre',
                      labelStyle: TextStyle(color: Color(colorPrincipal)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(colorPrincipal)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(colorPrincipal), width: 2.0),
                      ),
                      suffixIcon: Icon(Icons.search, color: Color(colorPrincipal)),
                    ),
                    onChanged: (value) async {
                      await _filterMenus(nombreTarea: value, tipoTarea: tipoMenuSeleccionado);
                      setState(() {
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
      body: menus.isEmpty
                ? const Center(child: Text(
            'No hay menús creados',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: menus.map((menu) {
            return SizedBox(
              width: MediaQuery.of(context).size.width > 800 ? 200 : 150,
              child: MenuCard(
                idMenu: menu['id_menu'],
                tipoMenu: menu['tipo'],
                contenidoMenu: menu['contenido'],
                imagenMenu: menu['imagenBase64'] ?? '',
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModificarMenu(menuId: menu['id_menu'], tipoMenu: menu['tipo'], contenidoMenu: menu['contenido'], imagenMenu: menu['imagenBase64'],),
                    ),
                  );
                },
                onDelete: () {
                  _confirmarEliminacion(menu['id_menu']);
                },
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearMenu()),
                );
              },
              backgroundColor: const Color(0xFF2EC4B6),
              child: const Icon(Icons.add_shopping_cart),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearMenu()),
                );
              },
              backgroundColor: const Color(0xFF2EC4B6),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      drawer: Navbar(
        screenIndex: 1,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }
}
