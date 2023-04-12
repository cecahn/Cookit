
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'User/start-screen.dart';
import 'User/test.dart';

//import 'User/login.dart'

void main(){

  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());

}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);



  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CookIt",
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        primarySwatch: Colors.purple,
        ),
    home: FutureBuilder(
      builder: (context, dataSnapShot)
      {
        return const TestHomePage();
      },
    ),
  );
}

}