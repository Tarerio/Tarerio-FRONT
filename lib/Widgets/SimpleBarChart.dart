import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final List<int> data;
  final List<String> xLabels;
  final String yLabel;
  final double width;
  final double heigth;
  final int yStep;
  final double yScale;

  SimpleBarChart({
    required this.data,
    required this.xLabels,
    required this.yLabel,
    this.width = 300,
    this.heigth = 300,
    this.yStep = 5,
    this.yScale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(width, heigth), // Dynamically adjust width
        painter: BarChartPainter(
          data,
          xLabels,
          yLabel,
          yStep,
          yScale,
        ),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<int> data;
  final List<String> xLabels;
  final String yLabel;
  final int yStep;
  final double yScale;

  BarChartPainter(this.data, this.xLabels, this.yLabel, this.yStep, this.yScale);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.fill;

    final axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    final dashedLinePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final textStyle = TextStyle(color: Colors.black, fontSize: 14);
    final labelStyle = TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold);

    final maxData = data.reduce((a, b) => a > b ? a : b);
    final scale = size.height / (maxData + yStep); // Adjust scale to fit within the chart
    final barSpacing = size.width / (data.length * 1.5); // Auto spacing
    final barWidth = barSpacing * 0.6;

    // Draw Y axis lines and labels
    for (int i = 1; i * yStep <= maxData; i++) {
      final yValue = i * yStep;
      final y = size.height - yValue * scale * yScale;

      // Dashed lines
      for (double x = 0; x < size.width; x += 5) {
        canvas.drawLine(Offset(x, y), Offset(x + 3, y), dashedLinePaint);
      }

      // Y axis labels
      final yLabelPainter = TextPainter(
        text: TextSpan(text: yValue.toString(), style: textStyle),
        textDirection: TextDirection.ltr,
      );
      yLabelPainter.layout();
      yLabelPainter.paint(canvas, Offset(-30, y - yLabelPainter.height / 2));
    }

    // Draw Y axis label
    final yLabelPainter = TextPainter(
      text: TextSpan(text: yLabel, style: labelStyle),
      textDirection: TextDirection.ltr,
    );
    yLabelPainter.layout();
    yLabelPainter.paint(canvas, Offset(-120, size.height / 2 - yLabelPainter.height / 2));

    // Draw bars and X axis labels
    for (int i = 0; i < data.length; i++) {
      final barHeight = data[i] * scale * yScale;
      final x = i * (barWidth + barSpacing);
      final y = size.height - barHeight;

      // Draw bar
      canvas.drawRect(Rect.fromLTWH(x, y, barWidth, barHeight), paint);

      // Draw value inside bar
      final valuePainter = TextPainter(
        text: TextSpan(text: data[i].toString(), style: textStyle),
        textDirection: TextDirection.ltr,
      );
      valuePainter.layout();
      valuePainter.paint(canvas, Offset(x + barWidth / 2 - valuePainter.width / 2, y - 15));

      // Draw X axis labels
      final xLabelPainter = TextPainter(
        text: TextSpan(text: xLabels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      xLabelPainter.layout();
      xLabelPainter.paint(canvas, Offset(x + barWidth / 2 - xLabelPainter.width / 2, size.height + 5));
    }

    // Draw Y axis line
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), axisPaint);

    // Draw X axis line
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axisPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}