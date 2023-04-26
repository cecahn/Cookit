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

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {

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
                height: 100,
                
              )
            ),
            Positioned(
              left: 20,
              top:20,
              child: Row(
            children: [
              IconButton(onPressed: () { BlocProvider.of<AppCubits>(context).goHome(); }, icon: Icon(Icons.arrow_back_ios), color:Colors.teal)
            ],
              )
            ),
            Positioned(
              right: 20,
              top:20,
              child: Row(
            children: [
              IconButton(onPressed: () { deleteProduct(detail.produkt.gtin); BlocProvider.of<AppCubits>(context).goHome(); }, icon: Icon(Icons.delete_outline), color:Colors.teal)
            ],
              )
            ),

            Positioned(
              top: 50,
              child: Container(
                  
                  padding: const EdgeInsets.only(left:20, right:20, top:10),
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

                        
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(children: [
                      Text("Bäst före datum",
                                style: GoogleFonts.alfaSlabOne(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
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



                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text(detail.produkt.bastforedatum,
                                style: GoogleFonts.breeSerif(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                    ),
                                  ),
                                ),
                    ],),

                    SizedBox(height: 20,),


                    Row(
                              children: [
                                Text("Allergener",
                                style: GoogleFonts.alfaSlabOne(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
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
                                    Text(detail.produkt.allergener[index],
                                    style: GoogleFonts.breeSerif(
                                    textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    ),
                                  ),
                                    ),
                                  ],
                                )
                              );
                            },
                          ),

                        SizedBox(height: 20),

                          Row (
                            children: [
                              Text("Tillverkare",
                                style: GoogleFonts.alfaSlabOne(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          Row (
                            children: [
                              Text(detail.produkt.tillverkare,
                                style: GoogleFonts.breeSerif(
                                textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                               
                                    ),
                                  ),
                                ),
                            ],
                          )
                    
                      
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