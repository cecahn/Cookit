import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
//import 'package:myapp/utils.dart';

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
              'Images/png/002-cooking.png',
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