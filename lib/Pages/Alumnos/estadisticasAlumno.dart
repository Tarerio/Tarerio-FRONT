import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/AppBarDefault.dart';
import '../../Widgets/SimpleBarChart.dart';
import 'package:tarerio/API/tareaJuegoAPI.dart';
import 'package:tarerio/API/tareaPeticionAPI.dart';
import 'package:tarerio/API/tareaPorPasosAPI.dart';
import '../../API/alumnosAPI.dart';
import 'package:tarerio/Pages/Alumnos/alumnos.dart';

class EstadisticasAlumno extends StatefulWidget {
  final String nickname;

  const EstadisticasAlumno({Key? key, required this.nickname}) : super(key: key);

  @override
  _EstadisticasAlumno createState() => _EstadisticasAlumno();
}

class _EstadisticasAlumno extends State< EstadisticasAlumno> {
  final int colorPrincipal = 0xFF2EC4B6;

  dynamic TotalCompletadasPendientes;
  dynamic JuegoCompletadasPendientes;
  dynamic PasosCompletadasPendientes;
  dynamic PeticionCompletadasPendientes;

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

    List<Object> tareasCompletadasSemana = List.filled(5, 0);

    DateTime hoy = DateTime.now();
    DateTime lunesActual = hoy.subtract(Duration(days: hoy.weekday - 1));

    List<DateTime> diasSemana = List.generate(5, (index) => lunesActual.add(Duration(days: index)),);

    int tareasCompletadas = 0;
    int tareasJuegoCompletas = 0;
    int tareasPasosCompletas = 0;
    int tareasPeticionCompletas = 0;

    int tareasPorHacer = 0;
    int tareasJuegoPorHacer = 0;
    int tareasPasosPorHacer = 0;
    int tareasPeticionPorHacer = 0;

    dynamic totales;
    dynamic juego;
    dynamic pasos;
    dynamic peticion;

    try {
      final tareasJuego = await juegoAPI.obtenerAsignadasAlumno(widget.nickname, null, null);
      final tareasPeticion = await peticionAPI.obtenerAsignadasAlumno(widget.nickname, null, null);
      final tareasPorPasos = await porPasosAPI.obtenerAsignadasAlumno(widget.nickname, null, null);

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

      totales = {'tasksDone': tareasCompletadas, 'tasksToDo' : tareasPorHacer};
      juego = {'tasksDone': tareasJuegoCompletas, 'tasksToDo' : tareasJuegoPorHacer};
      pasos = {'tasksDone': tareasPasosCompletas, 'tasksToDo' : tareasPasosPorHacer};
      peticion = {'tasksDone': tareasPeticionCompletas, 'tasksToDo' : tareasPeticionPorHacer};
      
      isLoading = false; // Cambia el estado de carga

    } catch (e) {
      print("Error al cargar tareas: $e");
      isLoading = false; // Cambia el estado de carga
    }

    setState(() {
      TotalCompletadasPendientes = totales;
      JuegoCompletadasPendientes = juego;
      PasosCompletadasPendientes = pasos;
      PeticionCompletadasPendientes = peticion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Estadisticas de ${widget.nickname}',
        titleColor: Color(colorPrincipal),
        iconColor: Color(colorPrincipal),
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AlumnosPage()),
          );
        },
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
                data: [4, 6, 2, 3, 5],
                xLabels: ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes'],
                yLabel: '',
                yStep: 2,
                width: 800,
                heigth: 200,
                yScale: 1.2,
              ), // Add data
            ),
            const SizedBox(height: 12),
            const Text(
              'Tareas Pendientes y Completadas',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Larger font size
            ),
            _buildRankingList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingList() {
    final totales = TotalCompletadasPendientes;
    final juego = JuegoCompletadasPendientes;
    final pasos = PasosCompletadasPendientes;
    final peticion = PeticionCompletadasPendientes;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                'Tareas Pendientes:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Larger font size
                ),        
                const SizedBox(height: 2),
                Text(
                '${totales['tasksToDo']}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Larger font size
              ),   
            ],),
            const SizedBox(width: 80),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                'Tareas Completadas: ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Larger font size
                ),        
                const SizedBox(height: 2),
                Text(
                '${totales['tasksDone']}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Larger font size
              ),   
            ],)   
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                'Tipo Juego: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Larger font size
                ),        
                const SizedBox(height: 2),
                Text(
                '${juego['tasksToDo']}/${juego['tasksDone']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Larger font size
              ),   
            ],),  
            const SizedBox(width: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                'Tipo Pasos: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Larger font size
                ),        
                const SizedBox(height: 2),
                Text(
                '${pasos['tasksToDo']}/${pasos['tasksDone']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Larger font size
              ),   
            ],),  
            const SizedBox(width: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                'Tipo Peticion: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Larger font size
                ),        
                const SizedBox(height: 2),
                Text(
                '${peticion['tasksToDo']}/${peticion['tasksDone']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Larger font size
              ),   
            ],),    
          ],
        ),
      ]
    );

  }
}