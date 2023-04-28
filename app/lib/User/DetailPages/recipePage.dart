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

  late Response betyg; 

  void _saveRating(int rating, int receptid) async {

  try{
  var r2 = await Requests.get("https://litium.herokuapp.com/betyg/set?recipe-id=$receptid&betyg=$rating",
      withCredentials: true);

   if (r2.statusCode == 200){
    setState((){
      betyg = r2 as Response; 
    });
   }

   else {
    throw Exception('Failed to change rating');
   }

  } catch (error) {
    setState(() {
      betyg = 0 as Response;
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
                        fontWeight: FontWeight.bold,
                        //overflow: TextOverflow.ellipsis,
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
                      RatingBar(
                        minRating:1,
                        maxRating: 5,
                        tapOnlyMode: true,
                        onRatingUpdate: (rating) 
                        {_saveRating(rating as int, detail.recept.id as int ); },
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.star, color: Colors.yellow),
                          half: Icon(Icons.star, color: Colors.grey),
                          empty: Icon(Icons.star, color: Colors.grey)
                        ),
                        itemSize: 20,
                        itemPadding: EdgeInsets.only(left: 5, ),
                      ),
                      
                    SizedBox(width: 10,),
                    Text("("+detail.recept.betyg.toString()+")",
                        style: GoogleFonts.alfaSlabOne(
                        textStyle: const TextStyle(
                        color: Colors.teal,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 30),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text( "Ingredienser",
                        style: GoogleFonts.alfaSlabOne(
                        textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                              children: [
                                Text(detail.recept.instruktion[index],
                                maxLines: 3,
                                style: GoogleFonts.breeSerif(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                
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
                              children: [
                                Text(detail.recept.instruktion[index],
                                maxLines: 3,
                                style: GoogleFonts.breeSerif(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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
                                fontWeight: FontWeight.bold,
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