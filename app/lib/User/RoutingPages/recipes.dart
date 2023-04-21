import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/Utils/dimensions.dart';
import '../../cubit/appCubit.dart';
import '../../cubit/appCubitStates.dart';
//import 'package:myapp/utils.dart';

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
                        )
                      ),
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

          return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Leta efter Recept',
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
                  const EdgeInsets.only(top: 15.0, left: 30.0, right: 10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.only(
                        left: 60.0,
                        top: 8,
                      ),
                      height: 44,
                      width: 170,
                      child: DropdownButton<String>(
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
                              value: 'Vegan',
                              child: Text('Vegan'),
                            ),
                            DropdownMenuItem<String>(
                                value: 'Vegetarian', child: Text('Vegetarian')),
                            DropdownMenuItem(
                              value: 'Mjölkfri',
                              child: Text('Mjölkfri'),
                            ),
                            DropdownMenuItem(
                              value: 'Äggfri',
                              child: Text('Äggfri'),
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
                            });
                          }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.only(
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
                        items: const [
                          DropdownMenuItem<String>(
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
                          });
                        }),
                  ),
                ],
              ),
              ),
               
            
            Expanded (
              child: SingleChildScrollView(
              //listan av recept
            child: Container(
                height:500,
                child: Padding(
                  padding: EdgeInsets.only(top: 30, left: Dimensions.width15, right: Dimensions.width15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index){
                    return GestureDetector(
                     onTap:(){

                       BlocProvider.of<AppCubits>(context).detailPage(info[index]);
              
                            },
                    
                    child: Container(
                      margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.width15 ),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                              color: Colors.white,
                              image: const DecorationImage(
                                      image: AssetImage('Images/png/tacos.png'),
                                      fit:BoxFit.cover
                                      ), 
                            )
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 30),
                            child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                topRight: Radius.circular(Dimensions.radius20),
                                bottomRight: Radius.circular(Dimensions.radius20),
                              ),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: Dimensions.width10, top: Dimensions.width10),
                              child: Column(
                                children: [
                                  Text(info[index].namn,
                                      style: GoogleFonts.alfaSlabOne(
                                        textStyle: const TextStyle(
                                        fontSize: 30,
                                      ),
                                      color: Colors.black,
                                      )
                                    ),
                                ],)
                            )
                          ),
                            ),
                            ),
                          
                          
                        ],
                      )
                    ),
                    );
                    },)
                ),
            )
              )
            )

          ]),
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