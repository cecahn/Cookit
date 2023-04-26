import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constants/Utils/color_constant.dart';

class ExpansionTileText extends StatelessWidget {
  double size;
  final String text;

  ExpansionTileText({Key? key,
    this.size = 18,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.breeSerif(
          textStyle: TextStyle(
          fontSize: 20,
          color: ColorConstant.primaryColor,
        ))
    );
  }
}