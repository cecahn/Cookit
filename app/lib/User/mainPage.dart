import 'package:first/User/RoutingPages/add_food.dart';
import 'package:first/User/RoutingPages/recipes.dart';
import 'package:first/User/RoutingPages/pantry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/Utils/image_constants.dart';

class MainPage extends StatefulWidget {

  final int index;
  MainPage({required this.index});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    Pantry(),
    TestHomePage(),
    Recipes(),
  ];
  
  late int currentIndex = widget.index;
  void onTap(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      
      bottomNavigationBar: BottomNavigationBar(
      unselectedFontSize: 0,
      selectedFontSize: 0,
      type: BottomNavigationBarType.fixed,
      // backgroundColor: Colors.transparent,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,  
      showSelectedLabels: true, 
      elevation: 0,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: SizedBox (
                width: 30,
                height: 30,
                child: Image.asset(ImageConstant.pantry),
              ),
          label: 'Skafferi',
        ),
        BottomNavigationBarItem(
          icon: SizedBox (
              width: 30,
              height: 30,
              child:  Image.asset(ImageConstant.add),
            ),
          label: 'Lägg till',
        ),
        BottomNavigationBarItem(
          icon: SizedBox (
              width: 30,
              height: 30,
              child: Image.asset(ImageConstant.recipes),
            ),
          label: 'Recept',
        ),
      ],
    ),
    );
  }
}