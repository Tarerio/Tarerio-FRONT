import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tarerio/consts.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];
  List<String> users = [];
  String? selectedUser;

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.connect();

    socket.on('connect', (_) {
      socket.emit('register', User['id']);
    });

    socket.on('disconnect', (_) => print('disconnect'));

    socket.on('message', (data) {
      setState(() {
        messages.add(data['message']);
      });
    });

    fetchUsers();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  void fetchUsers() {
    // Replace with your method to fetch users from the backend
    setState(() {
      users = ['Professor A', 'Professor B', 'Student A', 'Student B'];
    });
  }

  void cleanFiltros() {
    setState(() {
      selectedUser = null;
      _controller.text = '';
    });
  }

  void sendMessage() {
    if (_controller.text.isEmpty) return;
    final data = {
      'message': _controller.text,
      'id_emisor': User['id'],
      'id_receptor': 2,
      'fecha': DateTime.now().toString(),
      'tipo_emisor': 'alumno',
      'tipo_receptor': 'profesor',
    };
    socket.emit('message', data);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios',
            style: TextStyle(
                color: Color(0xFF2EC4B6),
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
                SizedBox(width: 10),
                Container(
                  child: DropdownButton<String>(
                    alignment: Alignment.center,
                    hint: Text('Filtrar por tipo'),
                    value: tipoUsuarioSeleccionado,
                    items: ['Profesor', 'Alumno'].map((String tipo) {
                      return DropdownMenuItem<String>(
                        value: tipo,
                        child: Text(tipo),
                        alignment: Alignment.center,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        tipoUsuarioSeleccionado = newValue;
                        _filterUsuarios(
                            tipo: tipoUsuarioSeleccionado,
                            nickname: nicknameController.text);
                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    underline: SizedBox.shrink(),
                    iconEnabledColor: Color(colorPrincipal),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 213,
                  child: TextField(
                    controller: nicknameController,
                    decoration: InputDecoration(
                      labelText: 'Buscar por nombre',
                      labelStyle: TextStyle(color: Color(colorPrincipal)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(colorPrincipal)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(colorPrincipal), width: 2.0),
                      ),
                      suffixIcon:
                          Icon(Icons.search, color: Color(colorPrincipal)),
                    ),
                    onChanged: (value) async {
                      final response = await _api.getFilteredUsuarios(
                          value, tipoUsuarioSeleccionado);
                      setState(() {
                        usuarios = response;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8.0, // Space between cards horizontally
                runSpacing: 8.0, // Space between cards vertically
                children: usuarios.map((usuario) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width > 800
                        ? 200
                        : 150, // Adjust width based on screen size
                    child: UsuarioCard(
                      id_usuario: usuario['id_usuario'],
                      imagenBase64: usuario['imagenBase64'] ?? '',
                      nickname: usuario["nickname"],
                      onIniciarChat: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              idUsuario: usuario['id_usuario'],
                              nickname: usuario["nickname"],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrarUsuario()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2EC4B6),
      ),
      drawer: Navbar(
        screenIndex: 4,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }
}
