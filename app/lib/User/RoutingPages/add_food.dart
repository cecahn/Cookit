import 'dart:async';
import 'dart:convert';

import 'package:first/cubit/appCubitStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:requests/requests.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:first/Constants/export.dart';
import '../../Widgets/app_list_text.dart';
import '../../Widgets/appBar.dart';
import 'pantry.dart';
import 'recipes.dart';
import '../../cubit/appCubit.dart';

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
  final GoogleSignIn googleSignIn = GoogleSignIn();
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
      // appBar: customAppBar("CookIt.", ImageConstant.ellips),
      appBar: AppBar(
        title: const Text("Add Food"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // TODO: LOGGA UT PÅ NÅT JÄVLA SÄTT
              // ...

              // Gå tillbaks till login-sidan
              BlocProvider.of<AppCubits>(context).emit(WelcomeState());
            },
          )
        ],
      ),
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
                          productGTIN = _textController.text;
                          _textController.clear();
                          fetchProduct();
                          initState();
                        });
                      }),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await scanBarcode();
                fetchProduct();
              },
              child: const Text('Scan')),
            Center(
              child: Text(productGTIN)
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
