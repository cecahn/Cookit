import 'package:first/User/add_food.dart';
import 'package:first/User/recipes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    Pantry(),
    TestHomePage(),
    Recipes(),
  ]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}