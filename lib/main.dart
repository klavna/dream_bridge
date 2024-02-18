import 'dart:math';
import 'package:flutter/material.dart';

import 'mainAnimation/animatedShape.dart';
import 'mainAnimation/shapePainter.dart';
import 'naviScreens/navi.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
      duration: const Duration(seconds: 10),
      vsync: this,
    )..addListener(() {
      setState(() {
        for (var shape in shapes) {
          shape.move();
          shape.checkBounds(MediaQuery.of(context).size);
        }
      });
    })..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    shapes = List.generate(numberOfShapes, (index) {
      final size = random.nextDouble() * 50 + 20;
      final position = Offset(random.nextDouble() * screenWidth, random.nextDouble() * screenHeight);
      final velocity = Offset(random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1); // Generate a random velocity for each shape
      final shapeType = ShapeType.values[random.nextInt(ShapeType.values.length)];
      return AnimatedShape(size: size, position: position, velocity: velocity, shapeType: shapeType);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6DC1DC), // Light blue
            Color(0xFFA690FC), // Purple
            Color(0xFFFC96BB), // Pink
            Color(0xFFFFC397), // Orange
          ],
        ),
      ),
      child: Stack(
        children: [
          CustomPaint(
            painter: ShapePainter(shapes),
            child: Container(),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 100.0,left: 30),
              child: Text(
                'Dream Bridge\nNext Step',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 200.0, // Subtract the padding from the total width
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const NaviScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Text Color
                    backgroundColor: Colors.black, // Button Background Color
                    padding: const EdgeInsets.symmetric(vertical: 15.0), // Vertical padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                  ),
                  child: const Text('누가 봐도 버튼'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




