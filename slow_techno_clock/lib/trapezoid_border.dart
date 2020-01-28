import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

enum SnapTo { top, bottom }

class TrapezoidPaint extends CustomPainter {
  final SnapTo snapTo;
  final Paint backgroundPaint;
  final Paint borderPaint;

  TrapezoidPaint(
      {@required this.snapTo,
      @required this.borderPaint,
      @required this.backgroundPaint});

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    if (snapTo == SnapTo.top) {
      path.moveTo(-150, -5);
      path.lineTo(-125, 32);
      path.lineTo(125, 32);
      path.lineTo(150, -5);
    } else {
      path.moveTo(-150, 5);
      path.lineTo(-125, -32);
      path.lineTo(125, -32);
      path.lineTo(150, 5);
    }

    canvas.drawPath(path, backgroundPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
