import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tarerio/consts.dart';
import '../../API/alumnosAPI.dart';
import '../../API/profesoresAPI.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _filteredUsuarios = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _userType = 'Alumno';
  List<String> messages = [];
  List<String> users = [];
  String? selectedUser;
  final _apiAlumnos = AlumnosAPI();
  final _apiProfesores = ProfesoresAPI();

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
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  void _cleanFiltros() {
    setState(() {
      selectedUser = null;
      _controller.text = '';
    });
  }

  _filterUsuarios({nickname}) async {
    print(nickname);
    if (_userType == 'Alumno') {
      final response = await _apiAlumnos.getAlumnos(nickname: nickname);
      _filteredUsuarios = response;
      print(_filteredUsuarios);
    } else if (_userType == 'Profesor') {
      // final response = await _apiProfesores.getProfesores(nickname: nickname);
      // print(response);
    }
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
      'tipo_mensaje': 'texto',
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
      ),
      body: Row(
        children: [
          // Left Side: Search and Select User Type
          Container(
            width: 250,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Buscar usuario', style: TextStyle(fontSize: 18)),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _filterUsuarios(nickname: _searchQuery);
                    });
                  },
                ),
                const SizedBox(height: 10),
                const Text('Tipo de usuario', style: TextStyle(fontSize: 18)),
                DropdownButton<String>(
                  value: _userType,
                  onChanged: (newValue) {
                    setState(() {
                      _userType = newValue!;
                    });
                  },
                  items: <String>['Alumno', 'Profesor', 'Administrador']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text('Resultados de búsqueda',
                    style: TextStyle(fontSize: 18)),

                // Datalist functionality: Showing filtered users dynamically
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredUsuarios.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_filteredUsuarios[index]['nickname']),
                        onTap: () {
                          setState(() {
                            selectedUser = _filteredUsuarios[index]['nickname'];
                          });
                          _searchController.text =
                              _filteredUsuarios[index]['nickname'];
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Right Side: Chat Area
          Expanded(
            child: Column(
              children: [
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
                        decoration: const InputDecoration(
                          hintText: 'Escribe un mensaje',
                        ),
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
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Seleccionar Usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ...users
                .map((user) => ListTile(
                      title: Text(user),
                      onTap: () {
                        setState(() {
                          selectedUser = user;
                        });
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
