import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the device size for responsive layout
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: size.height * 0.1), // Adjust the space as per your design
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1), // Adjust padding as per your design
              child: const Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05), // Adjust the space as per your design
            Text(
              'Dream Bridge is an app that makes it easy to connect kids in need with local charities that can support them through a map-based service.\n\n'
                  'This allows users to see their children\'s locations and charities at a glance, and help make the world a brighter, more hopeful place through technology',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[800], // Adjust the color as per your design
                fontSize: 16,
              ),
            ),
            SizedBox(height: size.height * 0.1), // Adjust the space as per your design
            Image.asset(
              'assets/your_image.png', // Replace with your asset image
              height: size.height * 0.3, // Adjust the size as per your design
              fit: BoxFit.cover,
            ),
            SizedBox(height: size.height * 0.1), // Adjust the space as per your design
            // Bottom navigation bar or any other widgets you want to add
          ],
        ),
      ),
    );
  }
}
