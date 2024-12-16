import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tarerio/consts.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _tipoUsuarioSeleccionado =
      TextEditingController();
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
      print(User['administrador']['id_usuario']);
      socket.emit('register', User['administrador']['id_usuario']);
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

  void _cleanFiltros() {
    setState(() {
      selectedUser = null;
      _controller.text = '';
    });
  }

  _filterUsuarios({tipo, nickname}) async {
    //final response = await _api.getFilteredUsuarios(nickname, tipo);
    // setState(() {
    //   users = response;
    // });
  }

  void sendMessage() {
    if (_controller.text.isEmpty) return;
    print('Sending message: ${_controller.text}');
    final data = {
      'message': _controller.text,
      'id_emisor': User['administrador']['id_usuario'],
      'id_receptor': 2,
      'fecha': DateTime.now().toString(),
      'tipo_emisor': 'alumno',
      'tipo_receptor': 'profesor',
    };
    socket.emit('message', data);
    setState(() {
      messages.add(_controller.text);
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchUsers,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Filtrar usuarios'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nicknameController,
                        decoration: const InputDecoration(hintText: 'Nickname'),
                      ),
                      TextField(
                        controller: _tipoUsuarioSeleccionado,
                        decoration:
                            const InputDecoration(hintText: 'Tipo de usuario'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: _cleanFiltros,
                      child: const Text('Limpiar filtros'),
                    ),
                    TextButton(
                      onPressed: () {
                        _filterUsuarios(
                          nickname: _nicknameController.text,
                          tipo: _tipoUsuarioSeleccionado.text,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Filtrar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (users.isNotEmpty)
            DropdownButton(
              value: selectedUser,
              items: users
                  .map(
                    (user) => DropdownMenuItem(
                      value: user,
                      child: Text(user),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedUser = value.toString();
                });
              },
            ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Mensaje'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
