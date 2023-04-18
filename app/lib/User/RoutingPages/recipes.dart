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

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  @override
  RecipesState createState() => RecipesState();
}

class RecipesState extends State<Recipes> {
  String dropdownValue = 'Filter';
  String dropdownValue2 = 'Sortera';
  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
  
  

    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Recept",
                style: GoogleFonts.alfaSlabOne(
                  textStyle: const TextStyle(
                  fontSize: 30,
                ),
                color: Colors.teal,
              ),
            ),
          ),
          actions: [
              IconButton(
              icon: Image.asset('Images/png/download.png',
              width: 100,
              height: 100,
              ),
              
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.white,
        ),
        body:  Column(
                
            ),
            
       
    );
  }
}