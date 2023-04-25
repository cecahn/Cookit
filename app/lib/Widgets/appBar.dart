import 'package:first/Constants/export.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

customAppBar(String header, String image) { 
    return AppBar(
        title: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(header,
                style: GoogleFonts.alfaSlabOne(
                    textStyle: const TextStyle(
                      fontSize: 30,
                    ),
                    // color: Colors.teal))),
                    color: ColorConstant.primaryColor))),
        actions: [
          IconButton(
            icon: Image.asset(
              image,
              width: 100,
              height: 100,
            ),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white);
  }
