import 'dart:convert';

import 'package:first/User/DetailPages/productPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import "package:multiselect/multiselect.dart";
import 'package:first/Services/dataModel.dart';
import 'package:requests/requests.dart';

import '../../cubit/appCubit.dart';
import '../../Services/dataModel.dart';
import '../../cubit/appCubitStates.dart';
import '../DetailPages/productPage.dart';
import '../DetailPages/productPage.dart';

bool sortActivated = false;
bool sortBytime = false;
bool sortByalfabet = false;

List<String> filter = ['Mejeri', 'Kött'];
List<String> selectedCategories = [];

//import 'package:myapp/utils.dart';
/*class Produkt {
  final String varugrupp;
  final String namn;
  final int utgang;
  final int tid;

  //final String hållbarhet;

  Produkt(
      {required this.varugrupp,
      required this.namn,
      required this.utgang,
      required this.tid});
}*/

List<Produkt> skafferi = [];

/*int sortByUtgang(Produkt produkta, Produkt produktb) {
  int a = produkta.utgang;
  int b = produktb.utgang;

  if (a < b) {
    return -1;
  } else if (a > b) {
    return 1;
  } else {
    return 0;
  }
}

int sortByTime(Produkt produkta, Produkt produktb) {
  int a = produkta.tid;
  int b = produktb.tid;

  if (a < b) {
    return -1;
  } else if (a > b) {
    return 1;
  } else {
    return 0;
  }
}*/

final _textController = TextEditingController();
String input = "";

class Pantry extends StatefulWidget {
  const Pantry({Key? key}) : super(key: key);

  @override
  PantryState createState() => PantryState();
}

class PantryState extends State<Pantry> {
  String dropdownValue = 'Varugrupp';
  late final Future<List<Produkt>> skafferi;

  @override
  void initState() {
    super.initState();
    skafferi = getSkafferi();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data as List<Produkt>;
            final unikaVarugrupper = data.map((e) => e.varugrupp).toSet();

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Leta efter produkt i skafferiet',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.black),
                            onPressed: () {
                              setState(() async {
                                input = _textController.text;
                                _textController.clear();
                                initState();
                              });
                            }),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 44,
                    width: 220,
                    child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Transform.scale(
                          scale: 0.0,
                          child: const Icon(Icons.menu),
                        ),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'Utgångsdatum',
                            child: Text('Utgångsdatum'),
                          ),
                          DropdownMenuItem(
                            value: 'Senast tillagd',
                            child: Text('Senast tillagd'),
                          ),
                          DropdownMenuItem(
                            value: 'Varugrupp',
                            child: Text('Varugrupp'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        }),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: SizedBox(
                      height: 300,
                      width: 400,
                      child: dropdownValue != 'Varugrupp'
                          ? ListView.builder(
                              itemCount: data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 9.0),
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.5, color: Colors.teal),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      /*shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Colors.teal, width: 0.2),
                                            borderRadius: BorderRadius.circular(5),
                                          ),*/
                                      title: Text(data[index].namn,
                                          style: GoogleFonts.breeSerif(
                                              textStyle: const TextStyle(
                                            fontSize: 30,
                                            color: Colors.black,
                                          ))),
                                      onTap: () {
                                        BlocProvider.of<AppCubits>(context)
                                            .ProduktPage(data[index]);
                                      },
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: unikaVarugrupper.length,
                              itemBuilder: (_, index) {
                                // Vill lägga till produkter efter varugrupp   
                                final varugrupp = unikaVarugrupper.elementAt(index);
                              return ExpansionTile(
                                    title: Text(varugrupp),
                                    children: data.where((e) => e.varugrupp == varugrupp).map((e) => Text(e.namn)).toList()
                                );
                              },
                            ),
                    ))
              ],
            );
          }
        }
        // Väntar på att hämta skafferiet
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      future: skafferi,
    );
  }
}

Future<List<Produkt>> getSkafferi() async {
  var r2 = await Requests.get("https://litium.herokuapp.com/skafferi",
      withCredentials: true);
  List<dynamic> list = jsonDecode(r2.body);
  print(list);
  return list.map((e) => Produkt.fromJson(e)).toList();
}



