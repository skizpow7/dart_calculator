import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final Color color;
  final String text;
  final onPressed;

  NumberButton(
      {required this.color, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: onPressed,
        color: color,
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 50)));
  }
}

class ScienceButton extends StatelessWidget {
  final Color color;
  final String text;
  final onPressed;

  ScienceButton(
      {required this.color, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: onPressed,
        color: color,
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 30)));
  }
}
