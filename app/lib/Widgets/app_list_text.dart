import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constants/Utils/color_constant.dart';

class AppListText extends StatelessWidget {
  double size;
  final String text;
  final Color color;

  AppListText(
      {Key? key, this.size = 18, required this.text, this.color=Colors.black87})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: GoogleFonts.breeSerif(
          textStyle: TextStyle(
          fontSize: size,
          color: color,
          overflow: TextOverflow.ellipsis
        )));
  }
}
