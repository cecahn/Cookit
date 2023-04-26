import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:requests/requests.dart';
import '../../Constants/Utils/dimensions.dart';
import '../../Constants/Utils/image_constants.dart';
import '../../cubit/appCubit.dart';
import '../../cubit/appCubitStates.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}



class _RecipePageState extends State<RecipePage> {

  late Response deleted; 
      void deleteProduct( String produktid) async {

      try{
      var r2 = await Requests.get("https://litium.herokuapp.com/skafferi/delete",
          withCredentials: true);

      if (r2.statusCode == 200){
        setState((){
          deleted = r2 as Response; 
        });
      }

      else {
        throw Exception('Failed to change rating');
      }

      } catch (error) {
        setState(() {
          deleted = 0 as Response;
        });
      }

    } 
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubits, CubitStates>(builder: (context, state) {
      ProductState detail = state as ProductState;

      return Scaffold(
      body: SingleChildScrollView(
       child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              left:0,
              right:0,
              child: Container(
                width:double.maxFinite,
                height: 50,
                
              )
            ),
            Positioned(
              left: 20,
              top:20,
              child: Row(
            children: [
              IconButton(onPressed: () { BlocProvider.of<AppCubits>(context).goHome2(); }, icon: Icon(Icons.arrow_back_ios), color:Colors.white)
            ],
              )
            ),
            Positioned(
              right: 20,
              top:20,
              child: Row(
            children: [
              IconButton(onPressed: () { deleteProduct(detail.produkt.gtin); }, icon: Icon(Icons.arrow_back_ios), color:Colors.white)
            ],
              )
            ),

            SingleChildScrollView(
            child: Positioned(
              top: 200,
              child: Container(
                  
                  padding: const EdgeInsets.only(left:20, right:20, top:50),
                  //color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 1000,
                  decoration: const BoxDecoration(
                    color:Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(30),

                    ),
                  ),
    
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      
                      children:[
                        Text(detail.produkt.namn,
                        style: GoogleFonts.alfaSlabOne(
                        textStyle: const TextStyle(
                        color: Colors.teal,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        /*Text(detail.recept.betyg.toString(),
                        style: GoogleFonts.alfaSlabOne(
                        textStyle: const TextStyle(
                        color: Colors.teal,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),*/
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(children: [
                      Text("Bäst före datum",
                                style: GoogleFonts.alfaSlabOne(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width:30),

                                IconButton ( onPressed: () {
                                      },
                                icon: Icon(Icons.edit, color: Colors.black)
                                
                                )
                      
                    
                    ],
                  ),

                  SizedBox(height: 20),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text(detail.produkt.bastforedatum,
                                style: GoogleFonts.alfaSlabOne(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                    ],),


                    Row(
                              children: [
                                Text("Allergener",
                                style: GoogleFonts.alfaSlabOne(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                     ListView.builder(
                            shrinkWrap: true,
                            //physics: AlwaysScrollableScrollPhysics(),
                            itemCount: detail.produkt.allergener.length,
                            itemBuilder: (context,index) {
                                return Container(
                                margin: EdgeInsets.only(right: Dimensions.width20,),
                                child: Row(
                                  children: [
                                    Text(detail.produkt.allergener[index]),
                                  ],
                                )
                              );
                            },
                          ),

                          Row (
                            children: [
                              Text("Tillverkare",
                                style: GoogleFonts.alfaSlabOne(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          Row (
                            children: [
                              Text(detail.produkt.tillverkare,
                                style: GoogleFonts.alfaSlabOne(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          )
                    
                      
                    ],
                  ),
                  
              )
            )
            ) 
          ]
        )
      ),
      )
    ); 
    }
    );
  }
}