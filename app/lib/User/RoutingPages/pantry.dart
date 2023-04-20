import 'dart:convert';

import 'package:first/Services/getSkafferi.dart';
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

final _textController = TextEditingController();
String input = "";

class Pantry extends StatefulWidget {
  const Pantry({Key? key}) : super(key: key);

  @override
  PantryState createState() => PantryState();
}

class PantryState extends State<Pantry> {
  List<dynamic> skafferi = [];

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
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (product, index) {
                  return ListTile(
                      title: Text(data[index].namn),
                      subtitle: Text(data[index].varugrupp)
                  );
              }
            );
          }
        }
        
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      future: getSkafferi(),
    );
  }
}

Future<List<dynamic>> getSkafferi() async {
  var r2 = await Requests.get("https://litium.herokuapp.com/skafferi",
      withCredentials: true);
  List<dynamic> list = jsonDecode(r2.body);
  print(list);
  return list.map((e) => Produkt.fromJson(e)).toList();
}
