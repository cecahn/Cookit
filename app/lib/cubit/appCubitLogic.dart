import 'package:first/User/login.dart';
import 'package:first/User/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../User/RoutingPages/add_food.dart';
import 'appCubit.dart';
import 'appCubitStates.dart';

class AppCubitLogics extends StatefulWidget {
  const AppCubitLogics({Key? key}) : super(key: key);

  @override
  State<AppCubitLogics> createState() => _AppCubitLogicsState();
}

class _AppCubitLogicsState extends State<AppCubitLogics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state){
          if(state is WelcomeState){
            return SignInDemo();
          }if(state is LoadedState){
            return MainPage();
          }if(state is LoadingState){
            return Center(child: CircularProgressIndicator());

          }else{
            return Container();
          }
        }
      )
    );
  }
}