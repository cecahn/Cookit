import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

import '../../Constants/Utils/dimensions.dart';
import '../../Constants/Utils/color_constant.dart';
import '../../Services/receptModel.dart';
import '../../Widgets/appBar.dart';
import '../../Widgets/app_dropdown_menu.dart';
import '../../Widgets/app_recipe_tile.dart';
import '../../Widgets/app_button.dart';
import '../../Widgets/app_checkbox_state.dart';

final _textController = TextEditingController();
const maxSearchResults = 10;

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  @override
  RecipesState createState() => RecipesState();
}

class RecipesState extends State<Recipes> {

  // Variables
  String searchPhrase = "";

  late Future<List<Recept>> recept;

  Map<String, dynamic> activeQueryParameters = {
    "max": maxSearchResults, 
    "filter": [],
    "sorting": 1 // 0: Antal varor hemma - 1: Kortast utgångsdatum
  };

  final filterOptions = [
    CheckboxState(title: "Vegan"),
    CheckboxState(title: "Vegetarian"),
    CheckboxState(title: "Mjölkfri"),
    CheckboxState(title: "Äggfri"),
    CheckboxState(title: "Glutenfri"),
    CheckboxState(title: "Laktosfri"),
  ];

  bool filterOpen = false;

  List<String> sortOptions = ["Sortera", "Antal varor hemma", "Utgångsdatum"];
  
  String _sortValue = 'Sortera';

  // Functions

  @override
  void initState() {
    super.initState();
    recept = getRecomendations();
  }

  Future<List<Recept>> searchRecipes() async {
    var res = await Requests.get(
        "https://litium.herokuapp.com/search?phrase=$searchPhrase&limit=5",
        withCredentials: true);
    List<dynamic> list = jsonDecode(res.body);
    print(list);
    return list.map((e) => Recept.fromJson(e)).toList();
  }

  Future<List<Recept>> getRecomendations() async {
    var r2 = await Requests.get(
        "https://litium.herokuapp.com/get/recomendations",
        withCredentials: true,
        queryParameters: activeQueryParameters  
      );
    List<dynamic> list = jsonDecode(r2.body);
    return list.map((e) => Recept.fromJson(e)).toList();
  }

  void toggleFilterMenu() {
    setState(() {
      filterOpen = !filterOpen;
    });
  }

  void addFilter(String filter) {
    activeQueryParameters["filter"].add(filter);
    print(activeQueryParameters);
  }

  void removeFilter(String filter) {
    activeQueryParameters["filter"].remove(filter);
    print(activeQueryParameters);
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

  void _updateSortValue(String value) {
    setState(() {
      activeQueryParameters["sorting"] = value == "Utgångsdatum" ? 1 : 0;
      if (value != _sortValue) {
        _sortValue = value;
        recept = getRecomendations();
      }
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
                                          searchPhrase = _textController.text;
                                          setState(() {
                                            recept = searchPhrase.isEmpty ? getRecomendations() : searchRecipes();
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
