import 'package:flutter/material.dart';
import '../../Widgets/Navbar.dart';

class SimpleBarChart extends StatelessWidget {
  final List<int> data;

  const SimpleBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: const Size(200, 150), // Smaller size
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

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de administrador',
            style: TextStyle(
                color: Color(0xFF2EC4B6),
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tareas Completadas en el Mes',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold), // Larger font size
            ),
            SizedBox(
              height: 200,
              child: SimpleBarChart(
                  data: const [50, 75, 100, 150, 200]), // Add data
            ),
            const SizedBox(height: 20),
            const Text(
              'Menús Pedidos para esta Semana',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold), // Larger font size
            ),
            _buildMenuList(),
            const SizedBox(height: 20),
            const Text(
              'Ranking de Alumnos por Tareas Completadas',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold), // Larger font size
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
          padding: const EdgeInsets.symmetric(
              vertical: 4.0), // Reduce vertical padding
          child: ListTile(
            title: Text(menu['type'].toString()),
            trailing: Text('${menu['count']} pedidos'),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRankingList() {
    final ranking = [
      {'name': 'Juan Perez', 'tasks': 50},
      {'name': 'Maria Lopez', 'tasks': 45},
      {'name': 'Carlos Sanchez', 'tasks': 40},
      {'name': 'Ana Martinez', 'tasks': 35},
    ];

    return Column(
      children: ranking.map((student) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 4.0), // Reduce vertical padding
          child: ListTile(
            title: Text(student['name'].toString()),
            trailing: Text('${student['tasks']} tareas completadas'),
          ),
        );
      }).toList(),
    );
  }
}
