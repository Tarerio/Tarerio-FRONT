import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/Pages/Profesores/profesores.dart';
import 'package:tarerio/Widgets/ErrorModal.dart';
import 'package:tarerio/Widgets/SuccessModal.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:tarerio/Models/enunciado.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../API/alumnosAPI.dart';
import '../../consts.dart';

class WizardPage extends StatefulWidget {
  final dynamic pedido;

  const WizardPage({super.key, required this.pedido});

  @override
  _WizardPageState createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  TareaPeticionAPI _api = TareaPeticionAPI();
  final PageController _pageController = PageController();
  bool isLoading = false;
  String base64Image = '';
  String taskName = '';
  String description = '';
  String fechaCierre = '';
  List<Enunciado> enunciados = [];
  int? idAdministrador;

  int? selectedAlumnoId;
  List<dynamic> Alumnos = [];

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
    _loadImage();
    _cargarItems();
    _loadIdAdministrador();

  }

  Future<void> _loadIdAdministrador() async {
    try {
      final id = await fetchIdAdministrador();
      setState(() {
        idAdministrador = id;
      });
    } catch (e) {
      print('Failed to load idAdministrador: $e');
    }
  }

  Future<int> fetchIdAdministrador() async {
    final response = await http.get(Uri.parse('$baseUrl/administradores/getIdAdmin'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Failed to load idAdministrador');
    }
  }

  Future<void> _cargarItems() async {
    AlumnosAPI _api = AlumnosAPI();

    try {
      final alumnos = await _api.getAlumnos();
      setState(() {
        Alumnos = alumnos;
      });
    } catch (e) {
      print("Error al cargar alumnos: $e");
    }
  }

  void _initializeFormFields() {
    taskName = 'Recogida material con fecha ${widget.pedido['fecha_pedido'].substring(0, 10)} y hora ${widget.pedido['fecha_pedido'].substring(11, 16)}';
    description = 'Recogida de material para profesor ${widget.pedido['nickname']}';
    fechaCierre = DateTime.now().toIso8601String().substring(0, 10);
    enunciados = widget.pedido['materiales'].map<Enunciado>((material) {
      return Enunciado(
        texto: '${material['cantidad']} - ${material['nombre']}',
        imagen: '',
        video: '',
      );
    }).toList();
  }

  Future<void> _loadImage() async {
    final ByteData bytes = await rootBundle.load(
        'assets/images/tareapeticion.jpg');
    setState(() {
      base64Image = base64Encode(bytes.buffer.asUint8List());
    });
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

  void _createTask() {
    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Future<void> _assignTask() async {
    setState(() {
      isLoading = true;
    });
    try {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    } catch (e) {
      _showErrorModal(context, "Error", "Error al asignar tarea");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _markPedido() async {
    setState(() {
      isLoading = true;
    });
    try {

      final Map<String, dynamic> body = {
        'Titulo': taskName,
        'Descripcion': description,
        'Fecha_estimada_cierre': fechaCierre,
        'enunciados': enunciados,
        'creatorId': idAdministrador!,
        'image': base64Image,
      };

      DateTime dueDate = DateTime.parse(fechaCierre);

      //print(body['Titulo'] + " - " + body['Descripcion'] + " - " + dueDate.toString() + " - " + enunciados.toString() + " - " + base64Image + " - " + selectedAlumnoId.toString() + " - " + dueDate.toString());

      await _api.createAndAssignTask(
          body['Titulo'],
          body['Descripcion'],
          dueDate,
          body['creatorId'],
          enunciados,
          base64Image,
          selectedAlumnoId!,
          dueDate,
          widget.pedido['id_pedido']
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfesoresPage()));

      _showSuccessModal(context, "Éxito", "Pedido marcado como 'Pedido'");
    } catch (e) {
      _showErrorModal(context, "Error", "Error al marcar pedido");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear y asignar pedido de material',
            style: TextStyle(
                color: const Color(0xFF2EC4B6),
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildCreateTaskStep(),
          _buildAssignTaskStep(),
          _buildMarkPedidoStep(),
        ],
      ),
    );
  }

  Widget _buildCreateTaskStep() {
    DateTime parsedFechaCierre = DateTime.parse(fechaCierre);
    String formattedFechaCierre = "${parsedFechaCierre.day.toString().padLeft(
        2, '0')}-${parsedFechaCierre.month.toString().padLeft(
        2, '0')}-${parsedFechaCierre.year}";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Paso 1: Crear Tarea',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text('Título:',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(taskName, style: TextStyle(fontSize: 28)),
          SizedBox(height: 10),
          Text('Descripción:',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(description, style: TextStyle(fontSize: 28)),
          SizedBox(height: 10),
          Text('Fecha estimada de cierre:',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(formattedFechaCierre, style: TextStyle(fontSize: 28)),
          SizedBox(height: 10),
          Text('Enunciados:',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8.0),
            height: 150,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: enunciados.map((enunciado) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(enunciado.texto!, style: TextStyle(
                        fontSize: 26)),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
          DefaultButton(
            text: 'Siguiente',
            onPressed: _createTask,
            color: Color(0xFF2EC4B6),
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildAssignTaskStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Paso 2: Asignar Tarea a Alumno',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          Text('Asignar tarea a:', style: TextStyle(fontSize: 28)),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 300),
            child: DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Seleccionar Alumno',
                border: OutlineInputBorder(),
              ),
              items: Alumnos.map<DropdownMenuItem<int>>((alumno) {
                return DropdownMenuItem<int>(
                  value: alumno['id_usuario'],
                  child: Text(alumno['nickname']),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedAlumnoId = newValue;
                });
              },
              value: selectedAlumnoId,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DefaultButton(
                  text: 'Anterior',
                  onPressed: () {
                    _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease);
                  },
                  color: Colors.grey,
                  fontSize: 18,
                ),
                DefaultButton(
                  text: 'Siguiente',
                  onPressed: selectedAlumnoId != null ? _assignTask : () => _showErrorModal(context, "Error", "Selecciona un alumno"),
                  color: Color(0xFF2EC4B6),
                  fontSize: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkPedidoStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Paso 3: Finalizar y marcar como "Pedido"',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultButton(
                    text: 'Anterior',
                    onPressed: () {
                      _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  DefaultButton(
                    text: 'Finalizar',
                    onPressed: _markPedido,
                    color: Color(0xFF2EC4B6),
                    fontSize: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}