import 'package:flutter/material.dart';
import 'package:tarerio/API/alumnosAPI.dart';
import 'package:tarerio/Pages/Alumnos/principalAlumno.dart';

class PatronAlumno extends StatefulWidget {
  final String label;
  final String nickname;

  const PatronAlumno({super.key, required this.label, required this.nickname});

  @override
  _PatronAlumnoState createState() => _PatronAlumnoState();
}

class _PatronAlumnoState extends State<PatronAlumno> {
  List<String> selectedImages = [];
  List<String> selectedCodes = [];
  int currentColumn = 0;

  final AlumnosAPI _api = AlumnosAPI();

  void _addImage(String imagePath) {
    setState(() {
      selectedImages.add(imagePath);

      String code =
          '${widget.label[0].toUpperCase()}${imagePath.replaceAll(RegExp(r'[^0-9]'), '')}';
      selectedCodes.add(code);

      currentColumn++;
    });
  }

  void _refresh() {
    setState(() {
      selectedImages.clear();
      selectedCodes.clear();
      currentColumn = 0;
    });
  }

  void _confirmSelection() async {
    if (selectedCodes.length == 4) {
      String concatenatedCodes = selectedCodes.join();
      print(concatenatedCodes);

      try {
        var jsonResponse =
            await _api.inicioSesionAlumno(widget.nickname, concatenatedCodes);
        String nickname = jsonResponse['alumno']['nickname'];
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PrincipalAlumno(nickname: nickname)),
        );
      } catch (e) {
        print('Request failed with error: $e');
        _showErrorModal('Error al iniciar sesión',
            'No se encontró un usuario con el patrón ingresado.');
      }
    } else {
      _showErrorModal(
          'Error al mandar patrón', 'Debes escoger 4 imágenes para continuar.');
    }
  }

  void _showErrorModal(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.error, size: 50, color: Colors.red),
          title: Text(title,
              style: const TextStyle(fontSize: 30, color: Colors.red)),
          content: Text(content, style: const TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('De acuerdo', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'assets/images/${widget.label.toLowerCase()}/${widget.label.toLowerCase()}0.png',
      'assets/images/${widget.label.toLowerCase()}/${widget.label.toLowerCase()}1.png',
      'assets/images/${widget.label.toLowerCase()}/${widget.label.toLowerCase()}2.png',
      'assets/images/${widget.label.toLowerCase()}/${widget.label.toLowerCase()}3.png',
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF2EC4B6), size: 30),
        toolbarHeight: 110,
        title: Text('Bienvenido: ${widget.nickname}',
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2EC4B6))),
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: _refresh,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(20),
                shadowColor: Colors.black,
                elevation: 10,
              ),
              child: const Icon(Icons.refresh, size: 30),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Ingrese su patrón:',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2EC4B6)),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: images.map((imagePath) {
                    return SizedBox(
                      width: 150,
                      height: 150,
                      child: ElevatedButton(
                        onPressed: selectedImages.length >= 4
                            ? null
                            : () => _addImage(imagePath),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(20),
                          shadowColor: Colors.black,
                          elevation: 10,
                        ),
                        child: Image.asset(imagePath),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Container(
              height: 150, // Adjust the height as needed
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: selectedImages
                            .map((imagePath) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(imagePath),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _confirmSelection,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(20),
                      shadowColor: Colors.black,
                      elevation: 10,
                    ),
                    child: const Icon(Icons.thumb_up, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
