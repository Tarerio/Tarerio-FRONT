import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/API/alumnosAPI.dart';
import 'package:tarerio/Pages/Tareas/tareas.dart';
import 'package:tarerio/Pages/Alumnos/alumnos.dart';
import 'package:tarerio/Widgets/AppBarDefault.dart';
import 'package:tarerio/Widgets/Cards/TareaCard.dart';
import 'package:tarerio/Widgets/Cards/AlumnoCard.dart';
import 'package:tarerio/Widgets/DefaultButton.dart';
import 'package:tarerio/consts.dart';

class AsignarWidget extends StatefulWidget {
  final int origen;
  final String tipoTarea;

  const AsignarWidget({
    Key? key,
    required this.origen,
    required this.tipoTarea,
  }) : super(key: key);

  @override
  _AsignarWidgetState createState() => _AsignarWidgetState();
}

class _AsignarWidgetState extends State<AsignarWidget> {

  List<dynamic> Alumnos = []; // Lista para tareas

  @override
  void initState() {
    super.initState();
    _cargarItems();
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

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _resetTimes(){
    _selectedTime = null;
    _selectedDate = null;
  }

  // Función para seleccionar la fecha
  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    return pickedDate;

  }

  // Función para seleccionar la hora
  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
    );

    return pickedTime;
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }
  // Función para mostrar el diálogo para seleccionar fecha y hora de una tarea
  void _showDialogAsignar(int alumnoSeleccionado) {
    _resetTimes();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Selecciona la fecha y hora de cierre para la tarea'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Widget para seleccionar la fecha
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // Llama al método de selección de fecha
                            DateTime? pickedDate = await _selectDate(context);
                            if (pickedDate != null) {
                              // Usar setStateDialog para actualizar la vista del diálogo
                              setStateDialog(() {
                                _selectedDate = pickedDate;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2EC4B6),
                          ),
                          child: const SizedBox(
                            width: 120,
                            child: Text(
                              'Seleccionar fecha',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Icon(Icons.calendar_today),
                        SizedBox(width: 10),
                        Text(
                          _selectedDate != null
                              ? DateFormat('dd-MM').format(_selectedDate!)
                              : 'Selecciona una fecha',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  // Widget para seleccionar la hora
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await _selectTime(context);
                            if (pickedTime != null) {
                              // Actualiza la hora seleccionada
                              setStateDialog(() {
                                _selectedTime = pickedTime;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2EC4B6),
                          ),
                          child: const SizedBox(
                            width: 120,
                            child: Text(
                              'Seleccionar hora',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Icon(Icons.access_time),
                        SizedBox(width: 10),
                        Text(
                          _selectedTime != null
                              ? _formatTime(_selectedTime!)
                              : 'Selecciona una hora',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            // Row con los botones de "Cerrar" y "Aceptar" con espacio alrededor
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Añadimos el espacio entre los botones
              children: [
                // Botón "Cerrar" (a la izquierda) usando DefaultButton
                DefaultButton(
                  text: 'Cerrar',
                  onPressed: () {
                    _resetTimes();
                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                  color: Color(colorPrincipal), // Color para el botón "Cerrar"

                ),
                // Botón "Aceptar" (a la derecha) usando DefaultButton
                DefaultButton(
                  text: 'Aceptar',
                  onPressed: () async {
                    // Lógica para aceptar la fecha y hora
                    if (_selectedDate != null && _selectedTime != null) {

                      print("Me pasan los datos $_selectedDate y este $_selectedTime");
                      print(widget.origen);
                      print(alumnoSeleccionado);
                      switch(widget.tipoTarea){
                        case 'Tarea Peticion':
                          try {
                            TareaPeticionAPI _peticionAPI = TareaPeticionAPI();
                            await _peticionAPI.asignarAlumnoTarea(widget.origen, alumnoSeleccionado);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Tarea asignada con éxito'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }catch(e){
                            print("Error al asginar la tarea: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al asignar la tarea'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          break;
                        case 'Tarea Por Pasos':
                          try {
                            TareaPorPasosAPI _porPasosAPI = TareaPorPasosAPI();
                            await _porPasosAPI.asignarAlumnoTarea(widget.origen, alumnoSeleccionado);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Tarea asignada con éxito'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }catch(e){
                            print("Error al asginar la tarea: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al asignar la tarea'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          break;
                        case 'Tarea Juego':
                          try {
                            TareaJuegoAPI _juegoAPI = TareaJuegoAPI();
                            await _juegoAPI.asignarAlumnoTarea(widget.origen, alumnoSeleccionado);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Tarea asignada con éxito'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }catch(e){
                            print("Error al asginar la tarea: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al asignar la tarea'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          break;
                      };
                      _resetTimes();
                      Navigator.of(context).pop(); // Cierra el diálogo
                      // Asiganr la tarea al alumno
                    } else {
                      // Si no hay fecha o hora seleccionada, mostrar un mensaje
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Por favor selecciona una fecha y hora')),
                      );
                    }
                  },
                  color: Color(colorPrincipal),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Inicializa la lista de widgets que se van a mostrar
    List<Widget> widgetList = [];

    widgetList = Alumnos.map<Widget>((alumno) {
      return SizedBox(
        width: MediaQuery.of(context).size.width > 800 ? 200 : 150, // Ajuste del ancho
        child: AlumnoCard(
          id_usuario: alumno['id_usuario'],
          imagenBase64: alumno['imagenBase64'] ?? '',
          nickname: alumno["nickname"],
          onSelect: (){
            _showDialogAsignar(alumno['id_usuario']);
          },
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBarDefault(
        title: 'Asignar Alumno a Tarea',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
        onBackPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TareasPage()),
            );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Wrap(
              spacing: 8.0, // Espacio entre las tarjetas horizontalmente
              runSpacing: 8.0, // Espacio entre las tarjetas verticalmente
              children: widgetList, // Usar la lista de widgets creada
            ),
          ],
        ),
      ),
    );
  }
}