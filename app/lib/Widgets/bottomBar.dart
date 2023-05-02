import 'package:first/Constants/Utils/image_constants.dart';
import 'package:flutter/material.dart';


class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: SizedBox (
                width: 40,
                height: 40,
                child: Image.asset(ImageConstant.pantry),
              ),
          label: 'Skafferi',
        ),
        BottomNavigationBarItem(
          icon: SizedBox (
              width: 40,
              height: 40,
              child:  Image.asset(ImageConstant.goback),
            ),
          label: 'Lägg till',
        ),
        BottomNavigationBarItem(
          icon: SizedBox (
              width: 40,
              height: 40,
              child: Image.asset(ImageConstant.recipes),
            ),
          label: 'Recept',
        ),
      ],
    );
  }
}