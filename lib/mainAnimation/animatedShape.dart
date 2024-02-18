import 'dart:ui';

enum ShapeType { circle, square, triangle }

class AnimatedShape {
  double size;
  Offset position;
  Offset velocity;
  ShapeType shapeType;

  AnimatedShape({
    required this.size,
    required this.position,
    required this.velocity,
    required this.shapeType,
  });

  void move() {
    position += velocity;
  }

  void checkBounds(Size screenSize) {
    if (position.dx < 0 || position.dx > screenSize.width) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy < 0 || position.dy > screenSize.height) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }
  }
}