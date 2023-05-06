import 'package:first/Constants/export.dart';
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

  // late double betyg;
  double? betyg;

  void _saveRating(int rating, int receptid) async {

    try {
      var response = await Requests.get(
        "https://litium.herokuapp.com/betyg/set",
        queryParameters: {"recipe-id": receptid, "betyg": rating},
        withCredentials: true
      );

       if (response.statusCode == 200) {
        var json = response.json();

        setState((){
          betyg = double.parse(json["avg_score"]);
        });
       }

       else {
        throw Exception('Failed to change rating');
       }

      } catch (error) {
        setState(() {
          betyg = 0;
        });
      }
    }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubits, CubitStates>(builder: (context, state) {
      RecipeState detail = state as RecipeState;

      

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
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(detail.recept.bild),
                    fit:BoxFit.cover
                    ),
                  
                 )
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
              top: 200,
              child: Container(
                  
                  padding: const EdgeInsets.only(left:20, right:20, top:30),
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
                      Wrap(
                      
                      children:[
                        Text(detail.recept.titel,
                        style: GoogleFonts.alfaSlabOne(
                        textStyle: TextStyle(
                        color: ColorConstant.primaryColor,
                        fontSize: 30,
                        //overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(children: [

                      // Betygsstjärnor
                      RatingBar(
                        minRating:1,
                        maxRating: 5,
                        tapOnlyMode: true,
                        initialRating: detail.recept.betyg.toDouble(),
                        onRatingUpdate: (rating) 
                        {_saveRating(rating.round(), detail.recept.id.round() ); },
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.star, color: Colors.yellow[800]),
                          half: Icon(Icons.star, color: Colors.grey),
                          empty: Icon(Icons.star, color: Colors.grey)
                        ),
                        itemSize: 20,
                        itemPadding: EdgeInsets.only(left: 5, ),
                      ),
                    
                    // Betyg siffror
                    SizedBox(width: 10,),
                    Text(
                        betyg != null ? betyg.toString() : detail.recept.betyg.toString(),
                        style: GoogleFonts.alfaSlabOne(
                        textStyle: TextStyle(
                        color: ColorConstant.primaryColor,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 30),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text( "Ingredienser hemma",
                        style: GoogleFonts.alfaSlabOne(
                        textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                            ),
                          ),

                      )
                    ],),

                     ListView.builder(
                        shrinkWrap: true,
                        //physics: AlwaysScrollableScrollPhysics(),
                        itemCount: detail.recept.used.length,
                        itemBuilder: (context,index) {
                            return Container(
                            margin: EdgeInsets.only(right: Dimensions.width20,),
                            child: Wrap(
                              children: [
                                Text(detail.recept.used[index],
                                maxLines: 3,
                                style: GoogleFonts.breeSerif(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                
                            ),
                          ),
                                ),
                                
                              ],)
                          );
                        },),

                        const SizedBox(height:10),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text( "Inköpslista",
                        style: GoogleFonts.alfaSlabOne(
                        textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                            ),
                          ),

                      )
                    ],),

                     ListView.builder(
                        shrinkWrap: true,
                        //physics: AlwaysScrollableScrollPhysics(),
                        itemCount: detail.recept.missing.length,
                        itemBuilder: (context,index) {
                            return Container(
                            margin: EdgeInsets.only(right: Dimensions.width20,),
                            child: Wrap(
                              children: [
                                Text(detail.recept.missing[index],
                                maxLines: 3,
                                style: GoogleFonts.breeSerif(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                overflow: TextOverflow.ellipsis,
                            ),
                          ),
                                ),
                              ],)
                          );
                        },),

                        SizedBox(height:10),


                         Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text( "Instruktioner",
                        style: GoogleFonts.alfaSlabOne(
                        textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                            ),
                          ),

                      )
                    ],),

                     ListView.builder(
                        shrinkWrap: true,
                        //physics: AlwaysScrollableScrollPhysics(),
                        itemCount: detail.recept.instruktion.length,
                        itemBuilder: (context,index) {
                            return Container(
                            margin: EdgeInsets.only(right: Dimensions.width20,),
                            child: Wrap(
                                
                                children: [Text(detail.recept.instruktion[index],
                                softWrap: true,
                                style: GoogleFonts.breeSerif(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                            ),
                          ),
                                ),]
                              )
                          );
                        },)
                    
                      
                    ],
                  ),
                  
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