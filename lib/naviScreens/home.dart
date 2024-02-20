import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: const Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(top: 125, left: 30),
          child: Text('Welcome\n ',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Roboto-Black',
              color: Color(0xff846DA0),
              fontSize: 50.0,
              height: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
