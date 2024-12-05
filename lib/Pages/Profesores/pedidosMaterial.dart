import 'package:flutter/material.dart';
import 'package:tarerio/API/profesoresAPI.dart';
import 'package:tarerio/Widgets/NavBarProfesor.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/Widgets/TextFieldDefault.dart';

class PedidosPage extends StatefulWidget {
  final String nickname;

  const PedidosPage({super.key, required this.nickname});

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  List<dynamic> pedidos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPedidos();
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

  Future<void> fetchPedidos() async {
    try {
      ProfesoresAPI api = ProfesoresAPI();
      final response = await api.obtenerPedidos(widget.nickname);
      final List<dynamic> allPedidos = response['pedidos'] ?? [];
      final DateTime now = DateTime.now();
      final DateTime sevenDaysBefore = now.subtract(Duration(days: 7));
      final DateTime sevenDaysAfter = now.add(Duration(days: 7));

      setState(() {
        pedidos = allPedidos.where((pedido) {
          final DateTime fechaPedido = DateTime.parse(pedido['fecha_pedido']);
          return fechaPedido.isAfter(sevenDaysBefore) &&
              fechaPedido.isBefore(sevenDaysAfter);
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error al obtener pedidos: $e");
      setState(() {
        isLoading = false;
      });
      _showErrorModal(context, "Error", "Error al obtener pedidos de material");
    }
  }

  void _mostrarModalCrearPedido(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CrearPedidoModal(
          nickname: widget.nickname,
          onPedidoCreado: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PedidosPage(nickname: widget.nickname),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pedidos de Material',
          style: TextStyle(
            color: Color(0xFF2EC4B6),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pedidos.isEmpty
          ? const Center(
        child: Text(
          'No hay peticiones de material',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView.builder(
          itemCount: pedidos.length,
          itemBuilder: (context, index) {
            final pedido = pedidos[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 300, vertical: 10),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pedido con fecha: ${pedido['fecha_pedido'].substring(0, 10)} y hora: ${pedido['fecha_pedido'].substring(11, 19)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: pedido['estado'] == 'Pendiente'
                            ? Colors.orange
                            : Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        pedido['estado'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    Text(
                      'Materiales:',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    ...pedido['materiales'].map<Widget>((material) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(material['nombre']),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                child: const Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                            ),
                            Text(material['cantidad'].toString()),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
                onTap: () {
                  // Handle tap on pedido
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarModalCrearPedido(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2EC4B6),
      ),
      drawer: Navbar(
        screenIndex: 1,
        nickname: widget.nickname,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }
}
class CrearPedidoModal extends StatefulWidget {
  final String nickname;
  final VoidCallback onPedidoCreado;

  const CrearPedidoModal({
    Key? key,
    required this.nickname,
    required this.onPedidoCreado,
  }) : super(key: key);

  @override
  _CrearPedidoModalState createState() => _CrearPedidoModalState();
}

class _CrearPedidoModalState extends State<CrearPedidoModal> {
  final List<Map<String, dynamic>> materiales = [];
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();

  void _addMaterial() {
    setState(() {
      materiales.add({
        'nombre': nombreController.text,
        'cantidad': int.parse(cantidadController.text),
      });
      nombreController.clear();
      cantidadController.clear();
    });
  }

  Future<void> _crearPedido() async {
    try {
      ProfesoresAPI api = ProfesoresAPI();
      await api.crearPedidoMaterial(widget.nickname, materiales);
      widget.onPedidoCreado();
    } catch (e) {
      print("Error al crear pedido: $e");
      _showErrorModal(context, "Error", "Error al crear pedido de material");
    }
  }

  void _showErrorModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorModal(title: title, content: content);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Pedido de Material', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldDefault(
              label: 'Nombre del material',
              hintText: 'Ingrese el nombre del material',
              controller: nombreController,
              labelFontSize: 20,
            ),
            TextFieldDefault(
              label: 'Cantidad',
              controller: cantidadController,
              hintText: 'Ingrese la cantidad',
              labelFontSize: 20,
              obscureText: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: DefaultButton(
                text: 'Añadir Material',
                onPressed: _addMaterial,
                color: Color(0xFF2EC4B6),
              ),
            ),
            const SizedBox(height: 16),
            ...materiales.map((material) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(material['nombre']),
                  Text(material['cantidad'].toString()),
                ],
              );
            }).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          child: const Text('Crear'),
          onPressed: _crearPedido,
        ),
      ],
    );
  }
}