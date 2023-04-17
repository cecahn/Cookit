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
                child: Image.asset('Images/png/004-healthy-food-1.png'),
              ),
          label: 'Skafferi',
        ),
        BottomNavigationBarItem(
          icon: SizedBox (
              width: 40,
              height: 40,
              child:  Image.asset('Images/png/006-add.png'),
            ),
          label: 'Lägg till',
        ),
        BottomNavigationBarItem(
          icon: SizedBox (
              width: 40,
              height: 40,
              child: Image.asset('Images/png/005-recipe.png'),
            ),
          label: 'Recept',
        ),
      ],
    );
  }
}