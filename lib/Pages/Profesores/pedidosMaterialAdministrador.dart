import 'package:flutter/material.dart';
import 'package:tarerio/API/profesoresAPI.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/Widgets/Navbar.dart';

import '../Administrador/wizardPedidoMaterial.dart';

class PedidosAdministradorPage extends StatefulWidget {
  final String nickname;

  const PedidosAdministradorPage({super.key, required this.nickname});

  @override
  _PedidosAdministradorPageState createState() =>
      _PedidosAdministradorPageState();
}

class _PedidosAdministradorPageState extends State<PedidosAdministradorPage> {
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
      final DateTime sevenDaysBefore = now.subtract(const Duration(days: 7));
      final DateTime sevenDaysAfter = now.add(const Duration(days: 7));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pedidos de material de ${widget.nickname}',
          style: const TextStyle(
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
                              Text(
                                  'Pedido con fecha: ${pedido['fecha_pedido'].substring(0, 10)} y hora: ${pedido['fecha_pedido'].substring(11, 19)}',
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
                              const Text(
                                'Materiales:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              ...pedido['materiales'].map<Widget>((material) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                              if (pedido['estado'] == 'Pendiente')
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WizardPage(pedido: pedido),
                                        ),
                                      );
                                    },
                                    child: const Text('Crear tarea y asignar',
                                        style: TextStyle(fontSize: 18)),
                                  ),
                                ),
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
      drawer: Navbar(
        screenIndex: 3,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }
}
