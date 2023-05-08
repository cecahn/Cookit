
import 'package:first/Constants/Utils/color_constant.dart';
import 'package:first/cubit/appCubitLogic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:first/cubit/appCubit.dart';
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
          colorSchemeSeed: ColorConstant.primaryColor
        ),
        home: BlocProvider<AppCubits>(
          create: (context) => AppCubits(),
          child: AppCubitLogics(),
        ));
  }
}
