import 'package:flutter/material.dart';

class AppListText extends StatelessWidget {
  double size;
  final String text;
  final Color color;

  AppListText({Key? key,
    this.size = 18,
    required this.text,
    this.color = Colors.black
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size
      )
    );
  }
}