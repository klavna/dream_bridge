import 'package:flutter/material.dart';

import 'animatedShape.dart';


class ShapePainter extends CustomPainter {
  List<AnimatedShape> shapes;

  ShapePainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var shape in shapes) {
      final paint = Paint()..color = Colors.purple.withAlpha(150);
      switch (shape.shapeType) {
        case ShapeType.circle:
          canvas.drawCircle(shape.position, shape.size, paint);
          break;
        case ShapeType.square:
          final rect = Rect.fromCenter(center: shape.position, width: shape.size, height: shape.size);
          canvas.drawRect(rect, paint);
          break;
        case ShapeType.triangle:
          final path = Path();
          path.moveTo(shape.position.dx, shape.position.dy - shape.size);
          path.lineTo(shape.position.dx - shape.size, shape.position.dy + shape.size);
          path.lineTo(shape.position.dx + shape.size, shape.position.dy + shape.size);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}