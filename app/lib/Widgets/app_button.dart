import 'package:first/Constants/export.dart';
import "package:flutter/material.dart";

import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function()? onTap;

  const AppButton({
    Key? key,
    required this.text,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1.0,
              blurRadius: 3.0,
              offset: const Offset(0, 3)
            )
          ],
          color: ColorConstant.primaryColor,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade200,
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
}