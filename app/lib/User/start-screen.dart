import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
//import 'package:myapp/utils.dart';
import '../Constants/Utils/image_constants.dart';

class StartScreen extends StatefulWidget{
  const StartScreen({Key? key}) : super(key: key);

  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Image.asset(
              ImageConstant.logo,
              width: 200,
              height: 200,
            ),
         SizedBox( height:16),
           Text(
            "CookIt.",
            style: GoogleFonts.roboto(
              fontSize: 50, 
              fontWeight: FontWeight.bold,
              color: Colors.teal)
              ),
          ],
        ),
      ),
    );
  }
}