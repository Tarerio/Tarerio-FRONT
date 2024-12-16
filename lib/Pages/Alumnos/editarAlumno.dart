import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarerio/API/alumnosAPI.dart';
import 'package:tarerio/Pages/Alumnos/alumnos.dart';
import 'package:tarerio/Widgets/AppBarDefault.dart';
import 'package:tarerio/Widgets/Avatar.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/Widgets/InformationModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/DefaultSwitch.dart';
import 'package:tarerio/Widgets/TextFieldDefault.dart';

class EditarAlumno extends StatefulWidget {
  final int idUsuario;
  const EditarAlumno({super.key, required this.idUsuario});

  @override
  _EditarAlumnoState createState() => _EditarAlumnoState();
}

class _EditarAlumnoState extends State<EditarAlumno> {
  final int colorPrincipal = 0xFF2EC4B6;

  //Clase para hacer peticiones a la API
  final AlumnosAPI _api = AlumnosAPI();

  // Controladores de texto para el nickname y la contraseña
  final TextEditingController _nicknameController = TextEditingController();

  //Variables para la imagen
  File? _image;
  String _base64Image = '';

  // Variables para almacenar la categoría seleccionada
  String _selectedCategory = '';

  late int _idUsuario;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _idUsuario = widget.idUsuario;
    print(_idUsuario);
    _getAlumno(context);
  }

  // Variables para almacenar los estados de los checkboxes
  bool _texto = false;
  bool _imagenes = false;
  bool _pictograma = false;
  bool _video = false;
  bool _audio = false;
  String _porDefecto = 'texto';

  // Función para agregar una imagen al patrón
  final List<String> _selectedImages = [];
  List<String> _selectedCodes = [];
  List<Map<String, String>> _selectedCategoryImages = [];
  int _currentColumn = 0;
  final List<String> _category = [
    'superheroes',
    'insectos',
    'formas',
    'dinosaurios'
  ];

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

  void _showInformationModal(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InformationModal(title: title, content: content);
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });

    final bytes = await _image!.readAsBytes();
    _base64Image = base64Encode(bytes);
  }

  void _restablecerCampos() {
    setState(() {
      _nicknameController.clear();
      _image = null;
      _texto = false;
      _imagenes = false;
      _pictograma = false;
      _video = false;
      _audio = false;
      _restablecerPatron();
      _selectedCategory = '';
    });
  }

  void _restablecerPatron() {
    setState(() {
      _selectedCategoryImages.clear();
      _selectedCodes.clear();
      _selectedImages.clear();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;

      //Actualizar las imágenes de la categoría seleccionada
      _selectedCategoryImages = [
        for (int i = 0; i < 4; i++)
          {
            'imagePath':
                'assets/images/${category.toLowerCase()}/${category.toLowerCase()}$i.png',
            'category': category,
          }
      ];
    });
  }

  void _addImage(String imagePath, String category) {
    setState(() {
      _selectedImages.add(imagePath);

      String code =
          '${category[0].toUpperCase()}${imagePath.replaceAll(RegExp(r'[^0-9]'), '')}';

      _selectedCodes.add(code);

      _currentColumn++;
    });
  }

  Future<String> _getAlumno(BuildContext context) async {
    var jsonResponse = await _api.getAlumnoById(_idUsuario);
    if (jsonResponse['status'] == 'error') {
      _showErrorModal(context, 'Error al obtener alumno',
          'No se pudo obtener la información del alumno.');
    }
    setState(() {
      _nicknameController.text = jsonResponse['alumno']['nickname'];
      String patron = jsonResponse['alumno']['contrasenia'];
      RegExp exp = RegExp(r'..');
      _selectedCodes =
          exp.allMatches(patron).map((match) => match.group(0)!).toList();
      if (_selectedCodes[0][0] == 'S') {
        _selectedCategory = 'Superheroes';
        _selectCategory(_selectedCategory);
        for (int i = 0; i < _selectedCodes.length; i++) {
          _selectedImages.add(
              'assets/images/superheroes/superheroes${_selectedCodes[i][1]}.png');
        }
      } else if (_selectedCodes[0][0] == 'I') {
        _selectedCategory = 'Insectos';
        _selectCategory(_selectedCategory);
        for (int i = 0; i < _selectedCodes.length; i++) {
          _selectedImages.add(
              'assets/images/insectos/insectos${_selectedCodes[i][1]}.png');
        }
      } else if (_selectedCodes[0][0] == 'F') {
        _selectedCategory = 'Formas';
        _selectCategory(_selectedCategory);
        for (int i = 0; i < _selectedCodes.length; i++) {
          _selectedImages
              .add('assets/images/formas/formas${_selectedCodes[i][1]}.png');
        }
      } else if (_selectedCodes[0][0] == 'D') {
        _selectedCategory = 'Dinosaurios';
        _selectCategory(_selectedCategory);
        for (int i = 0; i < _selectedCodes.length; i++) {
          _selectedImages.add(
              'assets/images/dinosaurios/dinosaurios${_selectedCodes[i][1]}.png');
        }
      }

      _porDefecto = jsonResponse['alumno']['porDefecto'];
      _texto = jsonResponse['alumno']['texto'];
      _imagenes = jsonResponse['alumno']['imagenes'];
      _pictograma = jsonResponse['alumno']['pictograma'];
      _video = jsonResponse['alumno']['video'];
      _audio = jsonResponse['alumno']['audio'];
      _base64Image = jsonResponse['alumno']['imagenBase64'] ?? '';
    });
    return jsonResponse['alumno']['nickname'];
  }

  Future<String> _testAlumno(BuildContext context) async {
    String concatenatedCodes = _selectedCodes.join();
    var jsonResponse = await _api.editarAlumno(
        _nicknameController.text,
        concatenatedCodes,
        _texto,
        _imagenes,
        _pictograma,
        _video,
        _audio,
        _porDefecto,
        _base64Image,
        _idUsuario);
    if (jsonResponse['status'] == 'error') {
      _showErrorModal(context, 'Error al registrar alumno',
          'El nickname y patrón deben ser únicos.');
    }
    return jsonResponse['alumno']['nickname'];
  }

  void _editarAlumno(BuildContext context) async {
    if (_nicknameController.text.isEmpty || _selectedCodes.isEmpty) {
      _showErrorModal(context, 'Falta el nickname o el patrón',
          'Por favor, llena todos los campos.');
    } else if (_texto == false &&
        _imagenes == false &&
        _pictograma == false &&
        _video == false &&
        _audio == false) {
      _showErrorModal(context, 'Falta perfil de alumno',
          'Por favor, selecciona minimo un tipo de perfil para el alumno.');
    } else {
      String alumno = await _testAlumno(context);
      if (alumno != '') {
        _showSuccessModal(context, 'Alumno editado correctamente',
            'El alumno $alumno ha sido editado correctamente.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> images = _category.asMap().entries.map((entry) {
      int index = entry.key;
      String category = entry.value;
      return {
        'imagePath':
            'assets/images/${category.toLowerCase()}/${category.toLowerCase()}$index.png',
        'category': category,
      };
    }).toList();

    return Scaffold(
      appBar: AppBarDefault(
        title: 'Editar Alumno',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              size: 50.0,
            ),
            onPressed: _restablecerCampos,
            color: Color(colorPrincipal),
          ),
        ],
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AlumnosPage()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextFieldDefault(
                      label: 'Nombre de usuario',
                      padding: const EdgeInsets.only(top: 10.0, left: 100.0),
                      controller: _nicknameController,
                      labelColor: Color(colorPrincipal),
                      labelFontSize: 30.0,
                      width: 350.0,
                      information: true,
                      titleInformation: 'Nombre de usuario',
                      textInformation:
                          'El nombre de usuario debe ser único en el sistema.',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 110.0, top: 20.0),
                      child: Text(
                        'Patrón del alumno',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                          color: Color(colorPrincipal),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.help,
                          size: 30.0,
                          color: Color(0xFF2EC4B6),
                        ),
                        onPressed: () {
                          _showInformationModal(context, 'Patrón del alumno',
                              'El patrón del alumno es una secuencia de 4 imágenes que el alumno deberá ingresar para acceder a su perfil.');
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: _category.map((category) {
                        return SizedBox(
                          width: 80,
                          height: 80,
                          child: ElevatedButton(
                            onPressed: () => _selectCategory(category),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(20),
                              shadowColor: Colors.black,
                              elevation: 10,
                              backgroundColor: _selectedCategory == category
                                  ? Colors.grey
                                  : Colors.grey[
                                      300], // Change background color if selected
                            ),
                            child: Image.asset(
                              'assets/images/${category.toLowerCase()}/${category.toLowerCase()}0.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_selectedCategoryImages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 360.0, top: 20.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: _selectedCategoryImages.map((imageData) {
                        return SizedBox(
                          width: 80,
                          height: 80,
                          child: ElevatedButton(
                            onPressed: () => {
                              if (_selectedCodes.length < 4 &&
                                  imageData['category'] != null &&
                                  imageData['imagePath'] != null)
                                {
                                  _addImage(imageData['imagePath']!,
                                      imageData['category']!)
                                }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(20),
                              shadowColor: Colors.black,
                              elevation: 10,
                            ),
                            child: Image.asset(imageData['imagePath'] ?? ''),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _restablecerPatron,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(
                            10.0), // Ajusta el padding si es necesario
                        shape: const CircleBorder(), // Hace el botón circular
                        backgroundColor: Colors.white,
                      ),
                      child: Icon(
                        Icons.refresh,
                        color: Color(colorPrincipal),
                        size: 50.0,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, top: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(35.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: SizedBox(
                          height: 110,
                          width: 480,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              return Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 2.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: _selectedImages.length > index
                                    ? Image.asset(_selectedImages[index])
                                    : Container(),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 110.0, top: 20.0),
                      child: Text(
                        'Seleccione un formato por defecto',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                          color: Color(colorPrincipal),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.help,
                          size: 30.0,
                          color: Color(0xFF2EC4B6),
                        ),
                        onPressed: () {
                          _showInformationModal(context, 'Formato por defecto',
                              'El formato por defecto es el tipo de interfaz que se mostrará al alumno al ingresar en una tarea.');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                      child: DropdownButton<String>(
                        value: _porDefecto,
                        items: [
                          {'display': 'Texto', 'value': 'texto'},
                          {'display': 'Imágenes', 'value': 'imagenes'},
                          {'display': 'Video', 'value': 'video'},
                          {'display': 'Audio', 'value': 'audio'},
                          {'display': 'Pictograma', 'value': 'pictograma'},
                        ].map((Map<String, String> item) {
                          return DropdownMenuItem<String>(
                            value: item['value'],
                            child: Text(item['display']!),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _porDefecto = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Segunda columna (derecha)
            Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Avatar(
                      base64Image: _base64Image,
                      radius: 80.0,
                      backgroundColor: Colors.grey[300]!,
                      placeholderIcon: const Icon(Icons.person,
                          size: 150.0, color: Colors.white),
                      onClear: () {
                        setState(() {
                          _base64Image = '';
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    DefaultButton(
                      text: 'Editar Foto',
                      onPressed: _pickImage,
                      color: Color(colorPrincipal),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, right: 10.0),
                          child: Text(
                            'Tipo de Interfaz',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                              color: Color(colorPrincipal),
                            ),
                          ),
                        ),

                        //Información sobre el tipo de interfaz

                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.help,
                              size: 30.0,
                              color: Color(0xFF2EC4B6),
                            ),
                            onPressed: () {
                              _showInformationModal(context, 'Tipo de Interfaz',
                                  'Los formatos disponibles para el alumno.');
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Column(
                          children: [
                            DefaultSwitch(
                              label: 'Texto:',
                              value: _texto,
                              activeColor: Colors.white,
                              activeTrackColor: Color(colorPrincipal),
                              onChanged: (bool value) {
                                setState(() {
                                  _texto = value;
                                });
                              },
                            ),
                            const SizedBox(height: 5),
                            DefaultSwitch(
                              label: 'Pictogramas:',
                              value: _pictograma,
                              activeColor: Colors.white,
                              activeTrackColor: Color(colorPrincipal),
                              onChanged: (bool value) {
                                setState(() {
                                  _pictograma = value;
                                });
                              },
                            ),
                            const SizedBox(height: 5),
                            DefaultSwitch(
                              label: 'Vídeo:',
                              value: _video,
                              activeColor: Colors.white,
                              activeTrackColor: Color(colorPrincipal),
                              onChanged: (bool value) {
                                setState(() {
                                  _video = value;
                                });
                              },
                            ),
                            const SizedBox(height: 5),
                            DefaultSwitch(
                              label: 'Imágenes:',
                              value: _imagenes,
                              activeColor: Colors.white,
                              activeTrackColor: Color(colorPrincipal),
                              onChanged: (bool value) {
                                setState(() {
                                  _imagenes = value;
                                });
                              },
                            ),
                            const SizedBox(height: 5),
                            DefaultSwitch(
                              label: 'Audio:',
                              value: _audio,
                              activeColor: Colors.white,
                              activeTrackColor: Color(colorPrincipal),
                              onChanged: (bool value) {
                                setState(() {
                                  _audio = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DefaultButton(
                      text: 'Guardar',
                      onPressed: () {
                        _editarAlumno(context);
                      },
                      color: Color(colorPrincipal),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
