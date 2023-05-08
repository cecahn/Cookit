import 'package:flutter/material.dart';

import '../../Constants/Utils/color_constant.dart';

class AppDropdownMenu extends StatelessWidget {
  final List<String> menuOptions;
  final String value;
  final Function(String) callback;

  const AppDropdownMenu(
      {Key? key,
      required this.menuOptions,
      required this.value,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstant.primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: 44,
        width: 170,
        child: Center(
            child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(10),
          alignment: Alignment.center,
          value: value,
          icon: Transform.scale(
            scale: 0.0,
            child: const Icon(Icons.menu),
          ),
          iconSize: 0,
          elevation: 16,
          style: TextStyle(
              color: ColorConstant.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          underline: Container(),
          onChanged: (String? newValue) {
            callback(newValue!);
          },
          items: menuOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(child: Text(value)),
            );
          }).toList(),
        )));
  }
}
