import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
//import "package:multiselect/multiselect.dart";

bool sortActivated = false;
bool sortBytime = false;
bool sortByalfabet = false;

List<String> filter = ['Mejeri', 'Kött'];
List<String> selectedFilters = [];

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

class Kategori {
  final List<String> produkter;
  final String kategori;

  Kategori({required this.produkter, required this.kategori});
}

List<Kategori> skafferi = [
  Kategori(produkter: ["äpple", "päron"], kategori: "frukt"),
  Kategori(produkter: ["äpple", "päron"], kategori: "kött"),
  Kategori(produkter: ["äpple", "päron"], kategori: "mejeri"),
];

List<Produkt> skafferi2 = [
  Produkt(namn: 'äpple', varugrupp: 'frukt', utgang: 7, tid: 4),
  Produkt(namn: 'broccoli', varugrupp: 'grönsak', utgang: 3, tid: 10),
  Produkt(namn: 'gurka', varugrupp: 'grönsak', utgang: 9, tid: 7),
  Produkt(namn: 'Paprika', varugrupp: 'grönsak', utgang: 9, tid: 5),
  Produkt(namn: 'Paprik', varugrupp: 'grönsak', utgang: 9, tid: 5),
  Produkt(namn: 'Papri', varugrupp: 'grönsak', utgang: 9, tid: 5),
  Produkt(namn: 'Papr', varugrupp: 'grönsak', utgang: 9, tid: 5),
  Produkt(namn: 'Pap', varugrupp: 'grönsak', utgang: 9, tid: 5),
  Produkt(namn: 'Pa', varugrupp: 'grönsak', utgang: 9, tid: 5),
  Produkt(namn: 'P', varugrupp: 'grönsak', utgang: 9, tid: 5),
  Produkt(namn: 'Tomat', varugrupp: 'grönsak', utgang: 9, tid: 5),
  Produkt(namn: 'T', varugrupp: 'grönsak', utgang: 9, tid: 5),
  Produkt(namn: 'To', varugrupp: 'grönsak', utgang: 9, tid: 5),
  Produkt(namn: 'Tom', varugrupp: 'grönsak', utgang: 9, tid: 5),
];

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
  String dropdownValue = 'Filter';
  String dropdownValue2 = 'Sortera';
  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
  
  

    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Skafferi",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
          ),
          actions: [
            IconButton(
              icon: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset('Images/png/003-settings.png'),
              ),
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.white,
        ),
        body:  Column(
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
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 30.0, right: 10.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                        
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.only(
                          left: 60.0,
                          top: 8,
                        ),
                        height: 44,
                        width: 170,
                        
                        /*DropDownMultiSelect(


                
                        onChanged: (List<String> x) {
                          setState(() {
                            selected = x;
                          });
                        },
                        options: const ['a', 'b', 'c', 'd'],
                        selectedValues: selected,
                        whenEmpty: '',
                        icon: Transform.scale(
                          scale: 0.0,
                          child: const Icon(Icons.menu),
                        ),
                        ),*/
                      
                      ),
                      ),

                        /*DropdownButton<String>(
                            value: dropdownValue,
                            icon: Transform.scale(
                              scale: 0.0,
                              child: const Icon(Icons.menu),
                            ),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                            ),
                            isExpanded: true,
                            isDense: true,
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'Frukt',
                                child: Text('Frukt'),
                              ),
                              DropdownMenuItem<String>(
                                  value: 'Kött',
                                  child: Text('Kött')),
                              DropdownMenuItem(
                                value: 'Mejeri',
                                child: Text('Mejeri'),
                              ),
                              DropdownMenuItem(
                                value: 'Grönsaker',
                                child: Text('Grönsaker'),
                              ),
                              DropdownMenuItem(
                                value: 'Gluten',
                                child: Text('Gluten'),
                              ),
                              DropdownMenuItem(
                                value: 'Laktosfri',
                                child: Text('Laktosfri'),
                              ),
                              DropdownMenuItem(
                                value: 'Filter',
                                child: Text('Filter'),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = dropdownValue;
                                sortActivated = false; 
                              });
                            }), */
                  

                    
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.only(
                        left: 50.0,
                        top: 8,
                      ),
                      height: 44,
                      width: 170,
                      child: DropdownButton<String>(
                          value: dropdownValue2,
                          icon: Transform.scale(
                            scale: 0.0,
                            child: const Icon(Icons.menu),
                          ),
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                          ),
                          isExpanded: true,
                          isDense: true,
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
                              value: 'Sortera',
                              child: Text('Sortera'),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = dropdownValue;
                              if (newValue == 'Senast tillagd') {
                                skafferi2.sort(sortByUtgang);
                                sortActivated = true;
                              }
                              if (newValue == 'Utgångsdatum') {
                                skafferi2.sort(sortByTime);
                                sortActivated = true;
                              }
                            });
                          }),
                    ),
                ]
              )
              ),
                  
                
              
              Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: SizedBox(
                      height: 538,
                      width: 400,
                      child: sortActivated
                          ? ListView.builder(
                              itemCount: skafferi2.length,
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
                                        title: Text(skafferi2[index].namn,
                                            style: GoogleFonts.breeSerif(
                                                textStyle: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.black,
                                            )))),
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: skafferi.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 9.0),
                                  child: Container(
                                    child: ListTile(
                                      title: Text(skafferi[index].kategori,
                                          style: GoogleFonts.alfaSlabOne(
                                              textStyle: const TextStyle(
                                            fontSize: 30,
                                            color: Colors.teal,
                                          ))),
                                      subtitle: Text(
                                        skafferi[index].produkter.join(", ")
                                        )
                                      ) 
                                    ),
                                  
                                );
                              }

                              )
                              )
            )
            ]
            ),
            
        bottomNavigationBar:
            BottomNavigationBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('Images/png/004-healthy-food-1.png'),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('Images/png/006-add.png'),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
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
