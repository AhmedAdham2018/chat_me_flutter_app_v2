import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(77, 166, 255, 1),
              Color.fromRGBO(179, 218, 255, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.call,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
