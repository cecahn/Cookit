import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import "package:multiselect/multiselect.dart";
import 'package:first/Services/dataModel.dart';

import '../../cubit/appCubit.dart';
import '../../cubit/appCubitStates.dart';

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
        body: BlocBuilder<AppCubits, CubitStates> (
          builder: (context, state){
            if (state is LoadedState) {
              var info = state.mat;
              return  Container(
          height:250,
          width: 300,
          child: Center(
            child: SizedBox( 
              height: 70, 
                    child: ListView.builder(
                    itemCount: info.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        title: Text(info[index].namn),
                        );
                      }
                    ),
                  
                  ),
          ),
        );
            }
            else{
              return Container();
            }
          }
        )
                
      );
            
       
  }
}