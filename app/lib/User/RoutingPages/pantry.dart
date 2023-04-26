import 'dart:convert';

import 'package:first/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:first/Services/dataModel.dart';
import 'package:requests/requests.dart';

import '../../Constants/Utils/image_constants.dart';
import '../../Constants/Utils/color_constant.dart';
import '../../cubit/appCubit.dart';
import '../../Widgets/app_list_text.dart';
import '../../Widgets/expansion_tile_text.dart';
import '../../Widgets/app_list_tile.dart';

bool sortActivated = false;
bool sortBytime = false;
bool sortByalfabet = false;

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

class Pantry extends StatefulWidget {
  const Pantry({Key? key}) : super(key: key);

  @override
  PantryState createState() => PantryState();
}

class PantryState extends State<Pantry> {
  String dropdownValue = 'Varugrupp';
  late final Future<List<Produkt>> skafferi;
  String input = "";

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
                body: Column(
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
                                icon: const Icon(Icons.search,
                                    color: Colors.black),
                                onPressed: () {
                                  setState(() async {
                                    input = _textController.text;
                                    _textController.clear();
                                    initState();
                                  });
                                }),
                          )),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(child: Text("Sortera efter")),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 44,
                        width: 220,
                        child: Center(
                            child: DropdownButton<String>(
                                alignment: Alignment.center,
                                value: dropdownValue,
                                iconSize: 0,
                                underline: Container(),
                                style: TextStyle(
                                    color: ColorConstant.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Utgångsdatum',
                                    child: Center(child: Text('Utgångsdatum')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Senast tillagd',
                                    child:
                                        Center(child: Text('Senast tillagd')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Varugrupp',
                                    child: Center(child: Text('Varugrupp')),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                })),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          height: 300,
                          width: 400,
                          child: dropdownValue != 'Varugrupp'
                              ? ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AppListTile(
                                        data: data[index],
                                        namn: data[index].namn);
                                    /* return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: ColorConstant.primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: ListTile(
                                          /*shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Colors.teal, width: 0.2),
                                            borderRadius: BorderRadius.circular(5),
                                          ),*/
                                          title: AppListText(text: data[index].namn),
                                          onTap: () {
                                            BlocProvider.of<AppCubits>(context)
                                                .ProduktPage(data[index]);
                                          },
                                        ),
                                      ),
                                    ); */
                                  },
                                )
                              : ListView.builder(
                                  itemCount: unikaVarugrupper.length,
                                  itemBuilder: (_, index) {
                                    // Vill lägga till produkter efter varugrupp
                                    final varugrupp =
                                        unikaVarugrupper.elementAt(index);
                                    return ExpansionTile(
                                        title:
                                            ExpansionTileText(text: varugrupp),
                                        children: data
                                            .where(
                                                (e) => e.varugrupp == varugrupp)
                                            // .map((e) => Text(e.namn))
                                            // .map((e) => AppListText(text: e.namn, color: ColorConstant.listTextColor))
                                            .map((e) => AppListText(
                                                text: e.namn,
                                                color: ColorConstant
                                                    .listTextColor))
                                            // .map((e) => AppListText(text: e.namn))
                                            .toList());
                                  },
                                ),
                        ))
                  ],
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
