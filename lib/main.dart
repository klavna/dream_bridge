import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'naviScreens/navi.dart';

import 'mainAnimation/shape.dart';
import 'mainAnimation/shapePainter.dart';

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
  late List<AnimatedShape> shapes=[];
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
          final targetPosition = Offset(random.nextDouble() * screenWidth, random.nextDouble() * screenHeight); // 최종 위치도 무작위로 설정
          final shapeType = ShapeType.values[random.nextInt(ShapeType.values.length)]; // 도형 종류 무작위 선택
          return AnimatedShape(size: size, position: position, targetPosition: targetPosition, shapeType: shapeType);
        });
      });
    });

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
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ShapePainter(shapes, _controller.value),
                child: Container(),
              );
            },
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
                  child: const Text('Button'),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
