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
import 'package:first/Services/server_calls.dart';
import 'package:intl/intl.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {


  late String _dateTime;
  late DateTime date;
  late String showDate;

  void _showDatePicker () {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025), 
      
      ).then((value) {
        setState((){
          date = value!;
          showDate = value.toString();
          _dateTime = DateFormat('yyyyMMdd').format(date); 
        });
      });
  }

  void _changeDate (skafferi_id, date, detail) {
    setState(() {
      ServerCall.changeDate(skafferi_id, date);

      });
    
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubits, CubitStates>(builder: (context, state) {
      ProductState detail = state as ProductState;
      showDate = detail.produkt.bastforedatum;
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
              IconButton(onPressed: () { ServerCall.deleteFromPantry(detail.produkt.skafferi_id); BlocProvider.of<AppCubits>(context).goHome(); }, icon: Icon(Icons.delete_outline), color:Colors.teal)
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
                                  _showDatePicker();
                                  _changeDate(detail.produkt.skafferi_id, _dateTime, detail.produkt);
                                  //ServerCall.changeDate(detail.produkt.skafferi_id, _dateTime);
                                  //LoadingState();
                                      },
                                
                                icon: Icon(Icons.edit, color: Colors.black)
                                
                                )
                      
                    
                    ],
                  ),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text(showDate,
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
    
    },
    buildWhen: (previousState, state) {
      return state is ProductState || state is LoadingState;
    }
    );
  }
}