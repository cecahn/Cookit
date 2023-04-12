import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';


//köttfärs 7350054730198
// halloumi 07340062810241
// mjölk 07310865001818







late String stringResponse;
late Map mapResponse;
Map exceptionResponse = "Loading food" as Map;
final List<String> list = [];
//late String inputmj;
final _textController = TextEditingController();
String inputmj = "07310865001818";

late String output;
List<String> food = [];


class TestHomePage extends StatefulWidget {
  const TestHomePage({Key? key}) : super(key: key);

  @override
  _TestHomePageState createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  

  Future fetchProduct() async {
  http.Response response;
  response= await http.get(Uri.parse('https://litium.herokuapp.com/get/product?id=$inputmj'));

  

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
    fetchProduct();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Skriv QR kod för din mat',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () {
                      setState(() async {
                        inputmj = _textController.text;
                        _textController.clear();
                        initState();
                        //output = mapResponse['namn'].toString();
                        //food.add(output);
                        //_textController.clear();
                          
                        });

                        
                      }
                    ),  
                  ),
                ),
                /*Expanded(
                  child: ListView.builder(
                    itemCount: food.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        title: Text(food[index]),
                        );
                    }) ,)*/
                
                Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
                  child: Center(
                     child: mapResponse == null? Text("Data is loading"):Text(mapResponse['namn'].toString()),
                    ), 
                  ),
                  
            ]
        ),
      ),
      bottomNavigationBar:
            BottomNavigationBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox (
              width: 40,
              height: 40,
              child: Image.asset('Images/png/004-healthy-food-1.png'),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox (
              width: 40,
              height: 40,
              child:  Image.asset('Images/png/006-add.png'),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon:SizedBox (
              width: 40,
              height: 40,
              child: Image.asset('Images/png/005-recipe.png'),
            ),
            label: '',
          ),
        ]
        )
    );
  }
}