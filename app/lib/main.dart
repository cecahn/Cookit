
import 'package:first/Services/getLogin.dart';
import 'package:first/Services/getRecipes.dart';
import 'package:first/User/mainPage.dart';
import 'package:first/User/DetailPages/productPage.dart';
import 'package:first/cubit/appCubitLogic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Services/getSkafferi.dart';
import 'User/RoutingPages/pantry.dart';
import 'homepage.dart';
import 'User/start-screen.dart';
import 'User/RoutingPages/add_food.dart';
import 'User/login.dart';
import 'package:bloc/bloc.dart';
import 'package:first/cubit/appCubit.dart';
import 'package:first/cubit/appCubitStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "CookIt",
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        primarySwatch: Colors.purple,
        ),
        home: BlocProvider<AppCubits>(
          create: (context) => AppCubits(),
          child: AppCubitLogics(),
        ));
  }
}
