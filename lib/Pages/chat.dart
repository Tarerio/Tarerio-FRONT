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
  List<String> myMessages = [];
  List<String> otherMessages = [];
  List<String> users = [];
  String selectedUser = '';
  final _apiAlumnos = AlumnosAPI();
  final _apiProfesores = ProfesoresAPI();

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.connect();

    print(User);
    socket.on('connect', (_) {
      socket.emit('register', User['administrador']['id_usuario']);
    });

    socket.on('disconnect', (_) => print('disconnect'));

    socket.on('message', (data) {
      setState(() {
        myMessages.add(data['message']);
      });
    });

    socket.on('receiveMessage', (data) {
      setState(() {
        otherMessages.add(data['message']);
      });
    });
  }

  void _selectedUser(user, otherUser) {
    setState(() {
      myMessages.clear();
      otherMessages.clear();
      selectedUser = user;
    });
    socket.emit('join', (otherUser) {
      socket.on('getChat', (data) {});
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  _filterUsuarios({nickname}) async {
    if (_userType == 'Alumno') {
      final response = await _apiAlumnos.getAlumnos(nickname: nickname);
      _filteredUsuarios.clear();
      _filteredUsuarios = response;
    } else if (_userType == 'Profesor') {
      final response = await _apiProfesores.filtrarProfesor(nickname);
      _filteredUsuarios.clear();
      _filteredUsuarios = response;
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
      myMessages.add(_controller.text);
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
          Container(
            width: 250,
            color: Colors.grey[200],
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
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredUsuarios.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_filteredUsuarios[index]['nickname']),
                        onTap: () {
                          setState(() {
                            _selectedUser(
                                User, _filteredUsuarios[index]['nickname']);
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
                Text(selectedUser, style: const TextStyle(fontSize: 18)),
                Expanded(
                  child: ListView.builder(
                    itemCount: myMessages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(myMessages[index]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: otherMessages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(otherMessages[index]),
                            ),
                          ],
                        ),
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
    );
  }
}
