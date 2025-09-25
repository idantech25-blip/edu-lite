import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ann/welcome_screen.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use Theme to adapt to light/dark mode
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Google-Emblem.webp',
              width: 200,
              height: 210,
            ),
            RichText(
              text: TextSpan(
                text: 'I',
                style: TextStyle(color: textColor, fontSize: 50),
                children: [
                  TextSpan(
                      text: 'D',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 50,
                          fontStyle: FontStyle.italic)),
                  TextSpan(
                      text: 'A',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 50,
                          fontStyle: FontStyle.italic)),
                  TextSpan(
                      text: 'N',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 50,
                          fontStyle: FontStyle.italic)),
                  TextSpan(
                      text: 'TECH',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
