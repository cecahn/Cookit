import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:requests/requests.dart';

import '../../Constants/Utils/dimensions.dart';
import '../../Constants/Utils/color_constant.dart';
import '../../Services/receptModel.dart';
import '../../Widgets/appBar.dart';
import '../../Widgets/app_dropdown_menu.dart';
import '../../Widgets/app_recipe_tile.dart';
import '../../Widgets/app_button.dart';
import '../../Widgets/app_checkbox_state.dart';
import '../../cubit/appCubit.dart';
import '../../cubit/appCubitStates.dart';
//import 'package:myapp/utils.dart';
import '../../Constants/Utils/image_constants.dart';

final _textController = TextEditingController();

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  @override
  RecipesState createState() => RecipesState();
}

class RecipesState extends State<Recipes> {
  String input = "";



  late Future<List<Recept>> recept;

  @override
  void initState() {
    super.initState();
    recept = getRecomendations();
  }

  Future<List<Recept>> searchRecipes() async {
    var res = await Requests.get(
        "https://litium.herokuapp.com/search?phrase=$input&limit=5",
        withCredentials: true);
    List<dynamic> list = jsonDecode(res.body);
    print(list);
    return list.map((e) => Recept.fromJson(e)).toList();
  }

  /* Future<List<Recept>> getRecomendations() async {
    var r2 = await Requests.get(
        "https://litium.herokuapp.com/get/recomendations?max=5",
        withCredentials: true);
    List<dynamic> list = jsonDecode(r2.body);
    return list.map((e) => Recept.fromJson(e)).toList();
  } */

  Future<List<Recept>> getRecomendations() async {
    var r2 = await Requests.get(
        "https://litium.herokuapp.com/get/recomendations?max=5",
        withCredentials: true,
        queryParameters: activeQueryParameters  
      );
    List<dynamic> list = jsonDecode(r2.body);
    return list.map((e) => Recept.fromJson(e)).toList();
  }

  Map<String, dynamic> activeQueryParameters = {"max": 5, "filter": []};


  void addFilter(String filter) {
    activeQueryParameters["filter"].add(filter);
    print(activeQueryParameters);
  }

  void removeFilter(String filter) {
    activeQueryParameters["filter"].remove(filter);
    print(activeQueryParameters);
  }
  // Filter

  final filterOptions = [
    CheckboxState(title: "Vegan"),
    CheckboxState(title: "Vegetarian"),
    CheckboxState(title: "Mjölkfri"),
    CheckboxState(title: "Äggfri"),
    CheckboxState(title: "Glutenfri"),
    CheckboxState(title: "Laktosfri"),
  ];

  bool filterOpen = false;
  void toggleFilterMenu() {
    setState(() {
      filterOpen = !filterOpen;
    });
  }

  Widget buildCheckbox(CheckboxState checkbox) => CheckboxListTile(
    controlAffinity: ListTileControlAffinity.leading,
    title: Text(checkbox.title),
    activeColor: ColorConstant.primaryColor,
    value: checkbox.value,
    onChanged: (value) {
      value! ? addFilter(checkbox.title) : removeFilter(checkbox.title);
      setState(() {
        checkbox.value = value;
      });
    },
  );

  /* List<String> filterOptions = [
    "Filter",
    "Vegan",
    "Vegetarian",
    "Mjölkfri",
    "Äggfri",
    "Gluten",
    "Laktosfri"
  ]; */
  // String _filterValue = 'Filter';
  /* void _updateFilterValue(String value) {
    setState(() {
      _filterValue = value;
    });
  } */

  // Sort
  List<String> sortOptions = ["Sortera", "Senast tillagd", "Utgångsdatum"];
  String _sortValue = 'Sortera';
  void _updateSortValue(String value) {
    setState(() {
      _sortValue = value;
    });
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
            final data = snapshot.data as List<Recept>;
            //final unikaVarugrupper = data.map((e) => e.varugrupp).toSet();

            return Scaffold(
                appBar: customAppBar("Recept", true, context),
                body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: TextField(
                                controller: _textController,
                                decoration: InputDecoration(
                                  hintText: 'Leta efter Recept',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                      icon: const Icon(Icons.search,
                                          color: Colors.black),
                                      onPressed: () {
                                          input = _textController.text;
                                          setState(() {
                                            recept = input.isEmpty ? getRecomendations() : searchRecipes();
                                          });
                                        //});
                                      }),
                                ),
                              ),
                            ),

                            // Raden med dropdown-menyer
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Button for opening the filter menu
                                  Expanded(
                                    child: AppButton(
                                      text: "Filtrera",
                                      onTap: toggleFilterMenu,
                                    )
                                  ),

                                  const SizedBox(width: 10),

                                  // Sort dropdown
                                  Expanded(
                                      child: AppDropdownMenu(
                                    menuOptions: sortOptions,
                                    value: _sortValue,
                                    callback: _updateSortValue,
                                  ))
                                ],
                              ),
                            ),

                            // Listan av recept
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 20,
                                        left: Dimensions.width10,
                                        right: Dimensions.width10),
                                    child: filterOpen ?
                                    // Filter checkboxes
                                    ListView(
                                      padding: const EdgeInsets.all(20),
                                      children: [
                                        ...filterOptions.map(buildCheckbox),
                                        ElevatedButton(
                                          
                                          onPressed: () {
                                            toggleFilterMenu();
                                            setState(() {
                                              recept = getRecomendations();
                                            });
                                          },
                                          child: const Text("Sök")
                                        )
                                      ]
                                    )
                                    // Recipe list
                                    : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return AppRecipeTile(
                                            recept: data[index]);
                                      },
                                    )

                                  )
                                )
                          ]),
                    )));
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: recept,
    );
  }
}
