import 'dart:async';
import 'dart:convert';

import 'package:first/Constants/export.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:first/Widgets/bottomBar.dart';
import 'package:requests/requests.dart';

//import '../Routes/routes.dart';
import '../../Constants/Utils/image_constants.dart';
import '../../Widgets/app_list_text.dart';
import '../../Widgets/appBar.dart';
import 'pantry.dart';
import 'recipes.dart';

//köttfärs 7350054730198
// halloumi 07340062810241
// mjölk 07310865001818
// syltlök 07393756085005
// skånemejerier 07310867000178
// Griskött 02320101100002
// Charkuterier utom korv 07312333006974
// Matbröd 07313830012529

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

class TestHomePage extends StatefulWidget {
  const TestHomePage({Key? key}) : super(key: key);

  @override
  _TestHomePageState createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  void fetchProduct() async {
    try {
      final response = await Requests.get(
          "https://litium.herokuapp.com/skafferi/spara?id=$inputmj",
          withCredentials: true);
      //final response = await http.get(Uri.parse('https://litium.herokuapp.com/get/product?id=$inputmj'));
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON.
        setState(() {
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
  void initState() {
    // fetchProduct();
    super.initState();
  }

  int _index = 0;
  int _currentIndex = 1;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = [
    const Pantry(),
    const TestHomePage(),
    const Recipes(),
  ];

  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    switch (_index) {
      case 0:
        child = Recipes();
        break;

      case 1:
        child = TestHomePage();
        break;

      case 2:
        child = Pantry();
    }

    return Scaffold(
      appBar: customAppBar("CookIt.", ImageConstant.ellips),
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(top: 120.0, left: 10, right: 10),
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
                          fetchProduct();
                          initState();
                        });
                      }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nyligen skannad mat: ",
                  style: GoogleFonts.alfaSlabOne(
                      textStyle: const TextStyle(fontSize: 16),
                      color: ColorConstant.primaryColor),
                ),
              ],
            )),
            SizedBox(
              height: 250,
              width: 300,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  child: ListView.builder(
                      itemCount: food.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: AppListText(text: food[index]),
                        );
                      }),
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
          ]),
        ),
      ),
    );
  }
}
