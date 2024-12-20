import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/animation/entrance.json',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
