import 'package:flutter/material.dart';
import 'package:tarerio/Models/inicioSesionAPI.dart';
import 'package:tarerio/Pages/principalAlumno.dart';

class PatronAlumno extends StatefulWidget {
  final String label;

  const PatronAlumno({super.key, required this.label});

  @override
  _PatronAlumnoState createState() => _PatronAlumnoState();
}

class _PatronAlumnoState extends State<PatronAlumno> {
  List<String> selectedImages = [];
  List<String> selectedCodes = [];
  List<int?> selectedIndices = List<int?>.filled(4, null);
  int currentColumn = 0;

  final InicioSesionAPI _api = InicioSesionAPI();

  void _addImage(String imagePath, int columnIndex) {
    setState(() {
      selectedImages.add(imagePath);
      selectedIndices[columnIndex] = columnIndex;

      String code = '${widget.label[0].toUpperCase()}${imagePath.replaceAll(RegExp(r'[^0-9]'), '')}';
      selectedCodes.add(code);

      currentColumn++;
    });
  }

  void _refresh() {
    setState(() {
      selectedImages.clear();
      selectedCodes.clear();
      selectedIndices = List<int?>.filled(4, null);
      currentColumn = 0;
    });
  }

  void _confirmSelection() async {
    if (selectedCodes.length == 4) {
      String concatenatedCodes = selectedCodes.join();
      print(concatenatedCodes);

      try {
        var jsonResponse = await _api.inicioSesionAlumno(concatenatedCodes);
        String nickname = jsonResponse['alumno']['nickname'];
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PrincipalAlumno(nickname: nickname)),
        );
      } catch (e) {
        print('Request failed with error: $e');
        _showErrorModal('Error al iniciar sesión', 'No se encontró un usuario con el patrón ingresado.');
      }
    } else {
      _showErrorModal('Error al mandar patrón', 'Debes escoger 4 imágenes para continuar.');
    }
  }

  void _showErrorModal(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.error, size: 50, color: Colors.red),
          title: Text(title, style: const TextStyle(fontSize: 30, color: Colors.red)),
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
        toolbarHeight: 110,
        title: Text('Categoría seleccionada: ${widget.label}'),
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
          children: [
            Expanded(
              child: Center(
                heightFactor: MediaQuery.of(context).size.height * 0.8,
                widthFactor: MediaQuery.of(context).size.width * 0.8,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    int imageIndex = index ~/ 4;
                    int columnIndex = index % 4;
                    String imagePath = images[imageIndex];
                    bool isSelected = selectedIndices[columnIndex] != null;
                    bool isCurrentColumn = columnIndex == currentColumn;

                    return ElevatedButton(
                      onPressed: isSelected || !isCurrentColumn ? null : () => _addImage(imagePath, columnIndex),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(20),
                        shadowColor: Colors.black,
                        elevation: 10,
                        backgroundColor: isSelected ? Colors.grey : null,
                      ),
                      child: Image.asset(imagePath),
                    );
                  },
                ),
              ),
            ),
            Padding(
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
                          child: Image.asset(imagePath, height: 100),
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