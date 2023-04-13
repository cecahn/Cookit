import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'pantry.dart';
import 'recipes.dart';


//köttfärs 7350054730198
// halloumi 07340062810241
// mjölk 07310865001818







late String stringResponse;
late Map<dynamic, dynamic>? mapResponse;
//late Map mapResponse;
Map exceptionResponse = "Loading food" as Map;
final List<String> list = [];
late String inputmj;
final _textController = TextEditingController();
//String inputmj = "07310865001818";

late String output;
List<String> food = [];

class QuarterCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width - 20, 0);
    path.arcToPoint(
      Offset(size.width - 20, 20),
      radius: Radius.circular(20),
      clockwise: false,
    );
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height - 20);
    path.arcToPoint(
      Offset(size.width - 20, size.height),
      radius: Radius.circular(20),
      clockwise: false,
    );
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}








class TestHomePage extends StatefulWidget {
  const TestHomePage({Key? key}) : super(key: key);

  @override
  _TestHomePageState createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  
  void fetchProduct() async {
  try {
    final response = await http.get(Uri.parse('https://litium.herokuapp.com/get/product?id=$inputmj'));
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      setState((){
      mapResponse = jsonDecode(response.body);
      String foodName = mapResponse!["namn"].toString();
      food.add(foodName);
      });
      // Do something with the data.
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    setState(() {
      mapResponse = null;
    });
    
  }
}

  @override
  void initState(){
    fetchProduct();
    super.initState();
  }

  int _currentIndex = 1;

  final List<Widget> _pages = [
    const Pantry(),
    const TestHomePage(),
    const Recipes(),
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("CookIt.",
                style: GoogleFonts.alfaSlabOne(
                  textStyle: const TextStyle(
                  fontSize: 30,
                ),
                color: Colors.teal,
              )
            ),
          ),
          actions: [
             ClipPath(
              clipper: QuarterCircleClipper(),
              child: Container(
                color: Colors.teal.withOpacity(0.5),
                width: 20,
                height: AppBar().preferredSize.height,
              ),
            ),
            /*IconButton(
              icon: SizedBox (
              width: 40,
              height: 40,
              child: Image.asset('Images/png/003-settings.png'),
              ),
              onPressed: () {},
            ),*/
          ],
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        Padding(
          padding: const EdgeInsets.only(top: 120.0),
          child: TextField(
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
                          
                        });

                        
                      }
                    ),  
                  ),
                ),
        ),
        Row(
          children: [
            Text(
              "Nyligen skannad mat: ",
              style: GoogleFonts.breeSerif(
                textStyle: TextStyle(fontSize: 10),
                color: Colors.teal
              ),
            ),

        ],
        ),
        Container(
          height:250,
          width: 300,
          child: Center(
            child: SizedBox( 
              height: 70, 
                    child: ListView.builder(
                    itemCount: food.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        title: Text(food[index]),
                        );
                      }
                    ),
                  
                  ),
          ),
        ),
          
        
                
                /*Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), color: Colors.white),
                  child: Center(
                     child: mapResponse == null? const Text("") :Text(mapResponse!["namn"].toString()),
                    ), 
                  ),*/
                  
            ]
        ),
      ),
      bottomNavigationBar:
            BottomNavigationBar(
            currentIndex: _currentIndex, 
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
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
        ],
        
        )
    );
  }
}