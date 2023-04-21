import 'package:first/User/DetailPages/productPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import "package:multiselect/multiselect.dart";
import 'package:first/Services/dataModel.dart';

import '../../cubit/appCubit.dart';
import '../../cubit/appCubitStates.dart';
import '../DetailPages/productPage.dart';
import '../DetailPages/productPage.dart';

bool sortActivated = false;
bool sortBytime = false;
bool sortByalfabet = false;

List<String> filter = ['Mejeri', 'Kött'];
List<String> selectedCategories = [];

//import 'package:myapp/utils.dart';
class Produkt {
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
}

List<Produkt> skafferi = [];

int sortByUtgang(Produkt produkta, Produkt produktb) {
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
}

final _textController = TextEditingController();
String input = "";

class Pantry extends StatefulWidget {
  const Pantry({Key? key}) : super(key: key);

  @override
  PantryState createState() => PantryState();
}

class PantryState extends State<Pantry> {
  String dropdownValue = '                Varugrupp';
  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Skafferi",
                style: GoogleFonts.alfaSlabOne(
                  textStyle: const TextStyle(
                    fontSize: 30,
                  ),
                  color: Colors.teal,
                )),
          ),
          actions: [
            IconButton(
              icon: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset('Images/png/download.png'),
              ),
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.white,
        ),
        body: BlocBuilder<AppCubits, CubitStates>(builder: (context, state) {
          if (state is LoadedState) {
            var info = state.mat;
            for (int i = 0; i < info.length; i++) {
              info.elementAt(i).changeCategory();
              if (selectedCategories
                      .contains(info.elementAt(i).getcategory()) ==
                  false) {
                selectedCategories.add(info.elementAt(i).getcategory());
              }
            }
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0),
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
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
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: '                Utgångsdatum',
                              child: Text('                Utgångsdatum'),
                            ),
                            DropdownMenuItem(
                              value: '                Senast tillagd',
                              child: Text('                Senast tillagd'),
                            ),
                            DropdownMenuItem(
                              value: '                Varugrupp',
                              child: Text('                Varugrupp'),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                              if (newValue ==
                                  '                Senast tillagd') {
                                sortActivated = true;
                              }
                              if (newValue == '                Utgångsdatum') {
                                sortActivated = true;
                              }
                              if (newValue == '                Varugrupp') {
                                sortActivated = false;
                              }
                            });
                          }),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: SizedBox(
                        height: 500,
                        width: 400,
                        child: sortActivated
                            ? ListView.builder(
                                itemCount: info.length,
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
                                        title: Text(info[index].namn,
                                            style: GoogleFonts.breeSerif(
                                                textStyle: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.black,
                                            ))),
                                        onTap: () {
                                          BlocProvider.of<AppCubits>(context)
                                              .detailPage(info[index]);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: selectedCategories.length,
                                itemBuilder: (_, index) {
                                  return ExpansionTile(
                                      title: Text(selectedCategories[index]),
                                      children: [
                                        ...info.map((e) {
                                          if (e.category == selectedCategories[index]) {
                                            return Text(e.namn);
                                          }
                                          return Container();
                                        }).toList(),
                                      ]);
                                },
                              ),
                      ))
                ]);
          } else {
            return Container();
          }
        }));
  }
}
