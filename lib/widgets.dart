import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final Color color;
  final String text;
  final onPressed;

  NumberButton(
      {required this.color, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var fontSize = 0.0;
    var orient = MediaQuery.of(context).orientation;
    if (orient == Orientation.portrait) {
      fontSize = 50;
    } else {
      fontSize = 30;
    }

    return MaterialButton(
        onPressed: onPressed,
        color: color,
        child: Text(text,
            style: TextStyle(color: Colors.white, fontSize: fontSize)));
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
    var fontSize = 0.0;
    var orient = MediaQuery.of(context).orientation;
    if (orient == Orientation.portrait) {
      fontSize = 50;
    } else {
      fontSize = 15;
    }
    return MaterialButton(
        onPressed: onPressed,
        color: color,
        child: Text(text,
            style: TextStyle(color: Colors.white, fontSize: fontSize)));
  }
}
