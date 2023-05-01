import 'package:first/Constants/export.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class AppGoogleButton extends StatelessWidget {
  final String text;
  final Function()? onTap;

  const AppGoogleButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(3),
            height: 60,
            width: 250,
            // color: Colors.white,
            decoration: BoxDecoration(
              // color: Colors.white,
              color: ColorConstant.primaryColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1.0,
                blurRadius: 3.0,
                offset: const Offset(0, 3)
              )]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white
                    ),
                    child: Transform.scale(
                      scale: 0.7,
                      child: Image.asset('assets/Images/google/google_g.png'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Logga in med Google",
                        style: GoogleFonts.roboto(
                          color: Colors.grey.shade200,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
    );
  }
}
