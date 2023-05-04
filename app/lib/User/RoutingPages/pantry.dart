import 'dart:convert';

import 'package:first/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:first/Services/dataModel.dart';
import 'package:requests/requests.dart';

import '../../Constants/Utils/color_constant.dart';
import '../../Constants/Utils/image_constants.dart';
import '../../Services/server_calls.dart';
import '../../Widgets/app_dropdown_menu.dart';
import '../../Widgets/app_list_tile.dart';
import '../../Widgets/expansion_tile_text.dart';
import '../../cubit/appCubit.dart';

// bool sortActivated = false;
// bool sortBytime = false;
// bool sortByalfabet = false;

// List<String> filter = ['Mejeri', 'Kött'];
// List<String> selectedCategories = [];

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

// List<Produkt> skafferi = [];

int sortByUtgang(Produkt produkta, Produkt produktb) {
  String produktaString = produkta.bastforedatum;
  String produktbString = produktb.bastforedatum;

  List<String> splitA = produktaString.split('-');
  List<String> splitB = produktbString.split('-');

  DateTime dateA = DateTime(int.tryParse(splitA.elementAt(0))!,
      int.tryParse(splitA.elementAt(1))!, int.tryParse(splitA.elementAt(2))!);
  DateTime dateB = DateTime(int.tryParse(splitB.elementAt(0))!,
      int.tryParse(splitB.elementAt(1))!, int.tryParse(splitB.elementAt(2))!);

  return dateA.compareTo(dateB);
}

int sortByTime(Produkt produkta, Produkt produktb) {
  String produktaString = produkta.tillagning_datum;
  String produktbString = produktb.tillagning_datum;

  List<String> splitA = produktaString.split('-');
  List<String> splitB = produktbString.split('-');

  DateTime dateA = DateTime(int.tryParse(splitA.elementAt(0))!,
      int.tryParse(splitA.elementAt(1))!, int.tryParse(splitA.elementAt(2))!);
  DateTime dateB = DateTime(int.tryParse(splitB.elementAt(0))!,
      int.tryParse(splitB.elementAt(1))!, int.tryParse(splitB.elementAt(2))!);

  return dateA.compareTo(dateB);
}

final _textController = TextEditingController();
String input = _textController.text;

List<Produkt> searchList = [];

bool search = false;

void FilterSearch(String textInput, List<Produkt> pantry) {
  for (var i = 0; i < pantry.length; i++) {
    if (pantry
        .elementAt(i)
        .namn
        .toLowerCase()
        .contains(textInput.toLowerCase())) {
      searchList.add(pantry.elementAt(i));
    }
  }
}

class Pantry extends StatefulWidget {
  const Pantry({Key? key}) : super(key: key);

  @override
  PantryState createState() => PantryState();
}

class PantryState extends State<Pantry> {
  String _sortValue = 'Varugrupp';
  List<String> _sortOptions = ["Varugrupp", "Utgångsdatum", "Senast tillagd"];

  void _updateSortValue(String value) async {
    List<Produkt> varor = search ? searchList : await skafferi;
    setState(() {
      _sortValue = value;
      if (_sortValue == 'Utgångsdatum') {
        varor.sort(sortByUtgang);
      }
      if (_sortValue == 'Senast tillagd') {
        varor.sort(sortByTime);
      }
    });
  }

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

            return Scaffold(
                appBar: customAppBar("Skafferi", ImageConstant.ellips),
                body: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, right: 10.0),
                        child: TextField(
                            controller: _textController,
                            onChanged: (input) {
                              setState(() {
                                if (input.isEmpty == false) {
                                  searchList = [];
                                  FilterSearch(input, data);
                                  search = true;
                                  _sortValue = 'Senast tillagd';
                                } else {
                                  // searchList = [];
                                  search = false;
                                }
                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'Leta efter produkt i skafferiet',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                    icon: search == false
                                        ? const Icon(Icons.search,
                                            color:
                                                Color.fromARGB(255, 83, 42, 42))
                                        : const Icon(Icons.cancel_sharp),
                                    onPressed: () {
                                      setState(() {
                                        _textController.clear();
                                        search = false;
                                      });
                                    }))),
                      ),

                      const SizedBox(height: 10),

                      const SizedBox(child: Text("Sortera efter")),

                      // Sorting dropdown
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 20.0, right: 20.0),
                        child: AppDropdownMenu(
                            menuOptions: _sortOptions,
                            value: _sortValue,
                            callback: _updateSortValue),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: 550,
                            width: 400,
                            child: _sortValue != 'Varugrupp'
                                ? ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: search == false
                                        ? data!.length
                                        : searchList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Produkt item = data[index];
                                      if (search == true) {
                                        item = searchList[index];
                                      }
                                      return Dismissible(
                                        key: Key(item.skafferi_id),
                                        onDismissed: (right) {
                                          setState(() {
                                            data.remove(item);
                                            searchList.remove(item);
                                          });
                                          ScaffoldMessenger.of(context)
                                              .removeCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Tog bort ${item.namn} ur skafferiet"),
                                                action: SnackBarAction(
                                                  label: "Ångra",
                                                  onPressed: () {
                                                    setState(() {
                                                      data.insert(index, item);
                                                      if (search == true) {
                                                        searchList.insert(
                                                            index, item);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ))
                                              .closed
                                              .then((value) {
                                            if (value !=
                                                SnackBarClosedReason.action) {
                                              final response =
                                                  ServerCall.deleteFromPantry(
                                                      item.skafferi_id);
                                              skafferi = getSkafferi();
                                            }
                                          });
                                        },
                                        background: Container(
                                            color: ColorConstant.primaryColor),
                                        child: AppListTile(
                                            data: item, namn: item.namn),
                                      );
                                    },
                                  )
                                : ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: unikaVarugrupper.length,
                                    itemBuilder: (_, index) {
                                      // Vill lägga till produkter efter varugrupp
                                      final varugrupp =
                                          unikaVarugrupper.elementAt(index);
                                      return ExpansionTile(
                                          title: ExpansionTileText(
                                              text: varugrupp),
                                          initiallyExpanded: true,
                                          children: data
                                              .where((item) =>
                                                  item.varugrupp == varugrupp)
                                              .map((item) => Dismissible(
                                                  key: Key(item.skafferi_id),
                                                  onDismissed: (right) {
                                                    setState(() {
                                                      data.remove(item); 
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .removeCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Tog bort ${item.namn} ur skafferiet"),
                                                          action:
                                                              SnackBarAction(
                                                            label: "Ångra",
                                                            onPressed: () {
                                                              setState(() {
                                                                data.insert(
                                                                    index,
                                                                    item);
                                                              });
                                                            },
                                                          ),
                                                        ))
                                                        .closed
                                                        .then((value) {
                                                      if (value !=
                                                          SnackBarClosedReason
                                                              .action) {
                                                        final response = ServerCall
                                                            .deleteFromPantry(
                                                                item.skafferi_id);
                                                        skafferi =
                                                            getSkafferi();
                                                      }
                                                    });
                                                  },
                                                  background: Container(
                                                      color: ColorConstant
                                                          .primaryColor),
                                                  child: AppListTile(
                                                      data: item,
                                                      namn: item.namn)))
                                              .toList());
                                    },
                                  ),
                          ))
                    ],
                  ),
                ));
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
