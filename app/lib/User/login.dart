import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

late Map mapResponse;
Map exceptionResponse = "Loading food" as Map;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key:key);
  
  @override
  LoginPageState createState() => LoginPageState();
  }

class LoginPageState extends State<LoginPage> {
  
  Future googleLogin() async {

    http.Response response;
    response = await http.get(Uri.parse("länk"));

    
    if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    setState((){
      //stringResponse = response.body;
      mapResponse = json.decode(response.body);
    });
    } 
    else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
      mapResponse = json.decode(exceptionResponse as String);
  }
  }

  @override
  void initState(){
    googleLogin();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("CookIt.",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
          ),
          actions: [
            IconButton(
              icon: SizedBox (
              width: 40,
              height: 40,
              child: Image.asset('Images/png/003-settings.png'),
              ),
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: ElevatedButton.icon(
                //icon: const Icon(Icons.Google, color: Colors.black),
                onPressed: () async {
                  /*const url = 'https://www.example.com';
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                  throw 'Could not launch $url';
                  }*/
                }, 
                icon: const Icon(Icons.android),
                label: const Text("google"),
            )
        )
    
    
    );
  }
}