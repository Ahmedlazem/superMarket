import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/reload.gif'),
            fit: BoxFit.fill,
          ),
        ),
        constraints: BoxConstraints.expand(),
      ),
    );
  }
}
