import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tarerio/Pages/principalAlumno.dart';


class PatronAlumno extends StatefulWidget {
  final String label;

  PatronAlumno({required this.label});

  @override
  _PatronAlumnoState createState() => _PatronAlumnoState();
}

class _PatronAlumnoState extends State<PatronAlumno> {
  List<String> selectedImages = [];
  List<String> selectedCodes = []; // New array to store the strings
  List<int?> selectedIndices = List<int?>.filled(4, null); // Track selected index for each column
  int currentColumn = 0; // Track the current column allowed for selection

  void _addImage(String imagePath, int columnIndex) {
    setState(() {
      selectedImages.add(imagePath);
      selectedIndices[columnIndex] = columnIndex; // Store the selected index

      // Extract the first letter of the category and the number of the image
      String code = '${widget.label[0].toUpperCase()}${imagePath.replaceAll(RegExp(r'[^0-9]'), '')}';
      selectedCodes.add(code); // Add the code to the array

      currentColumn++; // Move to the next column
    });
  }

  void _refresh() {
    setState(() {
      selectedImages.clear();
      selectedCodes.clear(); // Clear the codes array
      selectedIndices = List<int?>.filled(4, null); // Reset the selected indices
      currentColumn = 0; // Reset to the first column
    });
  }

  void _confirmSelection() async {
    if (selectedCodes.length == 4) {
      String concatenatedCodes = selectedCodes.join();
      print(concatenatedCodes); // Print the codes array to the console

      // Send a request to the API
      String url = 'http://10.0.2.2:3000/usuarios/inicioSesionAlumno?patron=$concatenatedCodes';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          String nickname = jsonResponse['usuario']['nickname'];
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrincipalAlumno(nickname: nickname)),
          );
        } else {
          print('Request failed with status: ${response.statusCode}');
          _showErrorModal('Error al iniciar sesión', 'No se encontró un usuario con el patrón ingresado.');
        }
      } catch (e) {
        print('Request failed with error: $e');
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
          icon: Icon(Icons.error, size: 50, color: Colors.red),
          title: Text(title, style: TextStyle(fontSize: 30, color: Colors.red)),
          content: Text(content, style: TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('De acuerdo', style: TextStyle(fontSize: 20)),
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
                padding: EdgeInsets.all(20),
                shadowColor: Colors.black,
                elevation: 10,
              ),
              child: Icon(Icons.refresh, size: 30),
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    int imageIndex = index ~/ 4; // Calculate image index
                    int columnIndex = index % 4; // Calculate column index
                    String imagePath = images[imageIndex];
                    bool isSelected = selectedIndices[columnIndex] != null;
                    bool isCurrentColumn = columnIndex == currentColumn;

                    return ElevatedButton(
                      onPressed: isSelected || !isCurrentColumn ? null : () => _addImage(imagePath, columnIndex),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(20),
                        shadowColor: Colors.black,
                        elevation: 10,
                        backgroundColor: isSelected ? Colors.grey : null, // Highlight selected button
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
                      padding: EdgeInsets.all(20),
                      shadowColor: Colors.black,
                      elevation: 10,
                    ),
                    child: Icon(Icons.thumb_up, size: 30),
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