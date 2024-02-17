import 'dart:math';
import 'package:flutter/material.dart';

import 'navi.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dream Bridge',
      home: Scaffold(
        body: AnimatedBackground(),
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<AnimatedShape> shapes;
  final int numberOfShapes = 30;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    // Use a post-frame callback to wait for the build phase to complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      setState(() {
        shapes = List.generate(numberOfShapes, (index) {
          final size = random.nextDouble() * 50 + 20;
          final position = Offset(random.nextDouble() * screenWidth, random.nextDouble() * screenHeight);
          final targetPosition = Offset(screenWidth / 2, screenHeight / 2);
          return AnimatedShape(size: size, position: position, targetPosition: targetPosition);
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Animated shapes in the background
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ShapePainter(shapes, _controller.value),
              child: Container(),
            );
          },
        ),
        // Text and Button on top of the shapes
        const Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 100.0),
            child: Text(
              'Dream Bridge\nNext Step',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 50.0,
          left: 0.0,
          right: 0.0,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NaviScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, // Background color
              backgroundColor: Colors.black, // Text Color (Foreground color)
            ),
            child: const Text('Button'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class AnimatedShape {
  double size;
  Offset position;
  Offset targetPosition;

  AnimatedShape({
    required this.size,
    required this.position,
    required this.targetPosition,
  });

  void move(double progress) {
    position = Offset(
      position.dx + (targetPosition.dx - position.dx) * progress,
      position.dy + (targetPosition.dy - position.dy) * progress,
    );
  }
}

class ShapePainter extends CustomPainter {
  List<AnimatedShape> shapes;
  double progress;

  ShapePainter(this.shapes, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.purple.withAlpha(150);
    for (var shape in shapes) {
      shape.move(progress);
      canvas.drawCircle(shape.position, shape.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
