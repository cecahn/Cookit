import 'package:flutter/material.dart';

import '../../Constants/Utils/color_constant.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  const AppButton(
      {Key? key,
      required this.text,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorConstant.primaryColor),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          height: 44,
          width: 170,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: ColorConstant.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ),
    );
  }
}
