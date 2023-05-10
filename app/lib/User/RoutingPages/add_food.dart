import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:requests/requests.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:first/Constants/export.dart';
import '../../Widgets/app_list_text.dart';
import '../../Widgets/appBar.dart';
import '../../Widgets/app_button.dart';
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
Map exceptionResponse = "Loading food" as Map;
final List<String> list = [];
final _textController = TextEditingController();
List<String> food = [];

class TestHomePage extends StatefulWidget {
  const TestHomePage({Key? key}) : super(key: key);

  @override
  _TestHomePageState createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  late String productGTIN = '';

  void fetchProduct() async {
    String requestParam = productGTIN.padLeft(14, '0');
    print(requestParam);
    try {
      final response = await Requests.get(
          "https://litium.herokuapp.com/skafferi/spara?id=$requestParam",
          withCredentials: true);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON.
        setState(() {
          mapResponse = jsonDecode(response.body);
          String foodName = mapResponse!["namn"].toString();
          // food.add(foodName);
          food.insert(0, foodName);
          if(food.length > 5) {
            food.removeLast();
          }
          for (int i = 0; i < food.length; i++) {
            print(food[i]);
          }
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

  Future<void> scanBarcode() async {
      String scanBarcodeRes;

      try {
        scanBarcodeRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      } on PlatformException {
        scanBarcodeRes = 'Failed to get platform version.';
      }
      if (!mounted) return;

      setState(() {
        productGTIN = scanBarcodeRes;
      });
    }

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
      appBar: customAppBar("CookIt.", true, context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
            
            // Sökruta
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
                          productGTIN = _textController.text;
                          _textController.clear();
                          fetchProduct();
                          initState();
                        });
                      }),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Scan-knapp
            AppButton(text: "Skanna vara", onTap: () async {
              await scanBarcode();
              fetchProduct();
            }),

            // "Nyligen skannad mat" 
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

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Divider(
                color: ColorConstant.primaryColor,
                thickness: 2,
              ),
            ),

            // Listan av tillagda varor
            Container(
              margin: const EdgeInsets.all(20),
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: 300,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: food.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Opacity(
                          opacity: 1.0 - 0.2 * index >= 0 ? 1.0 - 0.2 * index : 0,
                          child: ListTile(
                            title: AppListText(text: food[index]),
                          ),
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
