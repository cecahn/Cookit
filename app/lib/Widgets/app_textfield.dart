import 'package:flutter/material.dart';
import '../Constants/Utils/color_constant.dart';

class AppTextfield extends StatelessWidget {
  final controller;
  final hintText;
  final obscureText;

  const AppTextfield(
      {Key? key, this.controller, this.hintText, this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstant.primaryColor, width: 2),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500)
            ),
      ),
    );
  }
}
