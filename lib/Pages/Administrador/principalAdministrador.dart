import 'package:flutter/material.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import '../../API/alumnosAPI.dart';
import '../../Widgets/Navbar.dart';
import '../../Widgets/SimpleBarChart.dart';

/*
class SimpleBarChart extends StatelessWidget {
  final List<int> data;

  SimpleBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(200, 150), // Smaller size
        painter: BarChartPainter(data),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<int> data;
  final double barWidth = 20.0;

  BarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.fill;

    final maxData = data.reduce((a, b) => a > b ? a : b);
    final scale = size.height / maxData;

    for (int i = 0; i < data.length; i++) {
      final barHeight = data[i] * scale;
      final x = i * (barWidth + 10);
      final y = size.height - barHeight;
      canvas.drawRect(Rect.fromLTWH(x, y, barWidth, barHeight), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
*/

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboard createState() => _AdminDashboard();
}

class _AdminDashboard extends State< AdminDashboard> {
  List<dynamic> TareasAlumnos = [];

  bool isLoading = true; // Indicador de carga
  AlumnosAPI _api = AlumnosAPI();

  @override
  void initState() {
    super.initState();
    _obtenerTareasCompletadas();
  }

  Future<void> _obtenerTareasCompletadas() async {
    TareaJuegoAPI juegoAPI = TareaJuegoAPI();
    TareaPeticionAPI peticionAPI = TareaPeticionAPI();
    TareaPorPasosAPI porPasosAPI = TareaPorPasosAPI();

    List<dynamic> Alumnos = [];
    List<dynamic> AlumnoTarea = [];
    try {
      final response = await _api.getAlumnos();
      setState(() {
        Alumnos = response; // Actualiza la lista de tareas
//        isLoading = false; // Cambia el estado de carga
      });
    } catch (e) {
      setState(() {
 //       isLoading = false; // Cambia el estado de carga incluso si hay un error
      });
    }

    List<Object> tareasCompletadasSemana = List.filled(5, 0);

    DateTime hoy = DateTime.now();
    DateTime lunesActual = hoy.subtract(Duration(days: hoy.weekday - 1));

    List<DateTime> diasSemana = List.generate(5, (index) => lunesActual.add(Duration(days: index)),);

    for (var alumno in Alumnos) {

      int tareasCompletadas = 0;
      int tareasJuegoCompletas = 0;
      int tareasPasosCompletas = 0;
      int tareasPeticionCompletas = 0;

      int tareasPorHacer = 0;
      int tareasJuegoPorHacer = 0;
      int tareasPasosPorHacer = 0;
      int tareasPeticionPorHacer = 0;

      try {
        final tareasJuego = await juegoAPI.obtenerAsignadasAlumno(alumno["nickname"], null, null);
        final tareasPeticion = await peticionAPI.obtenerAsignadasAlumno(alumno["nickname"], null, null);
        final tareasPorPasos = await porPasosAPI.obtenerAsignadasAlumno(alumno["nickname"], null, null);

        for (var tarea in tareasJuego) {
          if (tarea["completado"]){
            tareasJuegoCompletas++;

            //TODO: Comparar fecha de realizacion con dias de la semana, e incrementar lista final
            //Haria falta modificar las tareas para añadir el campo de realizacion
            //Deberia de ser en las tablas de realizacion

          } else{
            tareasJuegoPorHacer++;
          }
        }
        for (var tarea in tareasPorPasos) {
          if (tarea["completado"]){
            tareasPasosCompletas++;
          } else{
            tareasPasosPorHacer++;
          }
        }
        for (var tarea in tareasPeticion) {
          if (tarea["completado"]){
            tareasPeticionCompletas++;
          } else{
            tareasPeticionPorHacer++;
          }
        }

        tareasCompletadas = tareasJuegoCompletas + tareasPasosCompletas + tareasPeticionCompletas;
        tareasPorHacer = tareasJuegoPorHacer + tareasPasosPorHacer + tareasPeticionPorHacer;

        var tupla = {'name' : alumno["nickname"], 'tasksDone': tareasCompletadas, 'tasksToDo' : tareasPorHacer,
          'tasksJuegoDone' : tareasJuegoCompletas, 'tasksPasosDone' : tareasPasosCompletas, 'tasksPeticionDone' : tareasPeticionCompletas,
          'tasksJuegoToDo' : tareasJuegoPorHacer, 'tasksPasosToDo' : tareasPasosPorHacer, 'tasksPeticionToDo' : tareasPeticionPorHacer};
        AlumnoTarea.add(tupla);

        isLoading = false; // Cambia el estado de carga
      } catch (e) {
        print("Error al cargar tareas: $e");
        isLoading = false; // Cambia el estado de carga
      }
    }

    setState(() {
      TareasAlumnos = AlumnoTarea;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de administrador', style: TextStyle(color: Color(0xFF2EC4B6), fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: isLoading
      ? Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tareas Completadas esta semana',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Larger font size
            ),
            SizedBox(
              height: 300,
              child: SimpleBarChart(
                data: [60, 40, 60, 20, 40],
                xLabels: ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes'],
                yLabel: '',
                yStep: 15,
                width: 800,
                heigth: 200,
                yScale: 1,
              ), // Add data
            ),
            const SizedBox(height: 12),
            const Text(
              'Menús Pedidos para esta Semana',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Larger font size
            ),
            _buildMenuList(),
            const SizedBox(height: 12),
            const Text(
              'Tareas pendientes/completadas de los alumnos',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Larger font size
            ),
            _buildRankingList(),
          ],
        ),
      ),
      drawer: Navbar(
        screenIndex: 5,
        onLogout: () {
          print("Cerrar sesión");
        },
      ),
    );
  }

  Widget _buildMenuList() {
    final menus = [
      {'type': 'Vegetariano', 'count': 20},
      {'type': 'Celiaco', 'count': 15},
      {'type': 'Triturado Vegano', 'count': 10},
      {'type': 'Estandar', 'count': 30},
    ];

    return Column(
      children: menus.map((menu) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduce vertical padding
          child: ListTile(
            title: Text(menu['type'].toString()),
            trailing: Text('${menu['count']} pedidos'),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRankingList() {
    final ranking = TareasAlumnos;

    return Column(
      children: ranking.map((student) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0), // Reduce vertical padding
          child: ListTile(
            title: Text(student['name'].toString(), style: const TextStyle(fontSize: 20),),
/*
            trailing: Text('Pendientes: ${student['tasksToDo']} (Juego: ${student['tasksJuegoToDo']} | Pasos: ${student['tasksPasosToDo']} | '
            'Peticion: ${student['tasksPeticionToDo']})   -   Completadas: ${student['tasksDone']} (Juego: ${student['tasksJuegoDone']} | '
            'Pasos: ${student['tasksPasosDone']} | Peticion: ${student['tasksPeticionDone']})',
              style: const TextStyle(fontSize: 16),
            ),
*/
            trailing: Text('Totales: ${student['tasksToDo']}/${student['tasksDone']} (Juego: ${student['tasksJuegoToDo']}/${student['tasksJuegoDone']}'
             ' | Pasos: ${student['tasksPasosToDo']}/${student['tasksPasosDone']} | Peticion: ${student['tasksPeticionToDo']}/${student['tasksPeticionDone']})',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }
}