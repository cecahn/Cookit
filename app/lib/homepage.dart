import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class Produkt {
  final String gtin;
  final String varugrupp;
  final List<String> allergener;
  final int hallbarhet;
  final String name;
  final String tillverkare;

  Produkt({
    required this.gtin,
    required this.varugrupp,
    required this.allergener,
    required this.hallbarhet,
    required this.name,
    required this.tillverkare,
  });

  factory Produkt.fromMap(Map<String, dynamic> map) {
    return Produkt(
        gtin: map['gtin'],
        varugrupp: map['varugrupp'],
        allergener: List<String>.from(map['allergener'] ?? []),
        hallbarhet: map['hallbarhet'],
        name: map['name'],
        tillverkare: map['tillverkare']);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

Future<Map<String, Produkt>> fetchProduct(String arg) async {
  http.Response response = await http
      .get(Uri.parse('https://litium.herokuapp.com/get/product?id=$arg'));

  List<String> produktlist = [];

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final Map<String, dynamic> jsonMap = jsonDecode(response.body);

    Map<String, Produkt> produktMap = jsonMap.map((key, value) {
      return MapEntry(key, Produkt.fromMap(value));
    });

    return produktMap;

    //return produktMap;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load product');
  }
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  String _textInput = '';
  String input = '';
  final List<String> _list = [];
  late Future<Map<String, Produkt>> futureProduct = fetchProduct(_textInput);

  void _addItem(String item) {
    setState(() {
      _list.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("CookIt",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
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
                        _textInput = _textController.text;
                        futureProduct = (await fetchProduct(_textInput))
                            as Future<Map<String, Produkt>>;
                        futureProduct.then((produktMap) {
                          Produkt theProdukt = produktMap['varugrupp']!;
                          debugPrint(theProdukt.varugrupp);
                          input = theProdukt.varugrupp;
                          _addItem(input);
                        });

                        //print(theProdukt.name);
                      });

                      _textController.clear();
                    },
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(_list[index]),
                      );
                    }),
              ),

              /*Material(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(50),
                child: FutureBuilder<Produkt>(
                  future: futureProduct,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.name);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),*/

              //Text('Saved Text Input: $_textInput'),
            ],
          ),
        ),
        bottomNavigationBar:
            BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_outlined, color: Colors.black),
            label: '',
          ),
        ]
        )
        );
  }
}
