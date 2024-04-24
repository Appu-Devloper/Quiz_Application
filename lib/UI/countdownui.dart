import 'dart:math';

import 'package:flutter/material.dart';

class CountdownGauge extends StatelessWidget {
  final double countdown;
  final double size;

  CountdownGauge({
    required this.countdown,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CountdownGaugePainter(countdown: countdown),
    );
  }
}

class _CountdownGaugePainter extends CustomPainter {
  final double countdown;

  _CountdownGaugePainter({
    required this.countdown,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 3; // Adjust this value for the thickness of the gauge
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double sweepAngle = 360 * (countdown / 45); // Assuming 45 seconds countdown

    Color gaugeColor = countdown <= 10 ? Colors.red : Colors.green;

    final Paint paint = Paint()
      ..color = gaugeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2,
      2 * pi,
      false,
      Paint()..color = Colors.grey.withOpacity(0.2), // Change the background color of the gauge here
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2,
      sweepAngle * (pi / 180),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}