import 'package:flutter/rendering.dart';

class ClockBackgroundPainter extends CustomPainter {
  final Color color;

  ClockBackgroundPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = color;
    paint.strokeWidth = 1.0;

    for (double i = -120; i < 600; i += 40) {
      canvas.drawLine(Offset(-1600, i), Offset(1600, i), paint);
    }

    for (double i = -40; i < 1000; i += 40) {
      canvas.drawLine(Offset(i, -120), Offset(i, 600), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
